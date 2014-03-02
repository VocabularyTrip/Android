//
//  Vocabulary.h
//  VocabularyTrip2
// e2cc6deeb5474857f1bfbd40b75be7d3c0759b0d
//  Created by Ariel Jadzinsky on 6/30/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFProxy.h"
#import "DownloadProtocol.h"
#import "SBJSON.h"
#import "Word.h"


#define cPercentageLearnd 0.8
#define cPercentageCloseToLearnd 0.65

extern NSMutableArray *allWords;
extern NSMutableArray *oneLevel; 
extern int levelIndex;	

extern id <DownloadDelegate> downloadDelegate;

@interface Vocabulary : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate> {

    // Variables used to syncronyze download with UI
    id <DownloadDelegate> __unsafe_unretained delegate; // View to delegate response
    int qWordsLoaded; // count the words downloaded. Is used to know if downloading has finished
    int wasErrorAtDownload; // flag to detect an error
    bool isDownloading; // is true when download is active. is false when an error is detected or 90 words al allready downloaded
    bool isDownloadView; // is true if LevelView is visible and the downloadButton and progressBar exists
        // Is flase when the user press back button and the download continue in background.
}

extern Vocabulary *singletonVocabulary;

@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained) int wasErrorAtDownload;
@property (nonatomic, assign) bool isDownloading;
@property (nonatomic, assign) bool isDownloadView;
@property (nonatomic, assign) int qWordsLoaded;

+ (void) loadDataFromXML; //
+ (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict; //
+ (Word*) getOrderedWord;
+ (Word*) getRandomWeightedWord; //
+ (Word*) getRandomWordFromLevel: (int) levelNumber;
+ (void)parserDidEndDocument:(NSXMLParser *)parser;
+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
+ (void) initializeLevelUntil: (int) level; // Initialize all words form level 1 to the parameter  
+ (void) initializeLevelAt: (int) level; // Initialize all word in the parameter level. In general are 10 words
+ (int) getSumOfAllWeights; //
+ (int) getSelectedWordFrom: (int) rWeighted; //
+ (void) resetAllWeigths; //
+ (void) reloadAllWeigths; //
+ (void) testAllSounds; //
+ (double) wasLearned; //
+ (double) progressIndividualLevel;
//+ (NSString*) getTranslatedName: (NSDictionary *) attributeDict;

//+ (void) setDelegate: (id<DownloadDelegate>) delegate;

+ (void) loadDataFromSql; //
+ (void) connectionFinishSuccesfully: (NSDictionary*) response;
+ (void) connectionFinishWidhError:(NSError *) error;

+ (void) setProgress: (float) progress; //
+ (int) countOfFilesInLocalPath; //
+ (bool) isDownloadCompleted; //
+ (int) countOfLevels;

@end
