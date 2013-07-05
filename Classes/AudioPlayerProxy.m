//
//  AudioPlayerProxy.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 12/2/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "AudioPlayerProxy.h"
#import "Sentence.h"

@implementation AudioPlayerProxy

@synthesize name;
@synthesize sound;


- (AVAudioPlayer*) sound {
	if (sound == nil) {
		sound = [Sentence getAudioPlayer: name]; 
	}
	return sound;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

- (void) releaseSound {
	sound.delegate = nil;
	sound = nil;
}


@end
