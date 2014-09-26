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
#import "Language.h"
#import "Reachability.h"
#import "Sentence.h"


@interface VocabularyTrip2AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> { // , PurchaseDelegate
    
    UIWindow *window;
	UINavigationController *navController;
	
    LevelView *levelView;
	MapView *mapView;
    
    NSDate *startPlaying;
    Reachability *internetReachable;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic) UINavigationController *navController;

@property (nonatomic) LevelView *levelView;
@property (nonatomic) MapView *mapView;

@property (nonatomic, strong) NSDate *startPlaying;
@property (nonatomic) Reachability *internetReachable;

- (void) initUsersDefaultsOnFirstExecutionOrVersionChange;
- (void) pushLevelView;
- (void) popMapView;
//- (void) responseToBuyAction;
//- (void) responseToCancelAction;
- (void) checkIfaskToRate;
- (void) askToRate;
- (int)  getAppId;
- (void) saveTimePlayedInDB;
- (bool) checkAndStartDownload;
- (void) initializeInternetReachabilityNotifier;
- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) saveTimePlayedInUsersDefaults;

@end

