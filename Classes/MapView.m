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
@synthesize configButton;
@synthesize backgroundSound;
@synthesize startWithHelpDownload;

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
    //[mapScrollView init];
    //[self drawAllLeveles];

    //self.view.layer.shouldRasterize = YES;
    //self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    
    for (int i=1; i<mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
        [aView setTag: 999]; // Tag 999 means dont remove in reloadAllLevels method. Since this method remove all subviews.
    }

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
    UserContext *aUserC = [UserContext getSingleton];
    if (!aUserC.userSelected) {
        [self.configView changeUserShowInfo: nil];
        return;
    }

    configView.view.frame = [configView frameClosed];
    
    // First move map to the end. viewDidAppear implement showAllMapInFirstSession
    if (flagFirstShowInSession) {
        [self.backgroundSound play]; // If soundEnabled is false the volumne is 0. This play prepare buffer and resourses to prevent delay in first word

        [mapScrollView setContentOffset: CGPointMake(
           [ImageManager getMapViewSize].width - [ImageManager windowWidth], 0) animated: NO];
        
        Level *level = [UserContext getLevel];
        playCurrentLevelButton.center = [level placeinMap];
        [self.view bringSubviewToFront: playCurrentLevelButton];
        currentLevelNumber = level.levelNumber;
    }
    [self initializeTimeoutToPlayBackgroundSound];
    
    [self reloadAllLevels];
    //[mapScrollView bringSubviewToFront: mapScrollView.levelView.view];
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
		timerToPlayBackgroundSound.frameInterval = 800;
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
    //UserContext *aUserC = [UserContext getSingleton];

    //if (flagFirstShowInSession && aUserC.userSelected)
    [self showAllMapInFirstSession];
    
    if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimation1];
    if (startWithHelpPurchase && ![Vocabulary isDownloadCompleted]) [self startLoading];
    if (startWithHelpDownload) [self helpDownload1];
    startWithHelpDownload = 0;
    startWithHelpPurchase = 0;

    [self moveUser];
}

- (void) moveUser {
    Level *level = [UserContext getLevel];
    if (level.levelNumber != currentLevelNumber) {
        // Move the train from the previous level to the next level
        
        int offset = [ImageManager windowWidth] / 2;
        int newX = [level placeinMap].x > offset ? [level placeinMap].x - offset : 0;
        CGPoint newPlace = CGPointMake(newX, 0);
        mapScrollView.contentOffset = newPlace;
        
        if (abs(level.levelNumber - currentLevelNumber) == 0) {
            return;
        } else if (abs(level.levelNumber - currentLevelNumber) == 1) {
            [UIView beginAnimations: @"Move User" context: nil];
            [UIView setAnimationDuration: 3];
            [UIView setAnimationDelegate: self];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            playCurrentLevelButton.center = [level placeinMap];
            [self.view bringSubviewToFront: playCurrentLevelButton];
            
            [UIView commitAnimations];
            currentLevelNumber = level.levelNumber;
        } else {
            currentLevelNumber = level.levelNumber < currentLevelNumber ? currentLevelNumber-1 : currentLevelNumber+1;
            [UIView beginAnimations: @"Move User" context: nil];
            [UIView setAnimationDuration: 0.5];
            [UIView setAnimationDelegate: self];
            [UIImageView setAnimationDidStopSelector: @selector(moveUserEnded)];//
            [UIView setAnimationCurve: UIViewAnimationCurveLinear];
            playCurrentLevelButton.center = [[UserContext getLevelAt: currentLevelNumber] placeinMap];
            [self.view bringSubviewToFront: playCurrentLevelButton];
            [UIView commitAnimations];
        }
        
    }
}

- (void) moveUserEnded {
    [self moveUser];
}

