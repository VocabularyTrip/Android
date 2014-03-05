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

@synthesize  mapScrollView;
@synthesize helpButton;
@synthesize playCurrentLevelButton;
@synthesize flagFirstShowInSession;
@synthesize configButton;
@synthesize langButton;

- (void) viewDidLoad {
    [self initializeGame];
    [self initMap];
    [self drawAllLeveles];

    //self.view.layer.shouldRasterize = YES;
    //self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
}

- (void) initializeGame {
    [[PurchaseManager getSingleton] initializeObserver];
    [LandscapeManager loadDataFromXML];
    [Vocabulary loadDataFromXML];
    [Sentence loadDataFromXML];
    [GameSequenceManager loadDataFromXML];
    [self initAudioSession];
}

- (void) viewDidAppear:(BOOL)animated {
    UserContext *aUserC = [UserContext getSingleton];

    if (flagFirstShowInSession && aUserC.userSelected)
       [self showAllMapInFirstSession];

    // playCurrentLevelButton in the correct level
    Level *level = [UserContext getLevel];
    playCurrentLevelButton.center = [level placeinMap];
    [self.view bringSubviewToFront: playCurrentLevelButton];
    
    if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimation1];
    if (startWithHelpPurchase && ![Vocabulary isDownloadCompleted]) [self startLoading];
    if (startWithHelpDownload) [self helpDownload1];
    startWithHelpDownload = 0;
    startWithHelpPurchase = 0;
    
}

- (void) showAllMapInFirstSession {
    Level *level = [UserContext getLevel];
    
    flagFirstShowInSession = NO;
    
    [mapScrollView setContentOffset: CGPointMake(
        [ImageManager getMapViewSize].width - [ImageManager windowWidth], 0) animated: NO];
    
    [UIView beginAnimations:@"ShowMapAndPositionInCurrentLevel" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    
    int offset = [ImageManager windowWidth] / 2;
    int newX = [level placeinMap].x > offset ? [level placeinMap].x - offset : 0;
    CGPoint newPlace = CGPointMake(newX, 0);
    mapScrollView.contentOffset = newPlace;
    
    [UIView commitAnimations];
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear: animated];
    
    UserContext *aUserC = [UserContext getSingleton];
    if (!aUserC.userSelected)
        [self changeUserShowInfo: nil];
    
    [configView close];
    
    Language* l = [UserContext getLanguageSelected];
    [langButton setImage: l.image forState: UIControlStateNormal];
}

- (IBAction) playCurrentLevel:(id)sender {
    GameSequence *s = [GameSequenceManager getCurrentGameSequence];
    if ([s.gameType isEqualToString: @"Challenge"]) [self playChallengeTrain];
    if ([s.gameType isEqualToString: @"Training"]) [self playTrainingTrain];
}

- (void) playChallengeTrain {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.testTrain;
	[vcDelegate pushTestTrain];
}

- (void) playTrainingTrain {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.trainingTrain;
	[vcDelegate pushTrainingTrain];
}

- (IBAction)changeUserShowInfo:(id)sender {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeUserView];
}

- (IBAction) changeLang:(id)sender {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeLangView];
}



- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    //[self.backgroundSound play];
    [self dismissModalViewControllerAnimated:YES];
	if (result==MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed"
              message:@"Your mail has failed to sent"
              delegate:self
              cancelButtonTitle: @"Dismiss"
              otherButtonTitles:nil];
		[alert show];
	}
}

- (IBAction) albumShowInfo:(id)sender {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushAlbumMenu];
}

- (void) initMap {
    // Configurar el ancho del mapa
    [mapScrollView setContentSize: [ImageManager getMapViewSize]];
    //[mapScrollView initialize];
}



- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) aButtonIndex {
	switch (aButtonIndex) {
		case 0:
			break;
		case 1:
			[[UserContext getSingleton] resetGame];
			[self reloadAllLevels];
			break;
		default:
			break;
	}
}

- (void) reloadAllLevels {
    for (int i=1; i<mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
        [aView removeFromSuperview];
    }
    [self drawAllLeveles];
}

- (void) drawAllLeveles {
    Level *level;
    for (int i=0; i< [Vocabulary countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        [self addImage: level.image
                  pos: [level placeinMap]
                  size: [ImageManager getMapViewLevelSize]];
     
        [self addAccessibleIconToLevel: level];
    }
}

-(void) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    CGRect frame = imageView.frame;
    frame.origin = pos;
    frame.size.width = size;
    frame.size.height = size;
    imageView.frame = frame;
    [ImageManager fitImage: image inImageView: imageView];
    
    [mapScrollView addSubview: imageView];
    [mapScrollView bringSubviewToFront: imageView];
}

- (void) addAccessibleIconToLevel: (Level*) level {
    // To each level is added:
    //     * Nothing if the level is accessible
    //     * Lock icon if the user didn't reach this level
    //     * Buy icon if the user has to buy to unlock the level
    
    CGPoint newPlace = CGPointMake([level placeinMap].x + [ImageManager getMapViewLevelSize] * 0.7, [level placeinMap].y + [ImageManager getMapViewLevelSize] * 0.7);
 
    // Level.order = 1. The first level hardcoded is free. No purchase needed and is unlocked from de beginning
    if (level.order >= [UserContext getMaxLevel] && level.order != 1)
        [self addImage: [UIImage imageNamed:@"BuyButton.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
    else if (level.order >= [UserContext getLevelNumber] && level.order != 1)
        [self addImage: [UIImage imageNamed:@"token-bronze.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
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

- (IBAction) openConfigView {
    [self.mapScrollView addSubview: [self configView].view];
    //configView.view.alpha = 1;
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
