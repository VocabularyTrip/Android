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
        // If soundEnabled is false the volumne is 0. This play prepare buffer and resourses to prevent delay in first word
        [self.backgroundSound play];
        [mapScrollView setContentOffset: CGPointMake(
            [ImageManager getMapViewSize].width - [ImageManager windowWidthXIB],
            [ImageManager getMapViewSize].height - [ImageManager windowHeightXIB]) animated: NO];
        Level *level = [UserContext getLevel];
        playCurrentLevelButton.center = [level placeinMap];
        currentLevelNumber = level.levelNumber;
    }
    [self initializeTimeoutToPlayBackgroundSound];
    [mapScrollView reloadAllLevels];
    [mapScrollView bringSubviewToFront: playCurrentLevelButton];
    [albumMenu close];
    [configView close];
}

- (void) viewDidAppear:(BOOL)animated {
    [self showAllMapInFirstSession];
    [self moveUser];
    
    if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimationPurchase];
    if (!singletonVocabulary.isDownloading && ![Vocabulary isDownloadCompleted]) [configView startLoading];
    if (startWithHelpDownload) [configView show];
    startWithHelpDownload = 0;
    startWithHelpPurchase = 0;
    if (!flagFirstShowInSession)
        [self startHelp];
}

- (void) startHelp {
    hand.alpha = 0;
    NSLog(@"%i, %i, %i", [UserContext getHelpMapViewStep1], [UserContext getHelpMapViewStep2], [UserContext getHelpMapViewStep3]);
    if ([UserContext getHelpMapViewStep1]) [self helpAnimation1];
    else if ([UserContext getHelpMapViewStep2]) [self helpAnimation2];
    else if ([UserContext getHelpMapViewStep3]) [self helpAnimation3];
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
    if (flagFirstShowInSession) {
        Level *level = [UserContext getLevel];
        [UIView beginAnimations:@"ShowMapAndPositionInCurrentLevel" context: nil];
        [UIView setAnimationDelegate: self];
        [UIImageView setAnimationDidStopSelector: @selector(showAllMapFinished)];
        [UIView setAnimationDuration: 5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        [self moveOffsetToSeeUser: level];
        [UIView commitAnimations];
    }
}

- (void) showAllMapFinished {
    [self startHelp];
    helpButton.alpha = 1;
    flagFirstShowInSession = NO;
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

- (IBAction) helpClicked {
	[self helpAnimation3];
}

- (IBAction) helpAnimation1 {
    
    // Show Hand and move to the play button
    hand.alpha = 1;
    [self.view bringSubviewToFront: hand];
    
    [UIImageView beginAnimations: @"HandToPlayButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation1_B)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center =  (CGPoint)  {
        playCurrentLevelButton.center.x + hand.frame.size.width/2 - mapScrollView.contentOffset.x, //- playCurrentLevelButton.frame.size.width/2,
        playCurrentLevelButton.center.y + hand.frame.size.height/2 - mapScrollView.contentOffset.y - playCurrentLevelButton.frame.size.height/2
    };
    [UIImageView commitAnimations];
    angle = 0;  // reset it before start looping in helpAnimation2
    
}

// Help 1: Play Game
- (void) helpAnimation1_B {
    [Sentence playSpeaker: @"MapView-Help1"];
    [self helpAnimation1_C];
}

- (void) helpAnimation1_C {
    // hoover over avatar
    CGPoint center = hand.center;
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle > M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation1_D)];
    }
    else {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation1_C)];
    }
    [UIImageView setAnimationDuration: .025];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    center.x = playCurrentLevelButton.center.x + hand.frame.size.width/2 - mapScrollView.contentOffset.x - playCurrentLevelButton.frame.size.width/2*sin(angle);
    center.y = playCurrentLevelButton.center.y + hand.frame.size.height/2 - mapScrollView.contentOffset.y - playCurrentLevelButton.frame.size.height/2*cos(angle);
    hand.center = center;
    
    angle += M_PI/100;
    [UIImageView commitAnimations];
}

- (void) helpAnimation1_D {
    // bring hand to alpha = 0
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
    //[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_B)];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: .5];
    
	hand.alpha = 0;
	[UIImageView commitAnimations];
    [UserContext setHelpMapViewStep1: NO];
}

/*- (void) finishClicking:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    
    NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
    NSNumber* step = (NSNumber*) [parameters objectForKey: @"context"];
    
    if ([step intValue] == 1) {
        [self helpAnimation3];
        return;
    }
    if ([step intValue] == 2) {
        [self helpAnimation2];
        return;
    }
    if ([step intValue] == 3) {
        [self helpAnimation1];
        return;
    }
    
}
*/

