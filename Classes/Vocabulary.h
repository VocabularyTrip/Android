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
#define cThresholdStar1 0.3
#define cThresholdStar2 0.55
#define cThresholdStar3 0.8

@interface Vocabulary : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate> {
	NSMutableArray *allLevels;
    NSMutableArray *allWords;
    NSMutableArray *oneLevel;
    int levelIndex;
    
    // Variables used to syncronyze download with UI
    int qWordsLoaded; // count the words downloaded. Is used to know if downloading has finished
    int wasErrorAtDownload; // flag to detect an error. Relation asyncronous between Vocabulary and Level
    bool isDownloading; // is true when download is active. is false when an error is detected or 90 words al allready downloaded
    bool isDownloadView; // is true if LevelView is visible and the downloadButton and progressBar exists
        // Is flase when the user press back button and the download continue in background.
    NSMutableArray *responseWithLevelsToDownload;
    CADisplayLink *theTimerToDownloadLevels;

}

extern Vocabulary *singletonVocabulary;

@property (nonatomic, retain) NSMutableArray *allLevels;
@property (nonatomic, retain) NSMutableArray *allWords;
@property (nonatomic, retain) NSMutableArray *oneLevel;
@property (nonatomic, assign) int levelIndex;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained) int wasErrorAtDownload;
@property (nonatomic, assign) bool isDownloading;
@property (nonatomic, assign) bool isDownloadView;
@property (nonatomic, assign) int qWordsLoaded;
@property (nonatomic, retain) NSMutableArray *responseWithLevelsToDownload;
@property (nonatomic, retain) CADisplayLink *theTimerToDownloadLevels;


// Load XML Dictionary
- (void) loadDataFromXML; //
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict; //
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

// Download sounds
+ (int) countOfFilesInLocalPath; //
+ (bool) isDownloadCompleted; //
+ (void) loadDataFromSql; //
+ (void) connectionFinishSuccesfully: (NSDictionary*) response;
+ (void) connectionFinishWidhError:(NSError *) error;
+ (void) setProgress: (float) progress; //

- (void) startDownload;
- (void) downlloadOneLevel;

// Access to Vocabulary
- (void) initializeLevelAt: (int) level; // Initialize the buffer oneLevel
- (Word*) getOrderedWord;
- (double) progressLevel: (int) aLevel;
- (int) countOfLevels;
- (Word*) getWord: (NSString*) name inLevel: (int) level;

@end
