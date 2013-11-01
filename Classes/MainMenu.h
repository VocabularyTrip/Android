//
//  MainMenu.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTrain.h"
#import "LevelView.h"
#import "AlbumView.h"
#import "TestTrain.h"
#import "TrainingTrain.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "AFOpenFlowView.h"

#define cMailInfo @"info@vocabularyTrip.com"

@interface MainMenu : UIViewController <MFMailComposeViewControllerDelegate, AFOpenFlowViewDelegate, AFOpenFlowViewDataSource> {
	AVAudioPlayer* backgroundSound;
    UIImageView *__unsafe_unretained aNewLanguage;
    UIImageView *__unsafe_unretained backgroundView;
    AFOpenFlowView *__unsafe_unretained albumsView;
}

@property (nonatomic, strong) AVAudioPlayer *backgroundSound;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *aNewLanguage;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet AFOpenFlowView *albumsView;

- (IBAction) changeUserShowInfo:(id)sender;  
- (IBAction) mailButtonClicked:(id)sender;
- (IBAction) trainingTrainShowInfo:(id)sender;
- (IBAction) challengeTrainShowInfo:(id)sender;
- (IBAction) levelShowInfo:(id)sender;
- (IBAction) album1ShowInfo:(id)sender;
- (IBAction) album2ShowInfo:(id)sender;
- (IBAction) album3ShowInfo:(id)sender;
    
- (void) initialize;
- (void) stopBackgroundSound;
- (void) initAudioSession;
- (void) checkNewLanguage;
- (void) newLanguageEnded;

@end
