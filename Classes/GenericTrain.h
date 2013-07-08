//
//  GenericTrain.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/26/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>	 
#import <AudioToolbox/AudioToolbox.h>	 
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Vocabulary.h"
#import "LandscapeManager.h"
#import "UIWheelView.h"
#import "ToolbarController.h"
#import "SmokeView.h"

#define cStatusGameIsNone 0
#define cStatusGameIsOn 1
#define cStatusGameIsPaused 2
#define cStatusGameIsIntroducingTrain 3
#define cStatusGameIsTakeoutTrain 4
#define cStatusGameIsMoneyCount 5
#define cStatusGameIsFinished 6
#define cStatusGameIsGoingToNextLevel 7
#define cStatusHelpOn 8

#define cLandscapeOffset -2059
#define cLandscapeOffsetIpad -4813
#define cHitsPerGame 7
//#define cTouchesSimultaneously 3
//#define cWordSizeWidth 99
//#define cWordSizeHeight 111

@protocol GenericTrainDelegate;

@interface GenericTrain : UIViewController <AVAudioSessionDelegate, AVAudioPlayerDelegate> {
	CADisplayLink *theTimer; 

	// **********************************
	// Toolbar **************************
	UIButton *__unsafe_unretained pauseButton;
	UIButton *__unsafe_unretained helpButton;
	UIButton *__unsafe_unretained backButton;
	UIButton *__unsafe_unretained soundButton;
	UIView *__unsafe_unretained money1View;
	UILabel *money1Label;	
	UIView *__unsafe_unretained money2View;
	UILabel *__unsafe_unretained money2Label;	
	UIView *__unsafe_unretained money3View;
	UILabel *__unsafe_unretained money3Label;	
	UIImageView *__unsafe_unretained hand;
	// **********************************	
	
	UIImageView *__unsafe_unretained loadingView;	
	UIImageView *__unsafe_unretained landscape;
	UIImageView *__unsafe_unretained landscapeSky;
	
	// **********************************
	// The Train ************************
	UIImageView *__unsafe_unretained train;
	UIImageView *__unsafe_unretained wagon1;
	UIImageView *__unsafe_unretained wagon2;
	UIImageView *__unsafe_unretained wagon3;
	NSMutableArray *words;
	UIButton *__unsafe_unretained wordButton1;
	UIButton *__unsafe_unretained wordButton2;
	UIButton *__unsafe_unretained wordButton3;
	UIImageView *__unsafe_unretained driverView;
    UIImageView *__unsafe_unretained langView;
    
	UIWheelView *__unsafe_unretained wheel1;
	UIWheelView *__unsafe_unretained wheel2;
	UIWheelView *__unsafe_unretained wheel3;
	UIWheelView *__unsafe_unretained wheel4;
	UIWheelView *__unsafe_unretained wheel5;
	UIWheelView *__unsafe_unretained wheel6;
	UIWheelView *__unsafe_unretained wheel7;
	UIWheelView *__unsafe_unretained wheel8;
	UIWheelView *__unsafe_unretained wheel9;
	UIImageView *__unsafe_unretained railView;
	SmokeView *__unsafe_unretained smokeView;
	// The Train ************************
	// **********************************

	SystemSoundID closeSoundId;
	AVAudioPlayer* trainSound;
    UIButton *__unsafe_unretained alertDownloadSounds;
    
	int gameStatus;
	int viewMode; // 1 when the View is visible, and 0 when is not.
	int qOfImagesRemaining;

	// **********************************
	// hitsOfLevel1 corresponds to images in level 1 to 3. hits 2 from level 4 to 6, and hits 3 from level 7 to 9
	// money is used to refresh moneyLabel one by one. Are used just in refreshMoneyLabels
	int money;
	int hitsOfLevel1;
	int hitsOfLevel2;
	int hitsOfLevel3;		
	// **********************************
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money1View;
@property (nonatomic, strong) IBOutlet UILabel *money1Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money2View;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *money2Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money3View;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *money3Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *landscape;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *landscapeSky;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *pauseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *loadingView;	
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *railView;	
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *soundButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *train;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon1;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon2;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon3;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButton1;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButton2;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButton3;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *driverView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *langView;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel1;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel2;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel3;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel4;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel5;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel6;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel7;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel8;
@property (nonatomic, unsafe_unretained) IBOutlet UIWheelView *wheel9;
@property (nonatomic, unsafe_unretained) IBOutlet SmokeView *smokeView;

@property (nonatomic, assign) SystemSoundID closeSoundId;
@property (nonatomic, assign) int viewMode;
@property (nonatomic, strong) AVAudioPlayer *trainSound;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *alertDownloadSounds;

- (IBAction) done:(id)sender;
- (IBAction) wordButton1Clicked;
- (IBAction) wordButton2Clicked;
- (IBAction) wordButton3Clicked;
- (IBAction) pauseClicked;
- (IBAction) soundClicked;
- (IBAction) helpClicked;
- (IBAction) jumpDownloadDictionary;

- (void) hideAllViews;
- (void) showAllViews;
- (void) shiftTrain: (int) xPix;	
- (void) introduceTrain;
//- (int) windowWidth;
- (void) cancelAllAnimations;
- (void) trainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) moveLandscape;
- (void) landscapeAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) initializeTimer;
- (void) trainLoop;
- (void) initMusicPlayer;
- (void) endGame;
- (void) startGame;
- (void) takeOutTrain;
- (void) takeoutTrainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) initWagons;
- (int) hitsPerGame;
- (Word*) changeImageOn: (UIButton *) aWordButton  id: (int) idButton; 
- (Word*) getNextWord;
- (void) hideWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) showThisWord: (Word*) aWord id: (int) idButton button: (UIButton*) aWordButton context:(void *)context;
- (void) refreshSoundButton;
- (int) hitRate;
- (void) refreshMoneyViews: (NSString*) moneyType;
- (void) refreshMoneyLabels;
- (void) goldAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) refreshMoneyLabelsFinished;
- (void) addMoney;
- (void) incrementHitAtLevel: (int) aLevel;
- (void) setToolbarAlpha: (int) aValue;
- (void) refreshSoundButton;
- (void) alphaByType: (NSString*) moneyType;
- (void) showMoneyViews;
- (void) moveWagon;
- (void) initializeLevel;
- (void) showAlertDownloadSounds;
- (void) alertDownloadSoundsFinished;

@end


@protocol GenericTrainDelegate
- (void) takeOutTrain;
@end


