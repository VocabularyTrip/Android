//
//  VocabularyTrip2AppDelegate.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "VocabularyTrip2AppDelegate.h"
#import "MainMenu.h"
#import "TraceWS.h"

@implementation VocabularyTrip2AppDelegate 

@synthesize window;
//@synthesize mainMenu;
@synthesize trainingTrain;
@synthesize testTrain;
@synthesize memoryTrain;
@synthesize simonTrain;
@synthesize changeLangView;
@synthesize changeUserView;
@synthesize lockLanguageView;
@synthesize gameModeView;
@synthesize mapView;
@synthesize purchaseView;
@synthesize albumView;
@synthesize albumMenu;
@synthesize navController;
@synthesize startPlaying;
@synthesize internetReachable;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[[UIApplication sharedApplication] setStatusBarHidden: YES];

    [User loadDataFromXML]; // initialize users variable
    [[UserContext getSingleton] userSelected]; // force load the user selected
    [[UserContext getLanguageSelected] countOfWords]; // start request to the server

    if (!singletonVocabulary) // Initialize singletonVocabulary
        singletonVocabulary = [Vocabulary alloc];
    
    //[Language requestAllLanguages];
    [self initUsersDefaults];
	[self initAllControllers];	
	[self checkIfaskToRate];
    [self checkAPromoCodeForUUID];
    [self checkPromoCodeDueDate];
    [self checkDownloadCompleted];
    [self initializeInternetReachabilityNotifier];
    
    [FacebookManager initFacebookSession];    
    
	UIView *aView = [self.navController view];
	[window addSubview: aView];
    
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
        // warning: addSubView doesn’t work on iOS6
        [self.window addSubview: aView];
    }
    else {
        // use this method on ios6
        [self.window setRootViewController: self.navController];
    }

	[self saveTimePlayedInDB];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// Addeb by Facebook Implementation.
// To control facebook page opening
// No behaviour yet
- (BOOL) application: (UIApplication*) application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [FBAppCall handleOpenURL: url sourceApplication: sourceApplication fallbackHandler:^(FBAppCall *call) {
        if (call.appLinkData && call.appLinkData.targetURL) {
            [[NSNotificationCenter defaultCenter] postNotificationName: APP_HANDLED_URL object: call.appLinkData.targetURL];
        }
    }];
    return YES;
}

- (void) initializeInternetReachabilityNotifier {
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    // Set up Reachability
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            
            NSLog(@"The internet is working via WIFI");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN!");
            break;
        }
    }
}

- (void) saveTimePlayedInDB {
    int i = [[NSUserDefaults standardUserDefaults] integerForKey: cLastTimePlayed];
    if (i!=0) {
        Language *lang = [UserContext getLanguageSelected];
        [TraceWS register: @"applicationWillTerminate" valueStr: lang.name valueNum: [NSNumber numberWithInt: i]];
    }
	self.startPlaying = [NSDate date];
}


-(void) checkPromoCodeDueDate {
    [PromoCode checkPromoCodeDueDate];
}

- (void) checkAPromoCodeForUUID {
    [PromoCode checkAPromoCodeForUUID];    
}

- (void) checkDownloadCompleted {
    
    //double wasLearnedResult = [Vocabulary wasLearned];
    // Check Download complete only if advance to level 2 is unlock and at least is close to level 2
    //if (!([UserContext getMaxLevel] >= 6) ||
    //    (wasLearnedResult < cPercentageCloseToLearnd && [UserContext getLevelNumber] == 1)
    //    ) return;
    
    if (![Vocabulary isDownloadCompleted]) {

        //singletonVocabulary.delegate = nil;
        //singletonVocabulary.isDownloadView = NO;
        singletonVocabulary.isDownloading = YES;
        //NSLog(@"IsDownloading: %i", singletonVocabulary.isDownloading);
        [Vocabulary loadDataFromSql];
        
        /*Language *lang = [UserContext getLanguageSelected];
        NSString *message = [NSString stringWithFormat: @"Downloading %@ did not complete. Do you want to restart it?", lang.name];
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle: cAskToRedownloadTitle
                              message: message
                              delegate:self 
                              cancelButtonTitle: @"NO" 
                              otherButtonTitles: @"YES", nil];
        [alert show];*/
    }
}

