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
@synthesize mainMenu;
@synthesize trainingTrain;
@synthesize testTrain;
@synthesize changeLangView;
@synthesize changeUserView;
@synthesize userLangResumeView;
@synthesize lockLanguageView;
@synthesize levelView;
@synthesize purchaseView;
@synthesize albumView;
@synthesize navController;
@synthesize startPlaying;

#pragma mark -
#pragma mark Application lifecycle



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[[UIApplication sharedApplication] setStatusBarHidden: YES];

    [User loadDataFromXML]; // initialize users variable
    [[UserContext getSingleton] userSelected]; // force load the user selected
    [[UserContext getLanguageSelected] countOfWords]; // start request to the server

    //[Language requestAllLanguages];
    [self initUsersDefaults];
	[self initAllControllers];	
	[self checkIfaskToRate];
    [self checkAPromoCodeForUUID];
    [self checkPromoCodeDueDate];
    [self checkDownloadCompleted];
    
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

-(void) saveTimePlayedInDB {
    int i = [[NSUserDefaults standardUserDefaults] integerForKey: cLastTimePlayed];
    if (i!=0) {
        Language *lang = [UserContext getLanguageSelected];
        [TraceWS register: @"applicationWillTerminate" valueStr: lang.name valueNum: [NSNumber numberWithInt: i]];
    }
	self.startPlaying = [NSDate date];
}

