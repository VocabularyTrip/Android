//
//  VocabularyTrip2AppDelegate.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapView.h"
#import "LevelView.h"
#import "ChangeLangView.h"
#import "ChangeUserView.h"
#import "Language.h"
#import "Reachability.h"
#import "Sentence.h"
#import "SentenceManager.h"

@interface VocabularyTrip2AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> { // , PurchaseDelegate
    
    UIWindow *window;
	UINavigationController *navController;
	
    LevelView *levelView;
    ChangeUserView *changeUserView;
    ChangeLangView *changeLangView;
	MapView *mapView;
    
    Reachability *internetReachable;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic) UINavigationController *navController;

@property (nonatomic) LevelView *levelView;
@property (nonatomic) ChangeLangView *changeLangView;
@property (nonatomic) ChangeUserView *changeUserView;
@property (nonatomic) MapView *mapView;

@property (nonatomic) Reachability *internetReachable;

- (void) initUsersDefaultsOnFirstExecutionOrVersionChange;
- (void) pushLevelView;
- (void) pushChangeLangView;
- (void) pushChangeUserView;
- (void) popMapView;
- (void) checkIfaskToRate;
- (void) askToRate;
- (int)  getAppId;
- (bool) checkAndStartDownload;
- (void) initializeInternetReachabilityNotifier;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end