// Help 1: Play with Sticker Album
- (void) helpAnimation2 {
    // Show Hand and starting close to stickers tab

    angle = 0;
    [albumMenu close];
    [self.view bringSubviewToFront: hand];
    
    /*
    [UIImageView beginAnimations: @"show hand" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_B)];
    [UIImageView setAnimationDuration: .2];*/
    hand.center =  (CGPoint)  {
        albumMenu.view.frame.origin.x - albumMenu.view.frame.size.width,
        albumMenu.view.frame.origin.y
    };
    hand.alpha = 1;
    //[UIImageView commitAnimations];
    
    [self helpAnimation2_B];
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
        albumMenu.view.frame.origin.x + albumMenu.backButton.center.x + hand.frame.size.width/2,
        albumMenu.view.frame.origin.y + albumMenu.backButton.center.y + hand.frame.size.height/2
    };
    hand.alpha=1;
    angle=0;
    [UIImageView commitAnimations];
}

- (void) helpAnimation2_C {
    // Open Album Menu and move hand to first album
    [Sentence playSpeaker: @"MapView-Help2_A"];
    [albumMenu show];
    [UIImageView beginAnimations: @"HandToAlbumButton" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_D)];
    [UIImageView setAnimationDuration: 3];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    hand.center = (CGPoint) {
        albumMenu.view.frame.origin.x + albumMenu.album1Button.center.x + hand.frame.size.width/2,
        albumMenu.view.frame.origin.y + albumMenu.album1Button.center.y + hand.frame.size.height/2 - albumMenu.album1Button.frame.size.height/2
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation2_D {
    [Sentence playSpeaker: @"MapView-Help2_B"];
    [self helpAnimation2_E];
}

- (void) helpAnimation2_E {
    // hoover over album

    CGPoint center = hand.center;
    [UIImageView beginAnimations: @"HooverOverAlbum" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_F)];
    }
    else {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2_E)];
    }
    [UIImageView setAnimationDuration: .025];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    center.x = albumMenu.view.frame.origin.x + albumMenu.album1Button.center.x + hand.frame.size.width/2 - albumMenu.album1Button.frame.size.width*sin(angle)/2;
    center.y = albumMenu.view.frame.origin.y + albumMenu.album1Button.center.y + hand.frame.size.height/2 - albumMenu.album1Button.frame.size.height*cos(angle)/2;
    hand.center = center;
    
    angle += M_PI/100;
    [UIImageView commitAnimations];
}

- (void) helpAnimation2_F {
    // bring hand to alpha = 0
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDuration: .5];
    
    hand.alpha = 0;
    [UIImageView commitAnimations];
    [UserContext setHelpMapViewStep2: NO];
}

- (void) helpAnimation3 {
    hand.center =  (CGPoint)  { [[UserContext getLevelAt: 1] placeinMap].x - mapScrollView.contentOffset.x + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.width/2,
        [[UserContext getLevelAt: 1] placeinMap].y - mapScrollView.contentOffset.y + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.height/2
    };
    hand.alpha = 1;
    [self helpAnimation3_B];
}

- (void) helpAnimation3_B {
    // Move hand to a station
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
    [AnimatorHelper clickingView: hand delegate: self];
    [Sentence playSpeaker: @"MapView-Help3_A" delegate: self selector: @selector(helpAnimation3_D)];
    [mapScrollView showLevelInMap: [UserContext getLevelAt: 3]];
}

- (void) helpAnimation3_D {
    // Move hand to a station 2
    [UIImageView beginAnimations: @"HandToLevel" context: (__bridge void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation3_E)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.center =  (CGPoint)  {
        [[UserContext getLevelAt: 2] placeinMap].x - mapScrollView.contentOffset.x + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.width/2,
        [[UserContext getLevelAt: 2] placeinMap].y - mapScrollView.contentOffset.y + [ImageManager getMapViewLevelSize] / 2 + hand.frame.size.height/2
    };
    [UIImageView commitAnimations];
}

- (void) helpAnimation3_E {
    [AnimatorHelper clickingView: hand delegate: self ];
    [Sentence playSpeaker: @"MapView-Help3_B" delegate: self selector: @selector(helpAnimation3_F)];
    [mapScrollView showLevelInMap: [UserContext getLevelAt: 2]];
    [UserContext setHelpMapViewStep3: NO];
}

- (void) helpAnimation3_F {
    [Sentence playSpeaker: @"MapView-Help3_C" delegate: self selector: @selector(helpAnimation3_G)];
}

- (void) helpAnimation3_G {
    [UserContext setHelpMapViewStep3: NO];
    hand.alpha = 0;
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
