//
//  LevelView.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/6/11.
//  Copyright 2011 VocabularyTrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>	
#import "UIWheelView.h"
#import "GenericDownloadViewController.h"

@interface LevelView : GenericDownloadViewController {

	UIButton *__unsafe_unretained backButton;

	// ****************
	// ***** Visibles in Debug mode 
	UITextField *__unsafe_unretained levelText;
	UITextField *__unsafe_unretained levelBoughtText;	
	UITextField *__unsafe_unretained prevVersionText;    
	UIButton *__unsafe_unretained saveButton;

	// **********************************
	// The Train ************************
	UIImageView *__unsafe_unretained train;
	UIImageView *__unsafe_unretained wagon1;
	UIImageView *__unsafe_unretained wagon2;
	UIImageView *__unsafe_unretained wagon3;
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
	// The Train ************************
	// **********************************
    
    
	// *****************
	// **** 
	UIButton *__unsafe_unretained word1Button;
	UIButton *__unsafe_unretained word2Button;
	UIButton *__unsafe_unretained word3Button;
	UIButton *__unsafe_unretained wordHelpButton;
	UILabel  *__unsafe_unretained word1Label;
	UILabel  *__unsafe_unretained word2Label;
	UILabel  *__unsafe_unretained word3Label;
	UILabel  *__unsafe_unretained trainLabel;
	UIImageView *__unsafe_unretained coinView;

	UIButton *__unsafe_unretained nextButton;
	UIButton *__unsafe_unretained prevButton;	

	UIImageView *__unsafe_unretained backgroundView;	
	
	UIImageView *__unsafe_unretained imageView;	
	UILabel *__unsafe_unretained wordNamelabel;
	UILabel *__unsafe_unretained nativeWordNamelabel;
    //UIButton *__unsafe_unretained alertDownloadSounds;
    
	NSString *activeConfig;	
	CADisplayLink *theTimer; 
	SystemSoundID pageTurnSoundId;	// Page turn
	
	UIButton *__unsafe_unretained helpButton;
	UIButton *__unsafe_unretained buyButton;
	UIImageView *__unsafe_unretained hand;

	UIImageView *__unsafe_unretained progressBackView;
	UIImageView *__unsafe_unretained progressFillView;
	UIImageView *__unsafe_unretained progressMaskView;
	
	int page, buttonIndex, flagReset, startWithHelpPurchase, startWithHelpDownload;
    float angle;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *levelText;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *prevVersionText;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *levelBoughtText;	
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *saveButton;

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *word1Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *word2Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *word3Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordHelpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *word1Label;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *word2Label;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *word3Label;	
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *trainLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *coinView;


@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *train;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon1;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon2;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon3;
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


@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *prevButton;	
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
	
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *wordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *nativeWordNamelabel;
//@property (nonatomic, unsafe_unretained) IBOutlet UIButton *alertDownloadSounds;

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *buyButton;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int startWithHelpPurchase;
@property (nonatomic, assign) int startWithHelpDownload;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressBackView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressMaskView;


- (IBAction) done:(id)sender;
- (void) cancelAllAnimations;
- (IBAction) testAllSounds: (id)sender;
- (IBAction) word1ButtonClicked;
- (IBAction) word2ButtonClicked;
- (IBAction) word3ButtonClicked;
- (IBAction) prevButtonClicked;
- (IBAction) nextButtonClicked;
- (IBAction) resetButtonClicked;

- (IBAction) buyClicked;

- (void) viewWillAppear:(BOOL)animated;
- (void) viewDidLoad;
- (void) updateLevelSlider;
- (void) refreshLevelInfo;
- (void) refreshPage;
- (void) setImageToButton: (int) i;
- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) showAndSayDictionary: (int) i;
- (void) initializeTimer;
- (void) showAndSayWord;
- (void) cancelAnimation;
- (void) helpLevel: (int) i;
//- (void) showAlertDownloadSounds;
//- (void) alertDownloadSoundsFinished;
- (void) purgeLevel;
- (void) shiftImageAndWordIphone5;
	
- (IBAction) helpClicked;
- (void) helpAnimation1;
- (void) helpAnimation2;
- (void) helpAnimation3;
- (void) helpAnimation4;
- (void) helpAnimation5;
- (void) helpAnimation6;
- (void) helpEnd1;
- (void) helpEnd2;
- (void) helpDownload1;
- (void) helpDownload2;
- (void) helpDownload3;
- (void) helpDownload4;


@end