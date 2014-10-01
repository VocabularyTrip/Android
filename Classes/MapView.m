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
@synthesize playCurrentLevelButton;
@synthesize flagFirstShowInSession;
@synthesize backgroundSound;
@synthesize flagTimeoutStartMusic;

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
    
    for (int i=0; i < mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
        [aView setTag: 999]; // Tag 999 means dont remove in reloadAllLevels method. Since this method remove all subviews.
    }
    
    [self initAvatarAnimation];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    // First execution jump to wizard to select user and lang
    User *user = [UserContext getSingleton].userSelected;
    if (!user) {
        //[self.configView changeUserShowInfo: nil];
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
}

- (void) viewDidAppear:(BOOL)animated {
    if (flagFirstShowInSession) {
        [self showAllMapInFirstSession];
    } else {
        [self initializeTimeoutToPlayBackgroundSound];
        Level *level = [UserContext getLevel];
        if (level.levelNumber != currentLevelNumber) {
            [self moveUser];
        }
    }
}

- (void) cancelAllAnimations {

	[self stopBackgroundSound];
    [singletonSentenceManager stopCurrentAudio];

    [timerToPlayBackgroundSound invalidate];
    timerToPlayBackgroundSound = nil;
    
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView commitAnimations];
	[self.view.layer removeAllAnimations];
    
}

// Backround sound
- (AVAudioPlayer*) backgroundSound {
	if (backgroundSound == nil) {
		backgroundSound = [SentenceManager getAudioPlayer: @"keepTrying"];
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

// Map and User
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
        
    [UIView beginAnimations: @"Move User" context: nil];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
    [self moveOffsetToSeeUser: level];
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
    [self initializeTimeoutToPlayBackgroundSound];
    flagFirstShowInSession = NO;
}

- (IBAction) playCurrentLevel:(id)sender {

    [UserContext nextLevel];
    [mapScrollView reloadAllLevels];
    [mapScrollView bringSubviewToFront: playCurrentLevelButton];
    [singletonSentenceManager playSpeaker: @"Test-EvaluateGetIntoNextLevel-NextLevel"];
    [self moveUser];
    
}

- (IBAction) selectUserAndLang:(id)sender {
    
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate pushChangeUserView];
}

- (IBAction) reset:(id)sender {
    [[UserContext getSingleton] resetGame];
    [mapScrollView reloadAllLevels];
    [mapScrollView bringSubviewToFront: playCurrentLevelButton];
    [self moveUser];
}


- (void) initMap {
    [self initAudioSession];
    flagFirstShowInSession = YES;
    [mapScrollView setContentSize: [ImageManager getMapViewSize]];
}

// Avatar Animation
- (void)initAvatarAnimation {
    avatarAnimationSeq = 0;
    [self initializeAvatarTimer];
}

- (void) initializeAvatarTimer {
	if (avatarTimer == nil) {
		avatarTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(randomAvatarAnimation)];
		avatarTimer.frameInterval = 200;
		[avatarTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
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
        case 2:
            [AnimatorHelper avatarOk: playCurrentLevelButton.imageView];
            break;
        default:
            [AnimatorHelper avatarBlink: playCurrentLevelButton.imageView];
    }
    
    avatarAnimationSeq++;
    if (avatarAnimationSeq > 2) avatarAnimationSeq = 0;
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
