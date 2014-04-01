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


NSMutableArray *allWords = nil;
NSMutableArray *oneLevel = nil;
int levelIndex=0;

Vocabulary *singletonVocabulary;

@implementation Vocabulary

@synthesize delegate;
@synthesize wasErrorAtDownload;
@synthesize isDownloading;
@synthesize isDownloadView;
@synthesize qWordsLoaded;
@synthesize responseWithLevelsToDownload;
@synthesize theTimerToDownloadLevels;

// ****************************************************************
// Load from Server. The first time is loaded and save localy
// Second time is loaded from xml file
+ (void)loadDataFromSql {

    singletonVocabulary.qWordsLoaded = 0;
    singletonVocabulary.wasErrorAtDownload = 0;

    NSURL *url =
    [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_select.php?rquest=getLevelsForLang", cUrlServer]];
    
    Language *lang = [UserContext getLanguageSelected];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt: lang.key ], @"lang", nil];
    
    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    
    [operation start];
    
}

+ (void) setProgress: (float) progress {
    //NSLog(@"progress: %f", progress);
}

// Response to getLevelsForLang
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    
    singletonVocabulary.responseWithLevelsToDownload = [((NSArray*) response) mutableCopy];
    //for (NSDictionary* value in response) {
    //    [Level loadDataFromSql: [[value objectForKey: @"level_id"] intValue]];
    //}
    [singletonVocabulary startDownload];
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
    
    if ([responseWithLevelsToDownload count] > 0) {
        NSDictionary* value = [responseWithLevelsToDownload lastObject];
        NSLog(@"Download level: %i, order: %i"
              , [[value objectForKey: @"level_id"] intValue]
              , [[value objectForKey: @"level_order"] intValue]);
        [Level loadDataFromSql: [[value objectForKey: @"level_id"] intValue]];
        [responseWithLevelsToDownload removeLastObject];
    } else {
        [theTimerToDownloadLevels invalidate];
        theTimerToDownloadLevels = nil;
    }
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
    
    singletonVocabulary.isDownloading = NO;
    if (singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate downloadFinishWidhError: result];

}

// Load from Server. The first time is loaded and save localy
// ****************************************************************

+ (bool) isDownloadCompleted {
    Language *lang = [UserContext getLanguageSelected];
    if (!lang) return true;
    NSLog(@"In disk: %i, in cloud: %i", [self countOfFilesInLocalPath], lang.qWords);
    return [self countOfFilesInLocalPath] >= lang.qWords;
    //([UserContext getMaxLevel] == 0 ? 1 : 
}
    
+ (int) countOfFilesInLocalPath {
    NSString *path = [Word downloadDestinationPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    return [[fm contentsOfDirectoryAtPath: path error: &err] count];
}

+(void)loadDataFromXML {
	
	if ([allWords count] == 0) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"Dictionary" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
	
		allWords = [[NSMutableArray alloc] init];	
		oneLevel = [[NSMutableArray alloc] init];	
		levelIndex = 0;
	
		[parser setDelegate: self];
		[parser parse];
	}	
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	@try {
		if ([elementName isEqualToString: @"level"]) {

            if (levelIndex!=0) {
                //Level* lastLevel = [UserContext getLevelAt: levelIndex-1];
                Level* lastLevel = [[UserContext getSingleton].allLevels objectAtIndex: levelIndex-1];
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
            
			[UserContext addLevel: newLevel];
		}
		
		if ([elementName isEqualToString: @"word"]) {
			Word *newWord = [Word alloc];
			newWord.name = [attributeDict objectForKey: @"name"];
			newWord.fileName = [attributeDict objectForKey: @"fileName"];
            newWord.order = [[attributeDict objectForKey: @"wordOrder"] intValue];
			newWord.theme = levelIndex;
            //NSLog(@"Word: %@, translations: %i", newWord.name, [newWord.allTranslatedNames count]);
            //if ([newWord.allTranslatedNames count] < [attributeDict count] - 4) // First 4 attr are not translations
            if (levelIndex == 1) // Hardcoded first level, the translations are loaded from XML
                [newWord setAllTranslatedNames: [attributeDict mutableCopy]];
            
            //newWord.localizationName = [self getNativeNameFromLocalization: attributeDict];
			[oneLevel addObject: newWord];
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error Loading Dictionary");
	}
	@finally {
	}
}

+ (int) countOfLevels {
    return levelIndex;
}

+ (void)parserDidEndDocument:(NSXMLParser *)parser {
	[allWords addObject: [oneLevel copy]]; 
	[oneLevel removeAllObjects];
}


+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Vocabulary. Error Parsing at line: %li, column: %li", (long)parser.lineNumber, (long)parser.columnNumber);	
}

+ (void)initializeLevelUntil: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (int i=0; i<=level; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[oneLevel addObject: w ];
		}
	}
}

