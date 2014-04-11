//
//  VocabularyTrip2AppDelegate.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChangeUserView.h"
#import "ChangeLangView.h"
#import "LockLanguageView.h"
#import "SetGameModeView.h"

#import "MapView.h"
#import "LevelView.h"

#import "GenericTrain.h"
#import "TestTrain.h"
#import "TrainingTrain.h"

#import "AlbumView.h"
//#import "MemoryTrain.h"
//#import "SimonTrain.h"
#import "PurchaseProtocol.h"
#import "Language.h"
#import "PromoCode.h"
#import "PurchaseView.h"
#import "Reachability.h"
#import "FacebookManager.h"
#import "AlbumMenu.h"

@class MainMenu;

@interface VocabularyTrip2AppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, PurchaseDelegate> {
    UIWindow *window;
	//MainMenu *mainMenu;
	
	TestTrain *testTrain;
	TrainingTrain *trainingTrain;
	//MemoryTrain *memoryTrain;
	//SimonTrain *simonTrain;
    LevelView *levelView;
	ChangeLangView *changeLangView;
	ChangeUserView *changeUserView;    
    LockLanguageView *lockLanguageView;
    SetGameModeView *gameModeView;
	MapView *mapView;
	AlbumView *albumView;
	PurchaseView *purchaseView;
	AlbumMenu *albumMenu;
	UINavigationController *navController;
    NSDate *startPlaying;
    
    Reachability *internetReachable;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
//@property (nonatomic) MainMenu *mainMenu;
@property (nonatomic) TrainingTrain *trainingTrain;
@property (nonatomic) TestTrain *testTrain;
//@property (nonatomic) MemoryTrain *memoryTrain;
//@property (nonatomic) SimonTrain *simonTrain;
@property (nonatomic) LevelView *levelView;
@property (nonatomic) ChangeLangView *changeLangView;
@property (nonatomic) ChangeUserView *changeUserView;
@property (nonatomic) LockLanguageView *lockLanguageView;
@property (nonatomic) SetGameModeView *gameModeView;
@property (nonatomic) MapView *mapView;
@property (nonatomic) AlbumView *albumView;
@property (nonatomic) PurchaseView *purchaseView;
@property (nonatomic) AlbumMenu *albumMenu;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic, strong) NSDate *startPlaying;
@property (nonatomic) Reachability *internetReachable;

- (void) initUsersDefaults;
- (void) initAllControllers;

- (void) popMainMenu;
- (void) pushLockLanguageView;
- (void) pushChangeLangView;
- (void) pushChangeUserView;
- (void) pushSetGameModeView;
//- (void) pushMapView;
- (void) pushMapViewWithHelpPurchase;
- (void) pushMapViewWithHelpDownload;
- (void) pushPurchaseView;
- (void) pushTestTrain;
//- (void) pushMemoryTrain;
//- (void) pushSimonTrain;
- (void) pushLevelView;
- (void) pushAlbumView;
- (void) pushTrainingTrain;
- (void) popMainMenuFromLevel;
- (void) popMainMenuFromPurchase;
- (void) popMainMenuFromAlbum;
- (void) popMainMenuFromTestTrain;
//- (void) popMainMenuFromMemoryTrain;
//- (void) popMainMenuFromSimonTrain;
- (void) popMainMenuFromTrainingTrain;
- (void) popFromLockLanguageView;
- (void) popMainMenuFromChangeLang;
- (void) popMainMenuFromSetGameMode;
- (void) pushAlbumMenu;
- (void) popMainMenuFromAlbumMenu;
- (void) responseToBuyAction;
- (void) responseToCancelAction;
- (void) checkIfaskToRate;
- (void) askToRate;
- (int) getAppId;
- (void) checkDownloadCompleted;
- (void) alertAskToReview: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) alertBuyNewLevel: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
//- (void) alertDownloadLang: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) checkPromoCodeDueDate;
- (void) checkAPromoCodeForUUID;
- (void) saveTimePlayedInDB;

- (void) initializeInternetReachabilityNotifier;
- (void)checkNetworkStatus:(NSNotification *)notice;


@end