- (void) initUsersDefaults {
    // Get current version ("Bundle Version") from the default Info.plist file
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil) {
        // Starting up for first time with NO pre-existing installs (e.g., fresh 
        // install of some version)
        
        // First installation did't have this control. So the prevStartupVersion could be nil and not be the first time.
        [TraceWS register: @"First Execution" valueStr: currentVersion valueNum: [NSNumber numberWithInt: 0]];
        
        if (![UserContext existUserData])
            [[UserContext getSingleton] initGame];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
    }
    else {
        if (![prevStartupVersions containsObject: currentVersion]) {
            // Starting up for first time with this version of the app. This
            // means a different version of the app was alread installed once 
            // and started.
            //[self firstStartAfterUpgradeDowngrade];
            [TraceWS register: @"First Execution of new Version" valueStr: currentVersion valueNum: [NSNumber numberWithInt: 0]];
            NSMutableArray *updatedPrevStartVersions = [NSMutableArray arrayWithArray:prevStartupVersions];
            [updatedPrevStartVersions addObject: currentVersion];
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrevStartVersions forKey:@"prevStartupVersions"];
        }
    }

    // Save changes to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) initAllControllers {
	
	[[self mapView] initializeGame];
    [self mapView].flagFirstShowInSession = YES;
    
	navController = [[UINavigationController alloc ] initWithRootViewController: mapView];
	[navController setNavigationBarHidden: YES];
	[navController setDelegate: self];
	
}

-(MapView*) mapView {
	if (mapView == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			mapView = [[MapView alloc] initWithNibName:@"MapView~ipad" bundle: nil];
		else
			mapView = [[MapView alloc] initWithNibName:@"MapView" bundle: nil];
	}
	return mapView;
}

-(PurchaseView*) purchaseView {
	if (purchaseView == nil) {	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			purchaseView = [[PurchaseView alloc] initWithNibName:@"PurchaseView~ipad" bundle:nil];
		else
			purchaseView = [[PurchaseView alloc] initWithNibName:@"PurchaseView" bundle:nil];
	}
	return purchaseView;
}

-(ChangeLangView*) changeLangView {
	if (changeLangView == nil) {	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			changeLangView = [[ChangeLangView alloc] initWithNibName:@"ChangeLangView~ipad" bundle:nil];
		else
			changeLangView = [[ChangeLangView alloc] initWithNibName:@"ChangeLangView" bundle:nil];
	}
	return changeLangView;
}

-(ChangeUserView*) changeUserView {
	if (changeUserView == nil) {	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			changeUserView = [[ChangeUserView alloc] initWithNibName:@"ChangeUserView~ipad" bundle:nil];
		else
			changeUserView = [[ChangeUserView alloc] initWithNibName:@"ChangeUserView" bundle:nil];
	}
	return changeUserView;
}

-(LockLanguageView*) lockLanguageView {
	if (lockLanguageView == nil) {	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			lockLanguageView = [[LockLanguageView alloc] initWithNibName:@"LockLanguageView~ipad" bundle:nil];
		else
			lockLanguageView = [[LockLanguageView alloc] initWithNibName:@"LockLanguageView" bundle:nil];
	}
	return lockLanguageView;
}

-(SetGameModeView*) gameModeView {
	if (gameModeView == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			gameModeView = [[SetGameModeView alloc] initWithNibName:@"SetGameModeView~ipad" bundle:nil];
		else
			gameModeView = [[SetGameModeView alloc] initWithNibName:@"SetGameModeView" bundle:nil];
	}
	return gameModeView;
}

-(AlbumView*) albumView {
	if ( albumView == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			albumView = [[AlbumView alloc] initWithNibName:@"AlbumView~ipad" bundle:nil];
		else
			albumView = [[AlbumView alloc] initWithNibName:@"AlbumView" bundle:nil];
		[albumView initialize];
	}
	return albumView;
}

-(AlbumMenu*) albumMenu {
	if ( albumMenu == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			albumMenu = [[AlbumMenu alloc] initWithNibName:@"AlbumMenu~ipad" bundle:nil];
		else
			albumMenu = [[AlbumMenu alloc] initWithNibName:@"AlbumMenu" bundle:nil];
	}
	return albumMenu;
}

