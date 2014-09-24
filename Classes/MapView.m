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
@synthesize preventOpenLevelView;
@synthesize flagTimeoutStartMusic;
@synthesize viewComeFrom;

- (BOOL)shouldAutorotate{
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
    [self initMap];
    [self initConfigView];
    [self initAlbumMenu];
    
    for (int i=0; i < mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
        [aView setTag: 999]; // Tag 999 means dont remove in reloadAllLevels method. Since this method remove all subviews.
    }
    
    [self initAvatarAnimation];
    viewComeFrom = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    // First execution jump to wizard to select user and lang
    User *user = [UserContext getSingleton].userSelected;
    if (!user) {
        [self.configView changeUserShowInfo: nil];
        return;
    }

    [ImageManager fitImage: user.image inButton: playCurrentLevelButton];
    
    // First move map to the end. viewDidAppear implement showAllMapInFirstSession
    if (flagFirstShowInSession) {
        // If soundEnabled is false the volumne is 0. This play prepare buffer and resourses to prevent delay in first word
        [self.backgroundSound play];
        int width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [ImageManager getMapViewSize].width/2 : [ImageManager getMapViewSize].width;
        [mapScrollView setContentOffset: CGPointMake(
            width - [ImageManager windowWidthXIB],
            [ImageManager getMapViewSize].height - [ImageManager windowHeightXIB]) animated: NO];
        Level *level = [UserContext getLevel];
        playCurrentLevelButton.center = [level placeinMap];
        currentLevelNumber = level.levelNumber;
    }
    [mapScrollView reloadAllLevels];
    [mapScrollView bringSubviewToFront: playCurrentLevelButton];
    [albumMenu close];
    [configView close];
}

- (void) viewDidAppear:(BOOL)animated {
    if (flagFirstShowInSession) {
        [self showAllMapInFirstSession];
    } else {
        [self initializeTimeoutToPlayBackgroundSound];
        Level *level = [UserContext getLevel];
        if (level.levelNumber != currentLevelNumber) {
            // Move the train from the previous level to the next level
            if (viewComeFrom == cViewComeFromTrain) {
                [self preventPlayingHelp: cPreventPlayingHelpTouchNothing];
                [Sentence playSpeaker: @"Test-EvaluateGetIntoNextLevel-NextLevel"
                          delegate: self selector: @selector(initializeHelpTimer)];
            }
            [self moveUser];
        } else {
            [self initializeHelpTimer];
        }
    }
    viewComeFrom = 0;
    
    //if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimationPurchase];
    if (!singletonVocabulary.isDownloading && ![Vocabulary isDownloadCompleted]) [configView startLoading];
    if (startWithHelpDownload) [configView show];
    startWithHelpDownload = 0;
    //startWithHelpPurchase = 0;

}

/*- (void) endGetIntoNextLevel {
    [self initializeHelpTimer];
    [self allowPlayingHelpEnded];
}*/

- (void) cancelAllAnimations {

	[self stopBackgroundSound];
    [Sentence stopCurrentAudio];

    [helpTimer invalidate];
	helpTimer = nil;
    [timerToPlayBackgroundSound invalidate];
    timerToPlayBackgroundSound = nil;
    
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView commitAnimations];
	[self.view.layer removeAllAnimations];
    
    //hand.alpha = 0;
}

