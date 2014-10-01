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
//#import "AudioPlayerProxy.h"


@interface Sentence : NSObject <AVAudioSessionDelegate, AVAudioPlayerDelegate> {
	NSMutableArray *names; // all alternatives; similar sentences
	//NSString *next;
	NSString *method;
	NSString *type;
	// This flag remember if this sentences was played before. Is used with type firstTimeInSession
	// If the sentence is type firstTimeInSession and wasPlayed = YES, the sentence is going to be ignored
	int wasPlayed;	
	//AudioPlayerProxy* avProxy;
}

@property (nonatomic, strong) NSMutableArray *names;
//@property (nonatomic, strong) NSString *next;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) int wasPlayed;

- (bool) checkRestrictionsAndPlay;
- (void) play;
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
