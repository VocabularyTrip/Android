//
//  MapView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/13/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Vocabulary.h"
#import "ImageManager.h"
#import "UserContext.h"
#import "MapScrollView.h"
#import "AnimatorHelper.h"

#define cMailInfo @"info@vocabularyTrip.com"
#define cMusicVolume 0.6
#define cMusicVolumeOff 0.3

@interface MapView : UIViewController <UIAlertViewDelegate> {
    
  	MapScrollView *__unsafe_unretained mapScrollView;
    UIButton *__unsafe_unretained playCurrentLevelButton;
    
    bool flagFirstShowInSession;
    int currentLevelNumber; // Is used to compare if the user getLevel hasChanged --> do animation to advance to next level
    
    AVAudioPlayer *backgroundSound;
    CADisplayLink *timerToPlayBackgroundSound;
    bool flagTimeoutStartMusic; // theTimer call immediate. This flat is used to omit it.
    
    CADisplayLink *avatarTimer; // Used for avatar animation
    int avatarAnimationSeq;

}

@property (nonatomic, strong) AVAudioPlayer *backgroundSound;
@property (nonatomic, unsafe_unretained) IBOutlet MapScrollView *mapScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *playCurrentLevelButton;
@property (nonatomic, unsafe_unretained) bool flagFirstShowInSession;
@property (nonatomic, unsafe_unretained) bool flagTimeoutStartMusic;

- (IBAction) playCurrentLevel: (id) sender;

// Map
- (void) initMap;
- (void) moveUser;
- (void) moveOffsetToSeeUser: (Level*) aLevel;
- (void) showAllMapInFirstSession;
- (void) showAllMapFinished;

// Background Sound
- (void) initializeTimeoutToPlayBackgroundSound;
- (void) stopBackgroundSound;
- (void) startPlayBackgroundSound;

// Avatar Animation
- (void) initAvatarAnimation;
- (void) initializeAvatarTimer;
- (void) randomAvatarAnimation;

- (void) cancelAllAnimations;
- (void) initAudioSession;

@end