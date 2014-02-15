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

- (void) viewDidLoad {
    [self initializeGame];
    [self initMap];
    [self drawAllLeveles];

    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) initializeGame {
    [[PurchaseManager getSingleton] initializeObserver];
    [LandscapeManager loadDataFromXML];
    [Vocabulary loadDataFromXML];
    [Sentence loadDataFromXML];
    [GameSequenceManager loadDataFromXML];
    [self initAudioSession];
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

- (void) viewWillAppear:(BOOL)animated {
    int offset=240;
    Level *level = [UserContext getLevelAt: [UserContext getLevel]];
    int newX = level.placeInMap.x > offset ? level.placeInMap.x-offset : 0;
    CGPoint newPlace = CGPointMake(newX, 0);
    [mapScrollView setContentOffset: newPlace animated: YES];

    NSLog(@"place in map: %f, %f", level.placeInMap.x, level.placeInMap.y);
    playCurrentLevelButton.center = CGPointMake(level.placeInMap.x, level.placeInMap.y);
    
    UserContext *aUserC = [UserContext getSingleton];
    if (!aUserC.userSelected)
        [self changeUserShowInfo: nil];
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
    [vcDelegate.testTrain setWordModeGame];
	[vcDelegate pushTestTrain];
}

- (void) playTrainingTrain {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.trainingTrain;
    [vcDelegate.trainingTrain setWordModeGame];
	[vcDelegate pushTrainingTrain];
}

- (IBAction)changeUserShowInfo:(id)sender {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeUserView];
}

- (IBAction) mailButtonClicked:(id)sender {
  	//[self stopBackgroundSound];
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@""];
		[mailCont setToRecipients:[NSArray arrayWithObject: cMailInfo]];
		[mailCont setMessageBody:@"" isHTML:NO];
		
		[self presentModalViewController: mailCont animated:YES];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cant Send Mail"
                                                        message:@"All of your emails accounts are disabled or removed"
                                                       delegate:self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles:nil];
		[alert show];
	}
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

- (IBAction)albumShowInfo:(id)sender {
	//[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushAlbumMenu];
}

- (void) initMap {
    // Configurar el ancho del mapa
    [mapScrollView setContentSize: CGSizeMake(1200, 320)];
}

- (IBAction) buyClicked {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate pushPurchaseView];
}

- (IBAction) resetButtonClicked {
    
	UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"WORNING!"
                          message: @"By reseting, all coins, levels and sticker information about this user will be lost. Are you sure you want to reset?"
                          delegate: self
                          cancelButtonTitle: @"No"
                          otherButtonTitles: @"Yes", nil];
	[alert show];
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
    //for (UIView* aView in mapScrollView.subviews)
        [aView removeFromSuperview];
    }
    [self drawAllLeveles];
}

- (void) drawAllLeveles {
    int imageSize = 60;
    Level *level;
    for (int i=0; i< [[UserContext getSingleton] countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        [self addImage: level.image pos: level.placeInMap size: imageSize];
     
        CGPoint newPlace = CGPointMake(level.placeInMap.x+imageSize*0.7, level.placeInMap.y+imageSize*0.7);
        if (i >= [UserContext getMaxLevel] && i != 0)
            [self addImage: [UIImage imageNamed:@"BuyButton.png"] pos: newPlace size: imageSize*0.4];
        else if (i >= [UserContext getLevel] && i != 0)
            [self addImage: [UIImage imageNamed:@"token-bronze.png"] pos: newPlace size: imageSize*0.4];
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

- (void) helpAnimation1 {
}

- (void) helpDownload1 {
}

@end
