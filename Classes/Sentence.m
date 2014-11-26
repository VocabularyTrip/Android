//
//  Sentence.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "Sentence.h"
#import "UserContext.h"
#import "SentenceManager.h"
//#include <stdlib.h>
//#import <AVFoundation/AVFoundation.h>

@implementation Sentence

@synthesize names;
@synthesize method;
@synthesize type;
@synthesize wasPlayed;


- (bool) checkRestrictionsAndPlay {
    bool soundEnabled = UserContext.soundEnabled == 1;
	bool noRestrictionWithFirstTimeInSession = ![type isEqualToString: @"firstTimeInSession"] || wasPlayed == 0;
	if (!singletonSentenceManager.isPlaying && ([type isEqualToString: @"always"] ||
		(soundEnabled && noRestrictionWithFirstTimeInSession))) {
			singletonSentenceManager.isPlaying = YES;	// To avoid concurrence sentences.
		[self play];
		wasPlayed = YES; // Some sentences are said just the first time (type = firstTimeInSession)
		return YES;
	}
    return NO;
}

- (void) play {
	@try {
		int c = arc4random() % [names count];
		AVAudioPlayer *avAudio = [names objectAtIndex: c];
		avAudio.delegate = self;
		if (avAudio) {
            singletonSentenceManager.currentAudio = avAudio;
            [avAudio play];
        }
	}
	@catch (NSException * e) {
		NSLog(@"Error Sentence.Play");
        singletonSentenceManager.isPlaying = NO;
        singletonSentenceManager.currentAudio = nil;
	}
	@finally {
	}
	
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [singletonSentenceManager audioPlayerDidFinishPlaying];
}


@end