- (void) showAllMapInFirstSession {
    Level *level = [UserContext getLevel];
    
    flagFirstShowInSession = NO;
    
    configButton.alpha = 0;
    //langButton.alpha = 0;
    helpButton.alpha = 0;
    
    [UIView beginAnimations:@"ShowMapAndPositionInCurrentLevel" context: nil];
    [UIView setAnimationDelegate: self];
    [UIImageView setAnimationDidStopSelector: @selector(showAllMapFinished)];
    [UIView setAnimationDuration: 5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    
    int offset = [ImageManager windowWidth] / 2;
    int newX = [level placeinMap].x > offset ? [level placeinMap].x / 2 : 0;
    CGPoint newPlace = CGPointMake(newX, 0);
    mapScrollView.contentOffset = newPlace;
    
    [UIView commitAnimations];
}

- (void) showAllMapFinished {
    configButton.alpha = 1;
    //langButton.alpha = 1;
    helpButton.alpha = 1;
}

- (IBAction) playCurrentLevel:(id)sender {
    GameSequence *s = [GameSequenceManager getCurrentGameSequence];
    if ([s gameIsChallenge]) [self playChallengeTrain];
    if ([s gameIsTraining]) [self playTrainingTrain];
    //if ([s gameIsMemory]) [self playMemoryTrain];
    //if ([s gameIsSimon]) [self playSimonTrain];
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

/*- (void) playMemoryTrain {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.memoryTrain;
	[vcDelegate pushMemoryTrain];
}

- (void) playSimonTrain {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.simonTrain;
	[vcDelegate pushSimonTrain];
}*/

- (IBAction) albumShowInfo:(id)sender {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushAlbumMenu];
}

- (void) initMap {
    // Configurar el ancho del mapa
    [mapScrollView setContentSize: [ImageManager getMapViewSize]];
    //[mapScrollView initialize];
}

- (void) reloadAllLevels {
    [self removeAllLevels];
    [self drawAllLeveles];
}

- (void) removeAllLevels {
    int i = 0;
    while (mapScrollView.subviews.count > i) {
        UIView *aView = [mapScrollView.subviews objectAtIndex: i];
        if (aView.tag < 100) { // Three UIViews are fixed with tag 999. The rest of views belong to levels and icons. Will be added in drawAllLevels
            [aView removeFromSuperview];
        } else {
            i++;
        }
    }
}

- (void) drawAllLeveles {
    Level *level;
    UIImageView* image;
    for (int i=0; i< [Vocabulary countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        image = [self addImage: level.image
                  pos: [level placeinMap]
                  size: [ImageManager getMapViewLevelSize]];
        //image.tag = 1000 + level.levelNumber;
        [self addAccessibleIconToLevel: level];
        [self addProgressLevel: level];
    }
}

-(UIImageView*) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    CGRect frame = imageView.frame;
    frame.origin = pos;
    frame.size.width = size;
    frame.size.height = size;
    imageView.frame = frame;
    [ImageManager fitImage: image inImageView: imageView];
    
    [mapScrollView addSubview: imageView];
    [mapScrollView bringSubviewToFront: imageView];
    return imageView;
}

- (void) addAccessibleIconToLevel: (Level*) level {
    // To each level is added:
    //     * Nothing if the level is accessible
    //     * Lock icon if the user didn't reach this level
    //     * Buy icon if the user has to buy to unlock the level
    
    CGPoint newPlace = CGPointMake([level placeinMap].x + [ImageManager getMapViewLevelSize] * 0.7, [level placeinMap].y + [ImageManager getMapViewLevelSize] * 0.7);
 
    if (level.order > [UserContext getMaxLevel] && level.order != 1) {
        [self addImage: [UIImage imageNamed:@"buyButton.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
    } else if (level.order > ([UserContext getLevelNumber]+1) && level.order != 1) {
        [self addImage: [UIImage imageNamed:@"token-bronze.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
    }

}

- (void) addProgressLevel: (Level*) level {
    CGPoint newPlace = CGPointMake([level placeinMap].x, [level placeinMap].y + [ImageManager getMapViewLevelSize] * 0.7);
    
    if (level.order < [UserContext getLevelNumber] || level.order == 1) {
        [self addImage: [UIImage imageNamed:@"progress_fill.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.5];
        [self addImage: [UIImage imageNamed:@"progress_mask.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.5];
        
    }
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

- (IBAction) openConfigView {
    [self.view addSubview: [self configView].view];
    configView.parentView = self;
    [configView show];
}

- (void) helpAnimation1 {
}

- (void) helpDownload1 {
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
