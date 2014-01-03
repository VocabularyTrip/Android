//
//  MainMenu.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/22/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "MainMenu.h"
#import "Sentence.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation MainMenu

@synthesize backgroundSound;
@synthesize backgroundView;
@synthesize albumButton;

- (void) initialize {
    [[PurchaseManager getSingleton] initializeObserver];
    [LandscapeManager loadDataFromXML];
    [Vocabulary loadDataFromXML];
    [Sentence loadDataFromXML];
    [self initAudioSession];
    albumId = 0;

}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(albumFlipAnimation)];
		theTimer.frameInterval = 400;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	@try {
		[super viewDidLoad];
	}	
	@catch (NSException * e) {
		NSLog(@"Error Initializing MainMenu");
	}
	@finally {
	}
    //[self initAlbums];
}

-(void) viewWillAppear:(BOOL)animated {
    NSString* coverName = [ImageManager getIphone5xIpadFile: @"menu_bg"];
	[backgroundView setImage: [UIImage imageNamed: coverName]];

    UserContext *aUserC = [UserContext getSingleton];
    if (!aUserC.userSelected)
        [self changeUserShowInfo: nil];
} 

-(void) viewDidAppear:(BOOL)animated {
	[self.backgroundSound play]; // If soundEnabled is false the volumne is 0. This play prepare buffer and resourses to prevent delay in first word

    [self initializeTimer];

}


- (AVAudioPlayer*) backgroundSound {
	if (backgroundSound == nil) {
		backgroundSound = [Sentence getAudioPlayer: @"keepTrying"];
		backgroundSound.numberOfLoops = -1;
		//[backgroundSound autorelease];
	}
    backgroundSound.volume = UserContext.soundEnabled == YES ? 1 : 0;
	return backgroundSound;
}

- (IBAction)changeUserShowInfo:(id)sender {    
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeUserView];
}

- (IBAction) mailButtonClicked:(id)sender {
  	[self stopBackgroundSound];
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@""];
		[mailCont setToRecipients:[NSArray arrayWithObject: cMailInfo]];
		[mailCont setMessageBody:@"" isHTML:NO];
		
		[self presentModalViewController:mailCont animated:YES];
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
    
    [self.backgroundSound play];
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

-(void) stopBackgroundSound {
	if (backgroundSound) {
		[backgroundSound stop];
		backgroundSound = nil;
	}
}

- (IBAction)levelShowInfo:(id)sender {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushLevelView];
}

- (IBAction)challengeTrainShowInfo:(id)sender {    
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.testTrain;
	[vcDelegate pushTestTrain];
}

- (IBAction)trainingTrainShowInfo:(id)sender {    
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	Sentence.delegate = vcDelegate.trainingTrain ;
	[vcDelegate pushTrainingTrain];
}

- (IBAction)albumShowInfo:(id)sender {
	[self stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushAlbumMenu];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) albumFlipAnimation {
	// Hide Image
	[UIView beginAnimations:@"AlbumFlipAnimationAnimation" context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration: 1];
	[UIView setAnimationDidStopSelector: @selector(albumFlipAnimationDidStop:finished:context:)];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: albumButton cache:YES];

    NSString *imageName;
    if (albumId == 0)
        imageName = [ImageManager getIphoneIpadFile: @"cover-monster"];
    else if (albumId == 1)
        imageName = [ImageManager getIphoneIpadFile: @"cover-animal"];
    else
        imageName = [ImageManager getIphoneIpadFile: @"cover-princess"];

    [albumButton setImage: [UIImage imageNamed: imageName] forState: UIControlStateNormal];

	[UIView commitAnimations];
    
    albumId++;
    if (albumId > 2) albumId = 0;
}

- (void) albumFlipAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in MainMenu");
    // Release any cached data, images, etc. that aren't in use.
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
