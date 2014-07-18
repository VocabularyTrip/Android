//
//  MapView.m
//  VocabularyTrip
//
//  Created by Ariel on 1/13/14.
//
//

#import "MapView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation MapView

@synthesize mapScrollView;
@synthesize helpButton;
@synthesize playCurrentLevelButton;
@synthesize flagFirstShowInSession;
//@synthesize configButton;
@synthesize backgroundSound;
@synthesize startWithHelpDownload;
@synthesize hand;

- (BOOL)shouldAutorotate{
    //if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||[[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
//        return YES;
//    else
        return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (UIInterfaceOrientationLandscapeLeft) return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    if (UIInterfaceOrientationLandscapeRight) return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) viewDidLoad {
    [self initializeGame];
    [self initMap];
    [self initConfigView];
    [self initAlbumMenu];
    
    for (int i=0; i < mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
        [aView setTag: 999]; // Tag 999 means dont remove in reloadAllLevels method. Since this method remove all subviews.
    }

    [self initAvatarAnimation];
}

- (void) initializeGame {
    [[PurchaseManager getSingleton] initializeObserver];
    [LandscapeManager loadDataFromXML];
    [Vocabulary loadDataFromXML];
    [Sentence loadDataFromXML];
    [GameSequenceManager loadDataFromXML];
    [self initAudioSession];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    // First execution jump to wizard to select user and lang
    User *user = [UserContext getSingleton].userSelected;
    if (!user) {
        [self.configView changeUserShowInfo: nil];
        return;
    }
    [playCurrentLevelButton.imageView setImage: user.image];
    
    // First move map to the end. viewDidAppear implement showAllMapInFirstSession
    if (flagFirstShowInSession) {
        [self.backgroundSound play]; // If soundEnabled is false the volumne is 0. This play prepare buffer and resourses to prevent delay in first word

        [mapScrollView setContentOffset: CGPointMake(
           [ImageManager getMapViewSize].width - [ImageManager windowWidth],
           [ImageManager getMapViewSize].height - [ImageManager windowHeightXIB]) animated: NO];
        
        Level *level = [UserContext getLevel];
        playCurrentLevelButton.center = [level placeinMap];
        //playCurrentLevelButton.center = (CGPoint) {playCurrentLevelButton.center.x, playCurrentLevelButton.center.y };
        
        currentLevelNumber = level.levelNumber;
    }
    [self initializeTimeoutToPlayBackgroundSound];
    
    [mapScrollView reloadAllLevels];
    [mapScrollView bringSubviewToFront: playCurrentLevelButton];
}

- (AVAudioPlayer*) backgroundSound {
	if (backgroundSound == nil) {
		backgroundSound = [Sentence getAudioPlayer: @"keepTrying"];
		backgroundSound.numberOfLoops = -1;
	}
    backgroundSound.volume = UserContext.soundEnabled == YES ? 1 : 0;
	return backgroundSound;
}

-(void) stopBackgroundSound {
	if (backgroundSound) {
		[backgroundSound stop];
		backgroundSound = nil;
	}
    
    [timerToPlayBackgroundSound invalidate];
    timerToPlayBackgroundSound = nil;
}

