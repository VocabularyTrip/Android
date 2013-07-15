//
//  VocabularyTrip2AppDelegate.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeLangView.h"
#import "ChangeUserView.h"
#import "LockLanguageView.h"
#import "GenericTrain.h"
#import "LevelView.h"
#import "AlbumView.h"
#import "TestTrain.h"
#import "TrainingTrain.h"
#import "PurchaseProtocol.h"
#import "Language.h"
#import "PromoCode.h"
#import "PurchaseView.h"
#import "Reachability.h"

@class MainMenu;

@interface VocabularyTrip2AppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, PurchaseDelegate> {
    UIWindow *window;
	MainMenu *mainMenu;
	
	TestTrain *testTrain;
	TrainingTrain *trainingTrain;
	ChangeLangView *changeLangView;    
	ChangeUserView *changeUserView;    
    LockLanguageView *lockLanguageView;
	LevelView *levelView;
	AlbumView *albumView;
	PurchaseView *purchaseView;
    
	UINavigationController *navController;
    NSDate *startPlaying;
    
    Reachability *internetReachable;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic) MainMenu *mainMenu;
@property (nonatomic) TrainingTrain *trainingTrain;
@property (nonatomic) TestTrain *testTrain;
@property (nonatomic) ChangeLangView *changeLangView;
@property (nonatomic) ChangeUserView *changeUserView;
@property (nonatomic) LockLanguageView *lockLanguageView;
@property (nonatomic) LevelView *levelView;
@property (nonatomic) AlbumView *albumView;
@property (nonatomic) PurchaseView *purchaseView;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic, strong) NSDate *startPlaying;
@property (nonatomic) Reachability *internetReachable;

- (void) initMainMenu;
- (void) initUsersDefaults;
- (void) initAllControllers;
- (void) popMainMenu;
- (void) pushUserLangResumView;
- (void) pushLockLanguageView;
- (void) pushChangeLangView;
- (void) pushChangeUserView;
- (void) pushLevelView;
- (void) pushLevelViewWithHelpPurchase;
- (void) pushLevelViewWithHelpDownload;
- (void) pushPurchaseView;
- (void) pushTestTrain;
- (void) pushAlbumView;
- (void) pushTrainingTrain;
- (void) popMainMenuFromLevel;
- (void) popMainMenuFromPurchase;
- (void) popMainMenuFromAlbum;
- (void) popMainMenuFromTestTrain;
- (void) popMainMenuFromTrainingTrain;
- (void) popFromLockLanguageView;
- (void) popMainMenuFromChangeLang;
    
- (void) responseToBuyAction;
- (void) responseToCancelAction;
//- (bool) existUserData;
- (void) checkIfaskToRate;
- (void) askToRate;
- (int) getAppId;
- (void) checkDownloadCompleted;
- (void) alertAskToReview: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) alertBuyNewLevel: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) alertDownloadLang: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex;
- (void) startLoadingVocabulary;
- (void) checkPromoCodeDueDate;
- (void) checkAPromoCodeForUUID;
- (void) saveTimePlayedInDB;

- (void) initializeInternetReachabilityNotifier;
- (void)checkNetworkStatus:(NSNotification *)notice;


@end

