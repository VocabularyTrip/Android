//
//  MainMenu.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTrain.h"
#import "MapView.h"
#import "AlbumView.h"
#import "TestTrain.h"
#import "TrainingTrain.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>

#define cMailInfo @"info@vocabularyTrip.com"

@interface MainMenu : UIViewController <MFMailComposeViewControllerDelegate> {
	AVAudioPlayer* backgroundSound;
    UIImageView *__unsafe_unretained aNewLanguage;
    UIImageView *__unsafe_unretained backgroundView;
	UIButton *__unsafe_unretained albumButton;
    int albumId;
   	CADisplayLink *theTimer;
}

@property (nonatomic, strong) AVAudioPlayer *backgroundSound;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *albumButton;

- (IBAction) changeUserShowInfo:(id)sender;  
- (IBAction) mailButtonClicked:(id)sender;
- (IBAction) trainingTrainShowInfo:(id)sender;
- (IBAction) challengeTrainShowInfo:(id)sender;
//- (IBAction) levelShowInfo:(id)sender;
- (IBAction) albumShowInfo:(id)sender;

- (void) initialize;
- (void) stopBackgroundSound;
- (void) initAudioSession;
- (void) albumFlipAnimation;
- (void) albumFlipAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;
- (void) initializeTimer;

@end