- (AVAudioPlayer*) backgroundSound {
	if (backgroundSound == nil) {
		backgroundSound = [Sentence getAudioPlayer: @"keepTrying"];
		backgroundSound.numberOfLoops = -1;
	}
    backgroundSound.volume = UserContext.soundEnabled == YES ? cMusicVolume : 0;
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
		timerToPlayBackgroundSound.frameInterval = 800;
		[timerToPlayBackgroundSound addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) startPlayBackgroundSound {
    if (!flagTimeoutStartMusic)
        flagTimeoutStartMusic = YES;
    else {
        [self.backgroundSound play];
        [timerToPlayBackgroundSound invalidate];
        timerToPlayBackgroundSound = nil;
    }
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
    [self moveOffsetToSeeUser: level];
        
    [UIView beginAnimations: @"Move User" context: nil];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
    playCurrentLevelButton.center = [level placeinMap];
    [UIView commitAnimations];
    currentLevelNumber = level.levelNumber;
}

- (void) showAllMapInFirstSession {

    Level *level = [UserContext getLevel];
    [UIView beginAnimations:@"ShowMapAndPositionInCurrentLevel" context: nil];
    [UIView setAnimationDelegate: self];
    [UIImageView setAnimationDidStopSelector: @selector(showAllMapFinished)];
    [UIView setAnimationDuration: 5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [self moveOffsetToSeeUser: level];
    [UIView commitAnimations];

}

- (void) showAllMapFinished {
    [self initializeHelpTimer];
    [self initializeTimeoutToPlayBackgroundSound];
    helpButton.alpha = 1;
    flagFirstShowInSession = NO;
}

- (IBAction) playCurrentLevel:(id)sender {

    [self cancelAllAnimations];
    
    GameSequence *s = [GameSequenceManager getCurrentGameSequence];
    if ([s gameIsChallenge]) [self playChallengeTrain];
    if ([s gameIsTraining]) [self playTrainingTrain];
}

- (void) playChallengeTrain {
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.testTrain;
	[vcDelegate pushTestTrain];
}

- (void) playTrainingTrain {
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.trainingTrain;
	[vcDelegate pushTrainingTrain];
}

- (void) initMap {
    [self initAudioSession];
    flagFirstShowInSession = YES;
    [mapScrollView setContentSize: [ImageManager getMapViewSize]];
}

- (ConfigView*) configView {
    if (!configView) {
      	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            configView = [[ConfigView alloc] initWithNibName: @"ConfigView~ipad" bundle:[NSBundle mainBundle]];
        } else {
            configView = [[ConfigView alloc] initWithNibName: @"ConfigView" bundle:[NSBundle mainBundle]];
        }
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
        //case 2:
            //[AnimatorHelper avatarDance: playCurrentLevelButton.imageView];
        //    break;
        case 3:
            //[AnimatorHelper avatarFrustrated: playCurrentLevelButton.imageView];
            break;
        case 4:
            //[AnimatorHelper avatarOk: playCurrentLevelButton.imageView];
            break;
        default:
            [AnimatorHelper avatarBlink: playCurrentLevelButton.imageView];
    }
    
    avatarAnimationSeq++;
    if (avatarAnimationSeq > 2) avatarAnimationSeq = 0;
}

- (IBAction) helpClicked {
	[self helpAnimation4];
}

- (void) startHelp {
    hand.alpha = 0;
    //[timerToPlayBackgroundSound invalidate];
    //timerToPlayBackgroundSound = nil;
    //[configView close];
    
    if ([UserContext getHelpMapViewStep1]) [self helpAnimation1];
    else if ([UserContext getHelpMapViewStep2]) [self helpAnimation2];
    else if ([UserContext getHelpMapViewStep3]) [self helpAnimation3];
    else {
        [helpTimer invalidate];
        helpTimer = nil;
        [self allowPlayingHelpEnded];
    }
}

- (void) initializeHelpTimer {
	if (helpTimer == nil) {
		helpTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshHelp)];
		helpTimer.frameInterval = 700;
		[helpTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) refreshHelp {
    [self startHelp];
}

- (void) preventPlayingHelp: (int) help {

    [backgroundSound setVolume: cMusicVolumeOff];
    [Sentence stopCurrentAudio];
    [timerToPlayBackgroundSound invalidate];
    timerToPlayBackgroundSound = nil;
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
    [self.view.layer removeAllAnimations];
    
    mapScrollView.scrollEnabled = NO;
    configView.openCloseButton.enabled = NO;
    helpButton.enabled = NO;
    
    switch (help) {
        case cPreventPlayingHelpTouchAvatar:
            albumMenu.openCloseButton.enabled = NO;
            preventOpenLevelView = YES;
            playCurrentLevelButton.userInteractionEnabled = YES;
            break;
        case cPreventPlayingHelpTouchAlbum:
            playCurrentLevelButton.userInteractionEnabled = NO;
            preventOpenLevelView = YES;
            albumMenu.openCloseButton.enabled = YES;
            break;
        case cPreventPlayingHelpTouchLevel:
            albumMenu.openCloseButton.enabled = NO;
            playCurrentLevelButton.userInteractionEnabled = NO;
            preventOpenLevelView = NO;
            break;
        case cPreventPlayingHelpTouchNothing:
            albumMenu.openCloseButton.enabled = NO;
            playCurrentLevelButton.userInteractionEnabled = NO;
            preventOpenLevelView = YES;
            break;
    }
}

- (void) allowPlayingHelpEnded {
    mapScrollView.scrollEnabled = YES;
    albumMenu.openCloseButton.enabled = YES;
    configView.openCloseButton.enabled = YES;
    playCurrentLevelButton.userInteractionEnabled = YES;
    preventOpenLevelView = NO;
    helpButton.enabled = YES;

    backgroundSound.volume = UserContext.soundEnabled == YES ? cMusicVolume : 0;
    [self initializeTimeoutToPlayBackgroundSound];
}

- (IBAction) helpAnimation1 {
    
    // Show Hand and move to the play button
    [self preventPlayingHelp: cPreventPlayingHelpTouchAvatar];
    
    hand.center =  (CGPoint)  {
        [ImageManager windowWidthXIB] / 2,
        [ImageManager windowHeightXIB] / 2
    };
    hand.alpha = 1;
    [self.view bringSubviewToFront: hand];
    
    [UIImageView beginAnimations: @"HandToPlayButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation1_A)];
    [UIImageView setAnimationDuration: .75];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center =  (CGPoint)  {
        playCurrentLevelButton.center.x + hand.frame.size.width/2 - mapScrollView.contentOffset.x,
        playCurrentLevelButton.center.y + hand.frame.size.height/2 - mapScrollView.contentOffset.y
    };
    
    [UIImageView commitAnimations];
}



// Help 1: Play Game
- (void) helpAnimation1_A {
    [self moveOffsetToSeeUser: [UserContext getLevel]];
    //mapScrollView.enabledInteraction = NO;
    [Sentence playSpeaker: @"MapView-Help1A"];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation1_B)];
}

