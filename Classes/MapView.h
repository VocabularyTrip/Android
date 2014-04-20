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


#define cMailInfo @"" // @"info@vocabularyTrip.com"

@interface MapView : UIViewController <UIAlertViewDelegate> {
    
    AVAudioPlayer* backgroundSound;
    CADisplayLink *timerToPlayBackgroundSound;
  	MapScrollView *__unsafe_unretained mapScrollView;
    UIButton *__unsafe_unretained helpButton;
    UIButton *__unsafe_unretained playCurrentLevelButton;
    UIButton *__unsafe_unretained configButton;
    ConfigView *configView;

    bool flagFirstShowInSession;
    int startWithHelpPurchase, // when the View did show, the Purchase help is launched. When the user finish his purchase succesfully the user is redirected automatically to LevelView with purchase help
    startWithHelpDownload; // when the View did show, the Download help is launched. When the user is playiinng and a sound is not loaded from server, the user is redirected automatically to LevelView with download help
    int currentLevelNumber; // Is used to compare if the user getLevel hasChanged --> do animation to advance to next level
    
    bool flagTimeoutStartMusic; // theTimer call immediate. This flat is used to omit it.
}

@property (nonatomic, strong) AVAudioPlayer *backgroundSound;
@property (nonatomic, unsafe_unretained) IBOutlet MapScrollView *mapScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *playCurrentLevelButton;
@property (nonatomic, unsafe_unretained) bool flagFirstShowInSession;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *configButton;
@property (nonatomic, unsafe_unretained) int startWithHelpDownload;

- (IBAction) playCurrentLevel: (id) sender;
- (IBAction) albumShowInfo: (id) sender;
- (ConfigView*) configView;

- (void) initMap;
- (void) reloadAllLevels;
- (void) drawAllLeveles;
- (void) removeAllLevels;
- (void) moveUser;
- (UIImageView*) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size;
- (void) addAccessibleIconToLevel: (Level*) level;
- (void) addProgressLevel: (Level*) level;
- (void) initializeGame;
- (void) initAudioSession;
- (void) stopBackgroundSound;
- (void) startPlayBackgroundSound;

- (void) playChallengeTrain;
- (void) playTrainingTrain;
//- (void) playMemoryTrain;
//- (void) playSimonTrain;

- (void) showAllMapInFirstSession;
- (void) showAllMapFinished;
- (void) helpAnimation1;
- (void) helpDownload1;

- (IBAction) openConfigView;
- (void) initializeTimeoutToPlayBackgroundSound;

@end