+ (void)initializeLevelAt: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (w in [allWords objectAtIndex: level]) {
		[oneLevel addObject: w ];
	}
}


+ (Word*) getRandomWordFromLevel: (int) levelNumber {

    if (levelNumber < [allWords count]) {
        NSMutableArray* aLevel = [allWords objectAtIndex: levelNumber];
        int i = arc4random() % [aLevel count];
        return [aLevel objectAtIndex: i];
    } else {
		NSLog(@"Exception: getOrderedWord return nil");
    }
	return nil;
}


+ (Word*) getOrderedWord {
	if ([oneLevel count]>0) {
		Word *w = [oneLevel objectAtIndex: 0];
		[oneLevel removeObjectAtIndex: 0];
		return w;
	} else {
		NSLog(@"Exception: getOrderedWord return nil");
	}
    
	return nil;
}

+ (Word*) getRandomWeightedWord {
	if ([oneLevel count]>0) {
		int i = arc4random() % [self getSumOfAllWeights];
		i = [self getSelectedWordFrom: i];
		if (i >= [oneLevel count]) {
			NSLog(@"Exception: getRandomWeightedWord get an out of index: %i, %lu", i, (unsigned long)[oneLevel count]);
			i=0;	
		}
		Word *w = [oneLevel objectAtIndex: i];
		[oneLevel removeObjectAtIndex: i];
		return w;
	} else {
		NSLog(@"Exception: getRandomWeightedWord return nil");
	}

	return nil;
}

+ (int) getSumOfAllWeights {
	Word *w;
	int total=0;
	for (w in oneLevel) {
		total += w.weight;
	}
	return total;
}

+ (int) getSelectedWordFrom: (int) rWeighted {
	int accumulatedWeight=0, i=0;
	Word *w;	
	for (w in oneLevel) {
		accumulatedWeight += w.weight;
		if (accumulatedWeight > rWeighted) return i;
		i++;
	}
	return 0;
}

+ (void) reloadAllWeigths {
    // Loadweight depends on UserSelected.
    // When the user is changed, the weight has to be reloaded.
	Word *w;
	for (int i=0; i< [Vocabulary countOfLevels]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[w loadWeight];
		}
	}
}

+ (void) resetAllWeigths {
	@try {
		Word *w;
		for (int i=0; i< [Vocabulary countOfLevels]; i++) {
			for (w in [allWords objectAtIndex:i]) {
				[w resetWeight];
			}
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error Initializing Weights");
	}
	@finally {
	}
}

+ (void) testAllSounds {
	Word *w;
	for (int i=0; i< [Vocabulary countOfLevels]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[w.sound play];
		}
	}
}

+ (double) wasLearned {
	int r = 0, total = 0;
	Word *w;
	NSLog(@"******** Was Learned Started: %i", [UserContext getLevelNumber]);
	
	for (int i=0; i<=[UserContext getLevelNumber]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			if (w.weight <= cLearnedWeight) r++; 
			//NSLog(@"Word: %@ Weight: %i", w.name, w.weight);
			total ++;
		}
	}
	if (total == 0) return NO;
	//NSLog(@"Words Learned: %@ Total: %@", [NSString stringWithFormat:@"%i", r], [NSString stringWithFormat:@"%i",total]);
	return ((double) r / (double) total);
}

+ (double) progressIndividualLevel {
	int r = 0, total = 0;
	Word *w;
	
    for (w in [allWords objectAtIndex: [UserContext getLevelNumber]]) {
		if (w.weight <= cLearnedWeight) r++;
		total ++;
	}
	if (total == 0) return NO;
	//NSLog(@"Individual Words Learned: %@ Total: %@", [NSString stringWithFormat:@"%i", r], [NSString stringWithFormat:@"%i",total]);
    double progress = ((double) r / (double) total);
    progress = progress >= cPercentageLearnd ? 1 : progress / cPercentageLearnd;
	return progress;
}

+ (CGRect) resizeProgressFrame: (CGRect) progressFrame toNewProgress: (double) progress progressFill: (CGRect) progressBarFillFrame {

    int deltaWidth = progressBarFillFrame.size.width;
    int deltaX = progressBarFillFrame.origin.x;
    progressFrame.size.width = deltaWidth * (1-progress);
    progressFrame.origin.x = deltaX + (deltaWidth * progress);
    return progressFrame;
}

@end