- (void) helpAnimation1_B {
    // bring hand to alpha = 0
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: 1.5];
	hand.alpha = 0;
	[UIImageView commitAnimations];

}

// Help 1: Play with Sticker Album
- (void) helpAnimation2 {
    // Show Hand and starting close to stickers tab
    [self preventPlayingHelp: cPreventPlayingHelpTouchAlbum];
    // [albumMenu close];
    [self.view bringSubviewToFront: hand];
    
    hand.center =  (CGPoint)  {
        [ImageManager windowWidthXIB] / 2,
        [ImageManager windowHeightXIB] / 2
    };
    hand.alpha = 1;

    if ([albumMenu frameIsClosed])
        [self helpAnimation2_B];
    else
        [self helpAnimation2_D];
};

- (void) helpAnimation2_B {
    // Move hand to toolbar button
    [UIImageView beginAnimations: @"HandToToolbar" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_C)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + hand.frame.size.width/2,
        albumMenu.view.frame.origin.y + hand.frame.size.width
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation2_C {
    // Open Album Menu and move hand to first album

    [albumMenu show];
    [Sentence playSpeaker: @"MapView-Help2A"];
    [self helpAnimation2_D];
}

- (void) helpAnimation2_D {
    [UIImageView beginAnimations: @"HandToAlbumButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_E)];
    [UIImageView setAnimationDuration: 3];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + hand.frame.size.width/2 + albumMenu.album3Button.center.x,
        albumMenu.view.frame.origin.y + hand.frame.size.width + albumMenu.album3Button.frame.size.height/2 + albumMenu.album3Button.frame.origin.y
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation2_E {
    [Sentence playSpeaker: @"MapView-Help2B"];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation2_F)];
}

- (void) helpAnimation2_F {
    hand.alpha = 0;
}

- (void) helpAnimation3 {
    [self moveOffsetToSeeUser: [UserContext getLevelAt: 3]];
    [self preventPlayingHelp: cPreventPlayingHelpTouchLevel];
    hand.center =  (CGPoint)  {
        [ImageManager windowWidthXIB] / 2,
        [ImageManager windowHeightXIB] / 2
    };
    hand.alpha = 1;
    [self helpAnimation3_B];
}

- (void) helpAnimation3_B {
    // Move hand to a station
    [Sentence playSpeaker: @"MapView-Help3A"];
    [UIImageView beginAnimations: @"HandToLevel" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation3_C)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];

    hand.center =  (CGPoint)  {
        [[UserContext getLevelAt: 3] placeinMap].x - mapScrollView.contentOffset.x + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.width/2,
        [[UserContext getLevelAt: 3] placeinMap].y - mapScrollView.contentOffset.y + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.height/2
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation3_C {
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation3_E)];
}

