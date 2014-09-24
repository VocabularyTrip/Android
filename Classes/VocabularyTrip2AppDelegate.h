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
#import "MapView.h"
#import "LevelView.h"
#import "GenericTrain.h"
#import "TestTrain.h"
#import "TrainingTrain.h"
#import "AlbumView.h"
#import "PurchaseProtocol.h"
#import "Language.h"
#import "PurchaseView.h"
#import "Reachability.h"
#import "FacebookManager.h"


@interface VocabularyTrip2AppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, PurchaseDelegate> {
    
    UIWindow *window;
	UINavigationController *navController;
	
	TestTrain *testTrain;
	TrainingTrain *trainingTrain;
    LevelView *levelView;
	ChangeLangView *changeLangView;
	ChangeUserView *changeUserView;    
    LockLanguageView *lockLanguageView;
	MapView *mapView;
	AlbumView *albumView;
	PurchaseView *purchaseView;
    

    NSDate *startPlaying;
    Reachability *internetReachable;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic) UINavigationController *navController;

@property (nonatomic) TrainingTrain *trainingTrain;
@property (nonatomic) TestTrain *testTrain;
@property (nonatomic) LevelView *levelView;
@property (nonatomic) ChangeLangView *changeLangView;
@property (nonatomic) ChangeUserView *changeUserView;
@property (nonatomic) LockLanguageView *lockLanguageView;
@property (nonatomic) MapView *mapView;
@property (nonatomic) AlbumView *albumView;
@property (nonatomic) PurchaseView *purchaseView;

@property (nonatomic, strong) NSDate *startPlaying;
@property (nonatomic) Reachability *internetReachable;

- (void) initUsersDefaultsOnFirstExecutionOrVersionChange;

- (void) pushLockLanguageView;
- (void) pushChangeLangView;
- (void) pushChangeUserView;

- (void) pushMapViewWithHelpDownload;
- (void) pushPurchaseView;
- (void) pushTestTrain;
- (void) pushLevelView;
- (void) pushAlbumView;
- (void) pushTrainingTrain;

- (void) popMainMenu;
- (void) popMainMenuFromLevel;
- (void) popMainMenuFromPurchase;
- (void) popMainMenuFromAlbum;
- (void) popMainMenuFromTestTrain;
- (void) popMainMenuFromTrainingTrain;
- (void) popFromLockLanguageView;
- (void) popMainMenuFromChangeLang;

- (void) responseToBuyAction;
- (void) responseToCancelAction;
- (void) checkIfaskToRate;
- (void) askToRate;
- (int)  getAppId;
- (void) alertAskToReview: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
//- (void) alertBuyNewLevel: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
//- (void) alertDownloadLang: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;

- (void) saveTimePlayedInDB;
- (bool) checkAndStartDownload;
- (void) initializeInternetReachabilityNotifier;
- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) saveTimePlayedInUsersDefaults;

@end

