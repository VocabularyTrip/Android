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
#import "GameSequenceManager.h"
#import "MapScrollView.h"
#import "ConfigView.h"
#import "AlbumMenu.h"
#import "AnimatorHelper.h"

#define cMailInfo @"info@vocabularyTrip.com"
#define cMusicVolume 0.6
#define cMusicVolumeOff 0.3

@interface MapView : UIViewController <UIAlertViewDelegate> {
    
  	MapScrollView *__unsafe_unretained mapScrollView;
    UIButton *__unsafe_unretained helpButton;
    UIButton *__unsafe_unretained playCurrentLevelButton;
    ConfigView *configView;
    AlbumMenu *albumMenu;
    UIImageView *__unsafe_unretained hand;
    
    bool flagFirstShowInSession;
    int startWithHelpPurchase, // when the View did show, the Purchase help is launched. When the user finish his purchase succesfully the user is redirected automatically to LevelView with purchase help
    startWithHelpDownload; // when the View did show, the Download help is launched. When the user is playiinng and a sound is not loaded from server, the user is redirected automatically to LevelView with download help
    int currentLevelNumber; // Is used to compare if the user getLevel hasChanged --> do animation to advance to next level
    AVAudioPlayer *backgroundSound;
    CADisplayLink *timerToPlayBackgroundSound;
    bool flagTimeoutStartMusic; // theTimer call immediate. This flat is used to omit it.
    CADisplayLink *theTimer; // Used for avatar animation
    int avatarAnimationSeq;
    float angle;    // Used in helps
    
  	CADisplayLink *helpTimer;
    bool preventOpenLevelView;
}

@property (nonatomic, strong) AVAudioPlayer *backgroundSound;
@property (nonatomic, unsafe_unretained) IBOutlet MapScrollView *mapScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *playCurrentLevelButton;
@property (nonatomic, unsafe_unretained) bool flagFirstShowInSession;
@property (nonatomic, unsafe_unretained) int startWithHelpDownload;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) bool preventOpenLevelView;
@property (nonatomic, unsafe_unretained) bool flagTimeoutStartMusic;

- (IBAction) playCurrentLevel: (id) sender;
- (IBAction) helpClicked;
//- (IBAction) albumShowInfo: (id) sender;
- (ConfigView*) configView;
- (AlbumMenu*) albumMenu;
- (void) initMap;
- (void) initConfigView;
- (void) initAlbumMenu;
- (void) moveUser;
- (void) initializeGame;
- (void) cancelAllAnimations;
- (void) initAudioSession;
- (void) stopBackgroundSound;
- (void) startPlayBackgroundSound;
- (void) playChallengeTrain;
- (void) playTrainingTrain;
- (void) moveOffsetToSeeUser: (Level*) aLevel;
- (void) showAllMapInFirstSession;
- (void) showAllMapFinished;
- (void) initializeTimeoutToPlayBackgroundSound;
- (void) initAvatarAnimation;
- (void) initializeTimer;
- (void) randomAvatarAnimation;

- (void) startHelp;
- (void) helpAnimationPurchase;
- (void) helpAnimation1;
- (void) helpAnimation2;
- (void) helpAnimation2_B;
- (void) helpAnimation3;
- (void) helpAnimation4;
- (void) helpAnimation4_E;

- (void) initializeHelpTimer;


@end