- (void) helpAnimation3_E {
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation3_F)];
}

- (void) helpAnimation3_F {
    hand.alpha = 0;
}

- (void) helpAnimation4 {
    [configView close];
    [self preventPlayingHelp: cPreventPlayingHelpTouchNothing];
    // this helps gets triggered when user presses the help button.
    // this part of the animation makes hand visible in the screen center.
    hand.center =  (CGPoint)  {
        [ImageManager windowWidthXIB] / 2,
        [ImageManager windowHeightXIB] / 2
    };
    hand.alpha = 1;

    [self.view bringSubviewToFront: hand];
    
    [UIImageView beginAnimations: @"HandToPlayButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4_A)];
    [UIImageView setAnimationDuration: .75];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    [self moveOffsetToSeeUser: [UserContext getLevel]];
    hand.center =  (CGPoint)  {
        playCurrentLevelButton.center.x + hand.frame.size.width/2 - mapScrollView.contentOffset.x,
        playCurrentLevelButton.center.y + hand.frame.size.height/2 - mapScrollView.contentOffset.y
    };
    
    [UIImageView commitAnimations];
}

    // Help 4, part 1: Play Game
- (void) helpAnimation4_A {
    
    //    [Sentence playSpeaker: @"MapView-Help1A"];
    [Sentence playSpeaker:@"MapView-Help1A" delegate: self selector:@selector(helpAnimation4_B)];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation4_D2)];
}

- (void) helpAnimation4_B {
    // Start part of help about the Level view
    // Move hand to a station
    [UIImageView beginAnimations: @"HandToLevel" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4_C)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];

    int helpLevel = [[[UserContext getSingleton] userSelected] getLevel] + 2;
    if (helpLevel > cLimitLevel) helpLevel = cLimitLevel - 2;
    [self moveOffsetToSeeUser: [UserContext getLevelAt: helpLevel]];
    
    hand.center =  (CGPoint)  {
        [[UserContext getLevelAt: helpLevel] placeinMap].x - mapScrollView.contentOffset.x + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.width/2,
        [[UserContext getLevelAt: helpLevel] placeinMap].y - mapScrollView.contentOffset.y + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.height/2
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation4_C {
    //    [Sentence playSpeaker: @"MapView-Help3A"];
    [Sentence playSpeaker:@"MapView-Help3A" delegate:self selector:@selector(helpAnimation4_E)];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation4_D)];
}

- (void) helpAnimation4_D {
        //[AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation4_E)];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation4_D2)];
}

- (void) helpAnimation4_D2 {
    
}
- (void) helpAnimation4_E {
        // Move hand to toolbar button
    [UIImageView beginAnimations: @"HandToToolbar" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4_F)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + hand.frame.size.width/2,
        albumMenu.view.frame.origin.y + hand.frame.size.width
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation4_F {
        // Open Album Menu and move hand to first album
    
    [albumMenu show];
    [Sentence playSpeaker: @"MapView-Help2A"];
    [self helpAnimation4_G];
}

- (void) helpAnimation4_G {
    [UIImageView beginAnimations: @"HandToAlbumButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4_H)];
    [UIImageView setAnimationDuration: 3];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + hand.frame.size.width/2 + albumMenu.album3Button.center.x,
        albumMenu.view.frame.origin.y + hand.frame.size.width + albumMenu.album3Button.frame.origin.y
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation4_H {
    [Sentence playSpeaker: @"MapView-Help2B"];
    [Sentence playSpeaker: @"MapView-Help2B" delegate: self selector: @selector(helpAnimation4_I)];
    [AnimatorHelper clickingView: hand delegate: self selector: @selector(helpAnimation4_D2)];
}

- (void) helpAnimation4_I {
    hand.alpha = 0;
    hand.center = (CGPoint)  {
        [ImageManager windowWidthXIB] / 2,
        [ImageManager windowHeightXIB] / 2
    };
    [albumMenu close];

    [self allowPlayingHelpEnded];

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
