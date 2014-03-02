//
//  MapView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/13/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GenericDownloadViewController.h"
#include "Vocabulary.h"
#import "ImageManager.h"
#include "UserContext.h"
#import <MessageUI/MessageUI.h>
#import "GameSequenceManager.h"
#import "MapScrollView.h"

#define cMailInfo @"info@vocabularyTrip.com"

@interface MapView : GenericDownloadViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
  	MapScrollView *__unsafe_unretained mapScrollView;
    UIButton *__unsafe_unretained helpButton;
    UIButton *__unsafe_unretained playCurrentLevelButton;
    bool flagFirstShowInSession;
    
    int startWithHelpPurchase, // when the View did show, the Purchase help is launched. When the user finish his purchase succesfully the user is redirected automatically to LevelView with purchase help
    startWithHelpDownload; // when the View did show, the Download help is launched. When the user is playing and a sound is not loaded from server, the user is redirected automatically to LevelView with download help

}

@property (nonatomic, unsafe_unretained) IBOutlet UIScrollView *mapScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *playCurrentLevelButton;
@property (nonatomic, unsafe_unretained) bool flagFirstShowInSession;

- (IBAction) buyClicked;
- (IBAction) resetButtonClicked;
    
- (void) initMap;
- (void) drawAllLeveles;
- (void) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size;
- (void) addAccessibleIconToLevel: (Level*) level;
- (void) helpAnimation1;
- (void) helpDownload1;
- (void) reloadAllLevels;

- (void) initializeGame;
- (void) initAudioSession;
- (IBAction) changeUserShowInfo: (id) sender;
- (IBAction) mailButtonClicked: (id) sender;
- (IBAction) albumShowInfo: (id) sender;
- (IBAction) playCurrentLevel: (id) sender;
- (void) playChallengeTrain;
- (void) playTrainingTrain;
- (void) showAllMapInFirstSession;

@end