-(TestTrain*) testTrain {
	if (testTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			testTrain = [[TestTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle:nil];
		else
			testTrain = [[TestTrain alloc] initWithNibName:@"GenericTrain" bundle:nil];
	}
	return testTrain;
}

-(MemoryTrain*) memoryTrain {
	if (memoryTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			memoryTrain = [[MemoryTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle:nil];
		else
			memoryTrain = [[MemoryTrain alloc] initWithNibName:@"GenericTrain" bundle:nil];
	}
	return memoryTrain;
}

-(SimonTrain*) simonTrain {
	if (simonTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			simonTrain = [[SimonTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle:nil];
		else
			simonTrain = [[SimonTrain alloc] initWithNibName:@"GenericTrain" bundle:nil];
	}
	return simonTrain;
}


-(TrainingTrain*) trainingTrain {
	if (trainingTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)		
			trainingTrain = [[TrainingTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle: nil];
		else
			trainingTrain = [[TrainingTrain alloc] initWithNibName:@"GenericTrain" bundle: nil];
		}
	return trainingTrain;
}

- (void) pushChangeLangView {
	[navController pushViewController: self.changeLangView animated: YES];
}

- (void) pushChangeUserView {
	[navController pushViewController: self.changeUserView animated: YES];
}

- (void) pushLockLanguageView {
	[navController pushViewController: self.lockLanguageView animated: YES];
}

- (void) pushSetGameModeView {
	[navController pushViewController: self.gameModeView animated: YES];
}

- (void) pushAlbumView {
	[navController pushViewController: self.albumView animated: YES];
}

- (void) pushAlbumMenu {
	[navController pushViewController: self.albumMenu animated: YES];
}

/*- (void) pushMapView {
	[navController pushViewController: self.mapView animated: YES];
}*/

- (void) pushMapViewWithHelpPurchase {
//    self.mapView.startWithHelpPurchase = 1;
  	[navController popViewControllerAnimated: NO];
	//[navController pushViewController: self.mapView animated: YES];
}

- (void) pushMapViewWithHelpDownload {
    self.mapView.startWithHelpDownload = 1;
  	[navController popViewControllerAnimated: NO];
	//[navController pushViewController: self.mapView animated: YES];
}


- (void) pushPurchaseView {
	[navController pushViewController: self.purchaseView animated: YES];
}

- (void) pushTestTrain {
	[navController pushViewController: self.testTrain animated: NO];
}

- (void) pushMemoryTrain {
	[navController pushViewController: self.memoryTrain animated: NO];
}

- (void) pushSimonTrain {
	[navController pushViewController: self.simonTrain animated: NO];
}

- (void) pushTrainingTrain {
	[navController pushViewController: self.trainingTrain animated: NO];
}

- (void) popMainMenu {
	[navController popViewControllerAnimated: NO];
}

- (void) popMainMenuFromChangeLang {
  	[navController popViewControllerAnimated: NO];
	[self popMainMenu]; // Pop Select User
	changeLangView = nil;
}

- (void) popFromLockLanguageView {
  	[navController popViewControllerAnimated: NO];
	lockLanguageView = nil;
}

- (void) popMainMenuFromSetGameMode {
  	[navController popViewControllerAnimated: NO];
	[self popMainMenu]; // Pop Select Lang
    [self popMainMenu]; // Pop Select User
	gameModeView = nil;
}


- (void) popMainMenuFromLevel {
	[self popMainMenu];
	mapView = nil;
}

- (void) popMainMenuFromPurchase {
	[self popMainMenu];
	purchaseView = nil;
}

- (void) popMainMenuFromAlbum {
	[self popMainMenu];
	albumView = nil;
}

- (void) popMainMenuFromAlbumMenu {
	[self popMainMenu];
	albumMenu = nil;
}

- (void) popMainMenuFromTestTrain {
	[self popMainMenu];
	Sentence.delegate = nil;
	testTrain = nil;
}

- (void) popMainMenuFromMemoryTrain {
	[self popMainMenu];
	Sentence.delegate = nil;
	memoryTrain = nil;
}

- (void) popMainMenuFromSimonTrain {
	[self popMainMenu];
	Sentence.delegate = nil;
	simonTrain = nil;
}

- (void) popMainMenuFromTrainingTrain {
	[self popMainMenu];
	Sentence.delegate = nil;	
	trainingTrain = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	//[mainMenu.backgroundSound pause];
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    if ([alertView.title isEqualToString: cAskToReviewTitle]) {
        [self alertAskToReview: alertView clickedButtonAtIndex: buttonIndex];
    //} else if ([alertView.title isEqualToString: cAskToRedownloadTitle]) {
    //    [self alertDownloadLang: alertView clickedButtonAtIndex: buttonIndex];
    } else if ([alertView.title isEqualToString: cNotifyToPromoCodeDetected]) {        
    } else if ([alertView.title isEqualToString: cNotifyToPromoCodeLimited]) {        
    } else {
        [self alertBuyNewLevel: alertView clickedButtonAtIndex: buttonIndex];
    }
}

- (void) alertAskToReview: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: // Remind me later
            break;
        case 1: { // Rate It
            int appId = [self getAppId];
            //NSString *url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%i", appId];
            
            NSString *url;
            if ([UserContext osVersion] >= 7)
                url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%i", appId];
            else
                url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%i", appId];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            [[NSUserDefaults standardUserDefaults] setBool: YES forKey: cNoAskMeAgain];
            break;
        }  default: // Don't ask again
            //[[NSUserDefaults standardUserDefaults] setBool: YES forKey: cNoAskMeAgain];
            break;
    }
}

- (void) alertBuyNewLevel: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    // Alert To buy new level. From TestTrain 
    VocabularyTrip2AppDelegate *vcDelegate;
    vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    switch (buttonIndex) {
            //case 0:
            //	break;
        default:
            // If the user confirme the purchase, the user has to be redirected to the LevelView to see the help
            //[vcDelegate.mainMenu stopBackgroundSound];
          	[navController pushViewController: self.mapView animated: NO];
            [vcDelegate pushPurchaseView];
            break;
    }	
}