- (void) initializeTimeoutToPlayBackgroundSound {
	if (timerToPlayBackgroundSound == nil) {
        flagTimeoutStartMusic = NO;
		timerToPlayBackgroundSound = [CADisplayLink displayLinkWithTarget:self selector:@selector(startPlayBackgroundSound)];
		timerToPlayBackgroundSound.frameInterval = 1200;
		[timerToPlayBackgroundSound addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) startPlayBackgroundSound {
    if (!flagTimeoutStartMusic)
        flagTimeoutStartMusic = YES;
    else
        [self.backgroundSound play];
}

- (void) viewDidAppear:(BOOL)animated {


    [self showAllMapInFirstSession];
    [self moveUser];
    
    if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimationPurchase];
    if (!singletonVocabulary.isDownloading && ![Vocabulary isDownloadCompleted]) [configView startLoading];
    if (startWithHelpDownload) [configView show];
    startWithHelpDownload = 0;
    startWithHelpPurchase = 0;
}

- (void) moveOffsetToSeeUser: (Level*) aLevel {
    int offset = [ImageManager windowWidthXIB] / 2;
    int newX = [aLevel placeinMap].x > offset ? [aLevel placeinMap].x - offset : 0;
    
    offset = [ImageManager windowHeightXIB] / 2;
    int newY = [aLevel placeinMap].y > offset ? [aLevel placeinMap].y - offset : 0;
    CGPoint newPlace = CGPointMake(newX, newY);
    mapScrollView.contentOffset = newPlace;
}

- (void) moveUser {
    Level *level = [UserContext getLevel];
    if (level.levelNumber != currentLevelNumber) {
        // Move the train from the previous level to the next level
        [self moveOffsetToSeeUser: level];
        
        if (abs(level.levelNumber - currentLevelNumber) == 0) {
            return;
        } else { // if (abs(level.levelNumber - currentLevelNumber) == 1) {

            //level = [UserContext getLevelAt: currentLevelNumber];
            [UIView beginAnimations: @"Move User" context: nil];
            [UIView setAnimationDuration: 1];
            [UIView setAnimationDelegate: self];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            playCurrentLevelButton.center = [level placeinMap];
            [UIView commitAnimations];
            currentLevelNumber = level.levelNumber;
        } /*else {

            int delta = abs(level.levelNumber - currentLevelNumber) > 10 ? 5 : 1;
            
            currentLevelNumber = level.levelNumber < currentLevelNumber ? currentLevelNumber-delta : currentLevelNumber+delta;
            Level * currentLevel = [UserContext getLevelAt: currentLevelNumber];
            
            [UIView beginAnimations: @"Move User" context: nil];
            [UIView setAnimationDuration: 0.5];
            [UIView setAnimationDelegate: self];
            [UIImageView setAnimationDidStopSelector: @selector(moveUserEnded)];
            [UIView setAnimationCurve: UIViewAnimationCurveLinear];
            playCurrentLevelButton.center = [currentLevel placeinMap];
            [UIView commitAnimations];
        }*/
    }
}

/*- (void) moveUserEnded {
    [self moveUser];
}*/

- (void) showAllMapInFirstSession {
    Level *level = [UserContext getLevel];
    
    flagFirstShowInSession = NO;
    helpButton.alpha = 0;
    
    [UIView beginAnimations:@"ShowMapAndPositionInCurrentLevel" context: nil];
    [UIView setAnimationDelegate: self];
    [UIImageView setAnimationDidStopSelector: @selector(showAllMapFinished)];
    [UIView setAnimationDuration: 5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    
    [self moveOffsetToSeeUser: level];
    
    [UIView commitAnimations];
}

- (void) showAllMapFinished {
    helpButton.alpha = 1;
    if ([UserContext getHelpMapViewStep1]) [self helpAnimation1];
}

- (IBAction) playCurrentLevel:(id)sender {
    GameSequence *s = [GameSequenceManager getCurrentGameSequence];
    if ([s gameIsChallenge]) [self playChallengeTrain];
    if ([s gameIsTraining]) [self playTrainingTrain];
}

- (void) playChallengeTrain {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.testTrain;
	[vcDelegate pushTestTrain];
}

- (void) playTrainingTrain {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.trainingTrain;
	[vcDelegate pushTrainingTrain];
}

- (void) initMap {
    // Configurar el ancho del mapa
    [mapScrollView setContentSize: [ImageManager getMapViewSize]];
}

- (ConfigView*) configView {
    if (!configView) {
      	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            configView = [[ConfigView alloc] initWithNibName: @"ConfigView~ipad" bundle:[NSBundle mainBundle]];
        } else {
            configView = [[ConfigView alloc] initWithNibName: @"ConfigView" bundle:[NSBundle mainBundle]];
        }
        //configView.view.tag = 999;
    }
    return configView;
}

- (AlbumMenu*) albumMenu {
    if (!albumMenu) {
      	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            albumMenu = [[AlbumMenu alloc] initWithNibName: @"AlbumMenu~ipad" bundle:[NSBundle mainBundle]];
        } else {
            albumMenu = [[AlbumMenu alloc] initWithNibName: @"AlbumMenu" bundle:[NSBundle mainBundle]];
        }
    }
    return albumMenu;
}