-(void) checkPromoCodeDueDate {

    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSDate *date =
       [pref objectForKey: cPromoCodeExpireDate];
    if (date) {
        NSString *message;
        if (date && [date compare: [NSDate date]] == NSOrderedAscending) {
           [[UserContext getSingleton] setMaxLevel: 0];
           [pref removeObjectForKey: cPromoCodeExpireDate];
           [pref synchronize];
           message = cPromoCodeStatusFinished;
        } else {
           int days = [date timeIntervalSinceNow] / 86400;
           message = [NSString stringWithFormat: @"You have access to full content for %i days", days];
        }
        [pref setObject: message forKey: cPromoCodeStatus];
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle: cNotifyToPromoCodeLimited
                              message: message
                              delegate: self 
                              cancelButtonTitle: @"OK" 
                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void) checkAPromoCodeForUUID {
    [PromoCode checkAPromoCodeForUUID];    
}

- (void) checkDownloadCompleted {
    if (!([UserContext getMaxLevel] >= 6)) return;
    if (![Vocabulary isDownloadCompleted]) {

        Language *lang = [UserContext getLanguageSelected];
        NSString *message = [NSString stringWithFormat: @"Downloading %@ did not complete. Do you want to restart it?", lang.name];
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle: cAskToRedownloadTitle
                              message: message
                              delegate:self 
                              cancelButtonTitle: @"NO" 
                              otherButtonTitles: @"YES", nil];
        [alert show];
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

/*- (bool) existUserData {
    bool money = 
        (UserContext.getMoney1 != 0) || 
        (UserContext.getMoney2 != 0) || 
        (UserContext.getMoney3 != 0);
    
  	Album* albumTemp = [Album alloc];
	bool figurines = [albumTemp checkAnyBought: cAlbum1];
	[albumTemp release];
    
	albumTemp = [Album alloc];
	figurines = figurines || [albumTemp checkAnyBought: cAlbum2];
	[albumTemp release];
  
    return money || figurines;
}*/

- (void) initAllControllers {
	
	[self initMainMenu];

	navController = [[UINavigationController alloc ] initWithRootViewController: mainMenu];
	[navController setNavigationBarHidden: YES];
	[navController setDelegate: self];
	
}

-(void) initMainMenu {
	if (mainMenu == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)	
			mainMenu = [[MainMenu alloc] initWithNibName: @"MainMenu~ipad" bundle: [NSBundle mainBundle]];
		else
			mainMenu = [[MainMenu alloc] initWithNibName: @"MainMenu" bundle: [NSBundle mainBundle]];
		[mainMenu initialize];
	}
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

-(UserLangResumeView*) userLangResumeView {
	if (userLangResumeView == nil) {	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			userLangResumeView = [[UserLangResumeView alloc] initWithNibName:@"UserLangResumeView~ipad" bundle:nil];
		else
			userLangResumeView = [[UserLangResumeView alloc] initWithNibName:@"UserLangResumeView" bundle:nil];
	}
	return userLangResumeView;
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

-(TestTrain*) testTrain {
	if (testTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			testTrain = [[TestTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle:nil];
		else
			testTrain = [[TestTrain alloc] initWithNibName:@"GenericTrain" bundle:nil];
	}
	return testTrain;
}

-(TrainingTrain*) trainingTrain {
	if (trainingTrain == nil) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)		
			trainingTrain = [[TrainingTrain alloc] initWithNibName:@"GenericTrain~ipad" bundle:nil];
		else
			trainingTrain = [[TrainingTrain alloc] initWithNibName:@"GenericTrain" bundle:nil];
		}
	return trainingTrain;
}

- (void) pushUserLangResumView {
	[navController pushViewController: self.userLangResumeView animated: YES];
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

- (void) pushAlbumView {
	[navController pushViewController: self.albumView animated: YES];
}

- (void) pushLevelView {
	[navController pushViewController: self.levelView animated: YES];
}

- (void) pushPurchaseView {
	[navController pushViewController: self.purchaseView animated: YES];
}

- (void) pushTestTrain {
	[navController pushViewController: self.testTrain animated: NO];
}

- (void) pushTrainingTrain {
	[navController pushViewController: self.trainingTrain animated: NO];
}

- (void) popMainMenu {
	[navController popViewControllerAnimated: NO];
}

/*- (void) popMainMenuFromChangeLang {
  	[navController popViewControllerAnimated: NO];
	[self popMainMenu];
	[changeLangView release];
	changeLangView = nil;
}*/

- (void) popMainMenuFromUserLangResume {
  	[navController popViewControllerAnimated: NO];
  	[navController popViewControllerAnimated: NO];    
	[self popMainMenu];
	userLangResumeView = nil;
}

- (void) popFromLockLanguageView {
  	[navController popViewControllerAnimated: NO];
	lockLanguageView = nil;
}

- (void) popMainMenuFromLevel {
	[self popMainMenu];
	levelView = nil;
}

- (void) popMainMenuFromPurchase {
	[self popMainMenu];
	purchaseView = nil;
}

- (void) popMainMenuFromAlbum {
	[self popMainMenu];
	albumView = nil;
}

- (void) popMainMenuFromTestTrain {
	[self popMainMenu];
	Sentence.delegate = nil;
	testTrain = nil;
}

- (void) popMainMenuFromTrainingTrain {
	[self popMainMenu];
	Sentence.delegate = nil;	
	trainingTrain = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[mainMenu.backgroundSound pause];
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    if ([alertView.title isEqualToString: cAskToReviewTitle]) {
        [self alertAskToReview: alertView clickedButtonAtIndex: buttonIndex];
    } else if ([alertView.title isEqualToString: cAskToRedownloadTitle]) {
        [self alertDownloadLang: alertView clickedButtonAtIndex: buttonIndex];
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
            NSString *url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%i", appId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            break;
        }  default: // Don't ask again
            [[NSUserDefaults standardUserDefaults] setBool: YES forKey: cNoAskMeAgain];
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
            [vcDelegate pushPurchaseView];
            break;
    }	
}

- (void) alertDownloadLang: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: // Don't Download !
            break;
        case 1:  { // Download
            [self startLoadingVocabulary];
            break;
        }            
        default: // Don't ask again
            break;
    }
}

- (void) startLoadingVocabulary {
    [self pushUserLangResumView];
}


- (int) getAppId {
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"Application Id"];
    return [appId intValue];
}
                     
- (void) responseToBuyAction {
	
	//double wasLearnedResult = [Vocabulary wasLearned];
	//if (wasLearnedResult >= cPercentageLearnd)
		
	//NSLog(@"Response To Buy Action");
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
}

- (void) askToRate {
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*)kCFBundleExecutableKey];
    NSString *message = [NSString stringWithFormat: @"If you enjou using %@, would you mind taking a moment to rate it? It won't take mora than a minute. Thanks for your support !", appName];
    
    UIAlertView *alert = [[UIAlertView alloc] 
        initWithTitle: cAskToReviewTitle 
        message: message
        delegate:self 
        cancelButtonTitle: @"Ramind me later" 
        otherButtonTitles: @"Yes, Rate It!", @"Don't ask again", nil];
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
