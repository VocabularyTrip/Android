//
//  AudioPlayerProxy.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 12/2/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioPlayerProxy : NSObject <AVAudioPlayerDelegate> {
	NSString *name;
	AVAudioPlayer* sound;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AVAudioPlayer* sound;

- (void) releaseSound;
@end