- (void) initConfigView {
    [self.view addSubview: [self configView].view];
    [self.view bringSubviewToFront: [self configView].view];
    configView.parentView = self;
    [configView close];
}

- (void) initAlbumMenu {
    [self.view addSubview: [self albumMenu].view];
    [self.view bringSubviewToFront: [self albumMenu].view];
    albumMenu.parentView = self;
    [albumMenu close];
}

- (void)initAvatarAnimation {
    avatarAnimationSeq = 0;
    [self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(randomAvatarAnimation)];
		theTimer.frameInterval = 200;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) randomAvatarAnimation {
    switch (avatarAnimationSeq) {
        case 0:
            [AnimatorHelper avatarGreet: playCurrentLevelButton.imageView];
            break;
        case 1:
            [AnimatorHelper avatarBlink: playCurrentLevelButton.imageView];
            break;
        default:
            [AnimatorHelper avatarBlink: playCurrentLevelButton.imageView];
            break;
    }
    avatarAnimationSeq++;
    if (avatarAnimationSeq > 3) avatarAnimationSeq = 0;
}

- (IBAction) helpAnimation1 {

    // Show Hand and move to the play button
    hand.alpha = 1;
    [self.view bringSubviewToFront: hand];
    
    [UIImageView beginAnimations: @"HandToPlayButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center =  (CGPoint)  {
        playCurrentLevelButton.center.x - mapScrollView.contentOffset.x,
        playCurrentLevelButton.center.y - mapScrollView.contentOffset.y
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    [AnimatorHelper clickingView: hand delegate: self context: [NSNumber numberWithInt: 1]];
}

- (void) finishClicking:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {

    NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
    NSNumber* step = (NSNumber*) [parameters objectForKey: @"context"];

    if ([step intValue] == 1) {
        [self helpAnimation3];
        return;
    }
    if ([step intValue] == 2) {
        [self helpAnimation5];
        return;
    }
    if ([step intValue] == 3) {
        [self helpAnimation7];
        return;
    }
    
}

- (void) helpAnimation3 {
    // Open Album Menu and moe hand to first album
    [albumMenu show];
    [UIImageView beginAnimations: @"HandToAlbumButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + albumMenu.album1Button.center.x,
        albumMenu.view.frame.origin.y + albumMenu.album1Button.center.y
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation4 {
    [AnimatorHelper clickingView: hand delegate: self context: [NSNumber numberWithInt: 2]];
}

- (void) helpAnimation5 {
    
    [albumMenu close];
    // Move to any level
    [UIImageView beginAnimations: @"HandToLevel" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center =  (CGPoint)  {
        [[UserContext getLevelAt: 3] placeinMap].x - mapScrollView.contentOffset.x + [ImageManager getMapViewLevelSize] / 2,
        [[UserContext getLevelAt: 3] placeinMap].y - mapScrollView.contentOffset.y + [ImageManager getMapViewLevelSize] / 2
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation6 {
    [AnimatorHelper clickingView: hand delegate: self context: [NSNumber numberWithInt: 3]];
}

- (void) helpAnimation7 {
    hand.alpha = 0;
    [UserContext setHelpMapViewStep1: NO];
}

- (void) helpAnimationPurchase {
}


- (void) initAudioSession {
	NSError* audio_session_error = nil;
	BOOL is_success = YES;
	
	// Set the category
	is_success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:&audio_session_error];
	
	if(!is_success || audio_session_error)
	{
		NSLog(@"Error setting Audio Session category: %@", [audio_session_error localizedDescription]);
	}
	
	// Make this class the delegate so we can receive the interruption messages
	[[AVAudioSession sharedInstance] setDelegate:self];
	audio_session_error = nil;
	// Make the Audio Session active
	is_success = [[AVAudioSession sharedInstance] setActive:YES error:&audio_session_error];
	if(!is_success || audio_session_error) {
		NSLog(@"Error setting Audio Session active: %@", [audio_session_error localizedDescription]);
	}
}

@end
