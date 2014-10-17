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
@synthesize isDownloadView;
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
                //Level* lastLevel = [UserContext getLevelAt: levelIndex-1];
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
    //NSLog(@"progress: %f", progress);
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
    if (singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate downloadFinishWidhError: result];
    
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

/*- (int) countOfWordsInOneLevel {
    return [oneLevel count];
}*/

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

/*+ (void)initializeLevelUntil: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (int i=0; i<=level; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[oneLevel addObject: w ];
		}
	}
}*/

- (void)initializeLevelAt: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (w in [allWords objectAtIndex: level]) {
		[oneLevel addObject: w ];
	}
}


/*+ (Word*) getRandomWordFromLevel: (int) levelNumber {

    if (levelNumber < [allWords count]) {
        NSMutableArray* aLevel = [allWords objectAtIndex: levelNumber];
        int i = arc4random() % [aLevel count];
        return [aLevel objectAtIndex: i];
    } else {
		NSLog(@"Exception: getOrderedWord return nil");
    }
	return nil;
}*/


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

/*+ (Word*) getRandomWeightedWord {
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
}*/

/*+ (int) getSumOfAllWeights {
	Word *w;
	int total=0;
	for (w in oneLevel) {
		total += w.weight;
	}
	return total;
}*/

/*+ (int) getSelectedWordFrom: (int) rWeighted {
	int accumulatedWeight=0, i=0;
	Word *w;	
	for (w in oneLevel) {
		accumulatedWeight += w.weight;
		if (accumulatedWeight > rWeighted) return i;
		i++;
	}
	return 0;
}*/

/*+ (void) reloadAllWeigths {
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
}*/

/*+ (void) testAllSounds {
	Word *w;
	for (int i=0; i< [Vocabulary countOfLevels]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[w.sound play];
		}
	}
}*/

/*+ (int) getLevelLessLearned {
	double progress;
    double lessProgress = 10000; // progress is between 0 to 1. Init with 1 should be fine.
    int levelSelected;
	for (int i=0; i <= [UserContext getLevelNumber]; i++) {
        progress = [self progressLevel: i];
        if (progress < lessProgress) {
            lessProgress = progress;
            levelSelected = i;
        }
	}
	return levelSelected;
}*/

/*+ (double) wasLearnedLast5Levels {
    int levelFrom = 0;
    if ([UserContext getLevelNumber] > 5) levelFrom = [UserContext getLevelNumber] - 5;
    // include las5 5 levels
    return [self wasLearnedFrom: levelFrom];
}

+ (double) wasLearned {
    // include all levels played from colors to current level
    return [self wasLearnedFrom: 0];
}

+ (double) wasLearnedFrom: (int) startLevel {
	int r = 0, total = 0;
	Word *w;
	//NSLog(@"******** Was Learned Started: %i", [UserContext getLevelNumber]);
	
	for (int i=startLevel; i<=[UserContext getLevelNumber]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			if (w.weight <= cLearnedWeight) r++; 
			//NSLog(@"Word: %@ Weight: %i", w.name, w.weight);
			total ++;
		}
	}
	if (total == 0) return NO;
	//NSLog(@"Words Learned: %@ Total: %@", [NSString stringWithFormat:@"%i", r], [NSString stringWithFormat:@"%i",total]);
	return ((double) r / (double) total);
}*/

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

/*+ (double) progressIndividualLevel {
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
}*/

/*+ (CGRect) resizeProgressFrame: (CGRect) progressFrame toNewProgress: (double) progress progressFill: (CGRect) progressBarFillFrame {

    int deltaWidth = progressBarFillFrame.size.width;
    int deltaX = progressBarFillFrame.origin.x;
    progressFrame.size.width = deltaWidth * (1-progress);
    progressFrame.origin.x = deltaX + (deltaWidth * progress);
    return progressFrame;
}*/

@end
