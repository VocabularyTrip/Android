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
    
    for (NSDictionary* value in response) {
        [Level loadDataFromSql: [[value objectForKey: @"level_id"] intValue]];
    }
    
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
    
    if (singletonVocabulary.delegate)
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
				[allWords addObject: [oneLevel copy]];
				[oneLevel removeAllObjects];
			}
			Level *newLevel;
			newLevel = [Level alloc];
			newLevel.levelName = [attributeDict objectForKey: @"name"];
			newLevel.name = [attributeDict objectForKey: @"image"];

			newLevel.imageLockedName = [attributeDict objectForKey: @"imageLocked"];
			newLevel.imageNotAvailableName = [attributeDict objectForKey: @"imageNotAvailable"];
			levelIndex++;

			[UserContext addLevel: newLevel];
		}
		
		if ([elementName isEqualToString: @"word"]) {
			NSString *wordName = [attributeDict objectForKey: @"name"]; 
			Word *newWord = [Word alloc];
			newWord.name = wordName;
            newWord.allTranslatedNames = attributeDict;
            newWord.localizationName = [self getNativeNameFromLocalization: attributeDict];
			newWord.theme = levelIndex;
			[oneLevel addObject: newWord];
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error Loading Dictionary");
	}
	@finally {
	}
}

+(NSString*) getNativeNameFromLocalization: (NSDictionary *) attributeDict {  
    
    NSString *loc = [UserContext getPreferredLanguage];

    if ([loc isEqualToString: @"zh-Hant"]) return [attributeDict objectForKey: @"Chinese"];
    if ([loc isEqualToString: @"fr"]) return [attributeDict objectForKey: @"French"];
    if ([loc isEqualToString: @"es"]) return [attributeDict objectForKey: @"Spanish"];          
    if ([loc isEqualToString: @"fa"]) return [attributeDict objectForKey: @"Farsi"];          
    if ([loc isEqualToString: @"de"]) return [attributeDict objectForKey: @"German"];
    if ([loc isEqualToString: @"de"]) return [attributeDict objectForKey: @"Italian"];
    if ([loc isEqualToString: @"pt"]) return [attributeDict objectForKey: @"Portuguese"];
    if ([loc isEqualToString: @"ar"]) return [attributeDict objectForKey: @"Arabic"];
    if ([loc isEqualToString: @"he"]) return [attributeDict objectForKey: @"Hebrew"];    
    if ([loc isEqualToString: @"hi"]) return [attributeDict objectForKey: @"Hindi"];   
    if ([loc isEqualToString: @"ja"]) return [attributeDict objectForKey: @"Japanese"];   
    if ([loc isEqualToString: @"ko"]) return [attributeDict objectForKey: @"Korean"];   
    if ([loc isEqualToString: @"ru"]) return [attributeDict objectForKey: @"Russian"];   
    if ([loc isEqualToString: @"ms"]) return [attributeDict objectForKey: @"Malaysian"];   
    if ([loc isEqualToString: @"vi"]) return [attributeDict objectForKey: @"Vietnamese"];   
    
    return [attributeDict objectForKey: @"English"];
}

+ (void)parserDidEndDocument:(NSXMLParser *)parser {
	[allWords addObject: [oneLevel copy]]; 
	[oneLevel removeAllObjects];	
}
	
+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Vocabulary. Error Parsing at line: %i, column: %i", parser.lineNumber, parser.columnNumber);	
}

+ (void)initializeLevelUntil: (int) level {
	Word *w;
	[oneLevel removeAllObjects];
	for (int i=0; i<level; i++) {
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

+ (Word*) getAWord {
	if ([oneLevel count]>0) {
		int i = arc4random() % [self getSumOfAllWeights];
		i = [self getSelectedWordFrom: i];
		if (i >= [oneLevel count]) {
			NSLog(@"Exception: getAWord get an out of index: %i, %i", i, [oneLevel count]);			
			i=0;	
		}
		Word *w = [oneLevel objectAtIndex: i];
		[oneLevel removeObjectAtIndex: i];
		return w;
	} else {
		NSLog(@"Exception: getAWord return nil");
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
	for (int i=0; i< cLastLevel; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[w loadWeight];
		}
	}
}

+ (void) resetAllWeigths {
	@try {
		Word *w;
		for (int i=0; i< cLastLevel; i++) {
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
	for (int i=0; i< cLastLevel; i++) {
		for (w in [allWords objectAtIndex:i]) {
			[w.sound play];
		}
	}
}

+ (double) wasLearned {
	int r = 0, total = 0;
	Word *w;
	//NSLog(@"******** Was Learned Started");
	
	for (int i=0; i<[UserContext getLevel]; i++) {
		for (w in [allWords objectAtIndex:i]) {
			if (w.weight <= cLearnedWeight) r++; 
			//NSLog(@"Word: %@ Weight: %i Retain: %i", w.name, w.weight, [w retainCount]);
			total ++;
		}
	}
	if (total == 0) return NO;
	//NSLog(@"Words Learned: %@ Total: %@", [NSString stringWithFormat:@"%i", r], [NSString stringWithFormat:@"%i",total]);	
	return ((double) r / (double) total);
}

+ (double) progressIndividualLevel {
    // This forma works if all Levels are cSizeOfEachLevel
    double progress = 0;
    double hitsOneLevel = [self wasLearned] * [UserContext getLevel] * cSizeOfEachLevel;
    NSLog(@"Was Learned: %f, Level: %i, hist one Level: %f",[self wasLearned], [UserContext getLevel], hitsOneLevel);
    progress = (hitsOneLevel - ([UserContext getLevel] - 1) * cSizeOfEachLevel)/10;
    
    NSLog(@"Progress: %f", progress);
    if (progress <= 0) progress = 0.03;
    return progress / cPercentageLearnd;
}

@end
