//
//  VocabularyTrip2AppDelegate.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "VocabularyTrip2AppDelegate.h"

@implementation VocabularyTrip2AppDelegate 

@synthesize window;
@synthesize navController;
@synthesize levelView;
@synthesize changeLangView;
@synthesize changeUserView;
@synthesize mapView;
@synthesize internetReachable;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // ***************************
    // ****** Init Objects *******
    [[UserContext getSingleton] initAllUsers];
    [[UserContext getSingleton] userSelected]; // force load the user selected
    if (!singletonVocabulary) singletonVocabulary = [Vocabulary alloc];
    [self initUsersDefaultsOnFirstExecutionOrVersionChange];
    if (!singletonSentenceManager) singletonSentenceManager = [SentenceManager alloc];
    [singletonVocabulary loadDataFromXML];
    [singletonSentenceManager loadDataFromXML];
    // ****** Init Objects *******
    // ***************************
    
    
    // ****************************
    // ***** Init Controllers *****
	[[UIApplication sharedApplication] setStatusBarHidden: YES];
	navController = [[UINavigationController alloc ] initWithRootViewController: self.mapView];
	[navController setNavigationBarHidden: YES];
	[navController setDelegate: self];
	[window addSubview: [self.navController view]];
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        // use this method on ios6
        [self.window setRootViewController: self.navController];
    }
    [self.window makeKeyAndVisible];
    [self initializeInternetReachabilityNotifier];
    // ***** Init Controllers *****
    // ****************************
    
    return YES;
}

// Added by Facebook Implementation.
// To control facebook page opening
// No behaviour yet
- (BOOL) application: (UIApplication*) application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
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

- (bool) checkAndStartDownload {
    bool connectivity = ([internetReachable currentReachabilityStatus] != NotReachable);
    if (![Vocabulary isDownloadCompleted] && connectivity) {
        if (!singletonVocabulary.isDownloading) {
            singletonVocabulary.delegate = nil;
            singletonVocabulary.isDownloading = YES;
            [Vocabulary loadDataFromSql];
            return true;
        }
    }
    return false;
}

- (void) initUsersDefaultsOnFirstExecutionOrVersionChange {
    // Get current version ("Bundle Version") from the default Info.plist file
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil) {
        // Starting up for first time with NO pre-existing installs
        [[UserContext getSingleton] initGame];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
    }
    else {
        if (![prevStartupVersions containsObject: currentVersion]) {
            // Starting up for first time with this version of the app. This
            // means a different version of the app was alread installed once 
            // and started.
            [[UserContext getSingleton] initGameOnVersionChange];
            NSMutableArray *updatedPrevStartVersions = [NSMutableArray arrayWithArray:prevStartupVersions];
            [updatedPrevStartVersions addObject: currentVersion];
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrevStartVersions forKey:@"prevStartupVersions"];
        }
    }

    // Save changes to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
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

-(LevelView*) levelView {
    if (levelView == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            levelView = [[LevelView alloc] initWithNibName:@"LevelView~ipad" bundle:nil];
        else
            levelView = [[LevelView alloc] initWithNibName:@"LevelView" bundle:nil];
    }
    return levelView;
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

-(ChangeLangView*) changeLangView {
    if (changeLangView == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            changeLangView = [[ChangeLangView alloc] initWithNibName:@"ChangeLangView~ipad" bundle:nil];
        else
            changeLangView = [[ChangeLangView alloc] initWithNibName:@"ChangeLangView" bundle:nil];
    }
    return changeLangView;
}

- (void) pushLevelView {
    [navController pushViewController: self.levelView animated: YES];
}

- (void) pushChangeLangView {
    [navController pushViewController: self.changeLangView animated: YES];
}

- (void) pushChangeUserView {
    [navController pushViewController: self.changeUserView animated: YES];
}

- (void) popMapView {
    [navController popToRootViewControllerAnimated: NO];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    [self checkIfaskToRate];
}

- (int) getAppId {
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"Application Id"];
    return [appId intValue];
}

- (void) checkIfaskToRate {
    
    bool noAskMeAgain = [[NSUserDefaults standardUserDefaults] boolForKey: cNoAskMeAgain];
    if (noAskMeAgain || [self getAppId] == 0) return;
    
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
        cancelButtonTitle: @"Don't ask again"
                          otherButtonTitles: @"Yes, Rate It!", @"Ramind me later", nil];
    [alert show];
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: // Don't ask again
            [[NSUserDefaults standardUserDefaults] setBool: YES forKey: cNoAskMeAgain];
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
        }  default: // Remind me later
            break;
    }
}

@end
