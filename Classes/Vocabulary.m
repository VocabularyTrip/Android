//
//  Vocabulary.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/30/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Vocabulary.h"
#import "Word.h"
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>	
#import "UserContext.h"

Vocabulary *singletonVocabulary;

@implementation Vocabulary

@synthesize allLevels;
@synthesize allWords;
@synthesize oneLevel;
@synthesize levelIndex;
@synthesize delegate;
@synthesize wasErrorAtDownload;
@synthesize isDownloading;
@synthesize qWordsLoaded;
@synthesize responseWithLevelsToDownload;
@synthesize theTimerToDownloadLevels;

// ****************************************** //
// ******* Load Dictionary from XML ********* //

- (void)loadDataFromXML {
	
	if ([allWords count] == 0) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"Dictionary" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
        
        allLevels = [[NSMutableArray alloc] init];
		allWords = [[NSMutableArray alloc] init];
		oneLevel = [[NSMutableArray alloc] init];
		levelIndex = 0;
        
		[parser setDelegate: self];
		[parser parse];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	@try {
		if ([elementName isEqualToString: @"level"]) {
            
            if (levelIndex!=0) {
                Level* lastLevel = [singletonVocabulary.allLevels objectAtIndex: levelIndex-1];
                lastLevel.size = [oneLevel count];
				[allWords addObject: [oneLevel copy]];
				[oneLevel removeAllObjects];
			}
            
			Level *newLevel;
			newLevel = [Level alloc];
			newLevel.levelName = [attributeDict objectForKey: @"name"];
			newLevel.name = [attributeDict objectForKey: @"name"];
            newLevel.fileName = [attributeDict objectForKey: @"image"];
            newLevel.ipodPlaceInMap = CGPointMake([[attributeDict objectForKey: @"ipodx"] intValue], [[attributeDict objectForKey: @"ipody"] intValue]);
            newLevel.ipadPlaceInMap = CGPointMake([[attributeDict objectForKey: @"ipadx"] intValue], [[attributeDict objectForKey: @"ipady"] intValue]);
            newLevel.order = [[attributeDict objectForKey: @"levelOrder"] intValue];
            newLevel.levelNumber = levelIndex;
            
			levelIndex++;
            
            [singletonVocabulary.allLevels addObject: newLevel];
		}
		
		if ([elementName isEqualToString: @"word"]) {
			Word *newWord = [Word alloc];
			newWord.name = [attributeDict objectForKey: @"name"];
			newWord.fileName = [attributeDict objectForKey: @"fileName"];
            newWord.order = [[attributeDict objectForKey: @"wordOrder"] intValue];
			newWord.theme = levelIndex;
            if (levelIndex == 1) // Hardcoded first level, the translations are loaded from XML
                [newWord setAllTranslatedNames: [attributeDict mutableCopy]];
			[oneLevel addObject: newWord];
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error Loading Dictionary");
	}
	@finally {
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[allWords addObject: [oneLevel copy]];
	[oneLevel removeAllObjects];
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Vocabulary. Error Parsing at line: %li, column: %li", (long)parser.lineNumber, (long)parser.columnNumber);
}

// ******* Load Dictionary from XML ********* //
// ****************************************** //

// ************************************* //
// ******* Download 506 sounds ********* //

+ (bool) isDownloadCompleted {
    Language *lang = [UserContext getLanguageSelected];
    if (!lang) return true;
    NSLog(@"In disk: %i, in cloud: %i", [self countOfFilesInLocalPath], lang.qWords);
    return [self countOfFilesInLocalPath] >= lang.qWords;
}

+ (int) countOfFilesInLocalPath {
    NSString *path = [Word downloadDestinationPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    return [[fm contentsOfDirectoryAtPath: path error: &err] count];
}

+ (void)loadDataFromSql {

    singletonVocabulary.isDownloading = YES;
    singletonVocabulary.qWordsLoaded = 0;
    singletonVocabulary.wasErrorAtDownload = 0;

    NSURL *url =
    [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_vocabulary.php?rquest=getLevelsForLang", cUrlServer]];
    
    Language *lang = [UserContext getLanguageSelected];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt: lang.key ], @"lang", nil];
    
    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    
    [operation start];
}

+ (void) setProgress: (float) progress {
    // NSLog(@"Download progress: %f", progress);
}

// Response to getLevelsForLang
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    singletonVocabulary.responseWithLevelsToDownload = [((NSArray*) response) mutableCopy];
    [singletonVocabulary startDownload];
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
    
    singletonVocabulary.isDownloading = NO;
}

- (void) startDownload {
    // The download is launched each 1.5 second. Otherwize 506 downloads are enqued and after aprox 300 downloads get time out.
    if (theTimerToDownloadLevels == nil) {
		theTimerToDownloadLevels = [CADisplayLink displayLinkWithTarget:self selector:@selector(downlloadOneLevel)];
		theTimerToDownloadLevels.frameInterval = 90;
		[theTimerToDownloadLevels addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) downlloadOneLevel {
    if ([responseWithLevelsToDownload count] > 0 && singletonVocabulary.isDownloading) {
        NSDictionary* value = [responseWithLevelsToDownload lastObject];
        [Level loadDataFromSql: [[value objectForKey: @"level_id"] intValue]];
        [responseWithLevelsToDownload removeLastObject];
    } else {
        [theTimerToDownloadLevels invalidate];
        theTimerToDownloadLevels = nil;
    }
}

// ******* Download 506 sounds ********* //
// ************************************* //

- (int) countOfLevels {
    return levelIndex;
}

- (Word*) getWord: (NSString*) name inLevel: (int) level {
    Word *w;
    for (w in [allWords objectAtIndex: level - 1]) {
        if ([w.name isEqualToString: name]) return w;
    }
	return nil;
}

- (void)initializeLevelAt: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (w in [allWords objectAtIndex: level]) {
		[oneLevel addObject: w ];
	}
}

- (Word*) getOrderedWord {
	if ([oneLevel count]>0) {
		Word *w = [oneLevel objectAtIndex: 0];
		[oneLevel removeObjectAtIndex: 0];
		return w;
	} else {
		NSLog(@"Exception: getOrderedWord return nil");
	}
    
	return nil;
}

- (double) progressLevel: (int) aLevel  {
	int r = 0, total = 0;
	Word *w;
	
    for (w in [allWords objectAtIndex: aLevel]) {
		if (w.weight <= cLearnedWeight) r++;
		total ++;
	}
	if (total == 0) return NO;
    double progress = ((double) r / (double) total);
	return progress;
}

+ (void) resetSoundWords {
    
    // Sounds are lazy initialization. When the language change, sounds has to me loaded again.
    // Otherwize, if you had played with spanish and then changed to english, you will heir the spanish sound when had already loaded
    
    Word* word;
    NSMutableArray* levelWords;
    for (int i=0; i< singletonVocabulary.allWords.count; i++) {
        levelWords = [singletonVocabulary.allWords objectAtIndex: i];
        for (int j=0; j < levelWords.count; j++) {
            word = [levelWords objectAtIndex: j];
            word.sound = nil;
        }
    }
}

@end