/*- (void) alertDownloadLang: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: // Don't Download !
            break;
        case 1:  { // Download
            VocabularyTrip2AppDelegate *vcDelegate;
            vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
            [vcDelegate pushMapViewWithHelpDownload];
            break;
        }            
        default: 
            break;
    }
}*/

- (int) getAppId {
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"Application Id"];
    return [appId intValue];
}
                     
- (void) responseToBuyAction {
	
	if ([UserContext nextLevel])
		[Sentence playSpeaker: @"AppDelegate-ResponseToBuyAction-NextLevel"];
	
	// If the actual view is LevelView, send responseToBuyAction to refresh level information
	if ([[navController topViewController] isKindOfClass: [PurchaseView class]])
		[(PurchaseView*) [navController topViewController] responseToBuyAction];
}

- (void) responseToCancelAction {
}    

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSTimeInterval timePlayed = [self.startPlaying timeIntervalSinceNow];
    [[NSUserDefaults standardUserDefaults] setInteger: timePlayed forKey: cLastTimePlayed];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[FBSession activeSession] close];
}

- (void) checkIfaskToRate {
    
    //bool noAskMeAgain = [[NSUserDefaults standardUserDefaults] boolForKey: cNoAskMeAgain];
    //if (noAskMeAgain || [self getAppId] == 0) return;
    
	int countExecutions = [[NSUserDefaults standardUserDefaults] integerForKey: cCountExecutions];
    
    int delta = (countExecutions / cAskRateEachTimes);
    delta = countExecutions - (delta * cAskRateEachTimes);
    if (delta == cAskRateEachTimes - 1) 
        [self askToRate];

    countExecutions++;

    [[NSUserDefaults standardUserDefaults] setInteger: countExecutions forKey: cCountExecutions];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) askToRate {
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*)kCFBundleNameKey];
    NSString *message = [NSString stringWithFormat: @"If you enjou using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support !", appName];
    
    UIAlertView *alert = [[UIAlertView alloc] 
        initWithTitle: cAskToReviewTitle 
        message: message
        delegate:self 
        cancelButtonTitle: @"Ramind me later" 
                          otherButtonTitles: @"Yes, Rate It!", nil]; //, @"Don't ask again", nil];
    [alert show];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




@end
