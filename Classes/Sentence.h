//
//  Sentence.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GenericTrain.h"
#import "AudioPlayerProxy.h"

#define supportedLanguages @"" // Add in this string all language avilable in sentences. English (en) must not be included.

extern NSMutableArray *allSentences;

extern id <GenericTrainDelegate> delegate;

// This flag is used to avoid concurrent sentences.
// If isPlaying is YES, no other Sentence can be played and is ignored.
extern bool isPlaying; 

@interface Sentence : NSObject <NSXMLParserDelegate, AVAudioSessionDelegate, AVAudioPlayerDelegate> {
	NSMutableArray *names;
	NSString *next;
	NSString *method;
	NSString *type;
	// This flag remember if this sentences was played before. Is used with type firstTimeInSession
	// If the sentence is type firstTimeInSession and wasPlayed = YES, the sentence is going to be ignored
	int wasPlayed;	
	AudioPlayerProxy* avProxy;
}

@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSString *next;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) int wasPlayed;

+ (id) delegate;
+ (void) setDelegate: (id) aDelegate;
+ (NSString*) getSentenceName: (NSString*) name;

+ (void)loadDataFromXML;
+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
+ (Sentence*) getSentenceOfMethod: (NSString*) aMethod;
+ (void) testAllSentences;
+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName;
+ (bool) playSpeaker: (NSString*) name;
- (void) play;
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
+ (AVAudioPlayer*) getAudioPlayerRelPath: (NSString*) fileName;
+ (AVAudioPlayer*) getAudioPlayerAtURL: (NSURL*) file_url;
+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName dir: (NSString*) dir;
    
@end
