//
//  Sentence.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "Sentence.h"

#define supportedLanguages @"" // Add in this string all language avilable in sentences. English (en) must not be included.

@interface SentenceManager : NSObject <NSXMLParserDelegate> {

    NSMutableArray *allSentences;
    NSObject* delegate;
    SEL selector; // when the play finish this method is executed on delegate
    
    // This flag is used to avoid concurrent sentences.
    // If isPlaying is YES, no other Sentence can be played and is ignored.
    bool isPlaying;
    AVAudioPlayer *currentAudio; // used to stop audio

}

extern SentenceManager *singletonSentenceManager;

@property (nonatomic, strong) NSMutableArray *allSentences;
@property (nonatomic, strong) NSObject* delegate;
@property (nonatomic) SEL selector;
@property (nonatomic) bool isPlaying;
@property (nonatomic, strong) AVAudioPlayer *currentAudio;

- (Sentence*) getSentenceOfMethod: (NSString*) aMethod;
- (bool) playSpeaker: (NSString*) name;
- (bool) playSpeaker: (NSString*) name delegate: (id) del selector: (SEL) aSelector;
- (void) stopCurrentAudio;
- (void) audioPlayerDidFinishPlaying;

- (void)loadDataFromXML;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
- (NSString*) getLocalizedSentenceName: (NSString*) name;

+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName;
+ (AVAudioPlayer*) getAudioPlayerAtURL: (NSURL*) file_url;

@end
