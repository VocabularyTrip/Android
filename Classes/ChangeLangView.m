//
//  ChangeLangView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "ChangeLangView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation ChangeLangView

@synthesize backButton;
@synthesize nextButton;
@synthesize langsView;
@synthesize langLabel;
@synthesize lockUnlockButton;
//@synthesize progressView;
@synthesize backgroundView;
//@synthesize progressBarFillView;
@synthesize hand;
@synthesize helpButton;

- (IBAction) prevButtonPressed:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate.navController popViewControllerAnimated: YES];
    [super done: sender];
}

- (IBAction) nextButtonPressed:(id)sender {
    
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate popMainMenuFromChangeLang];
    [super done: sender];

    // this code enable the step 3 to select modes (images / words)
    /*VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate pushSetGameModeView];
    [super done: sender];*/
    
    [vocTripDelegate checkAndStartDownload];
  	[UserContext setHelpSelectLang: NO];
    
}

- (IBAction) lockLangPressed:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate pushLockLanguageView];
}

- (void) initLangs {
    langsView.viewDelegate = self;

	for (int i=0; i < [[Language getAllLanguages] count]; i++) {
        Language* l = [[Language getAllLanguages] objectAtIndex: i];
		[(AFOpenFlowView *)self.langsView setImage: l.image forIndex:i];
	}
	[(AFOpenFlowView *)self.langsView setNumberOfImages: [[Language getAllLanguages] count]];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {

    Language* l = [[Language getAllLanguages] objectAtIndex: index];
    langLabel.text = l.name;

    User *user = [[UserContext getSingleton] userSelected];
    user.langSelected = l;
    //[l countOfWords]; // Start request to the server to check how much words should be downloaded.
    
    //[self updateLevelSlider];
}

/*- (void) updateLevelSlider {
    
    double progress = [Vocabulary progressIndividualLevel];
    progressView.frame = [Vocabulary resizeProgressFrame: progressView.frame toNewProgress: progress progressFill: progressBarFillView.frame];

    
    // Original is widh: 434, x: 295
    float progress = [Vocabulary wasLearned] / 1;
    //NSLog(@"General Progress: %f", progress);
    
	// New formula of Progress
    progress = [Vocabulary progressIndividualLevel];
    //NSLog(@"Progress this Level: %f", progress);
    CGRect frame = progressView.frame;
    
    CGRect frameFill = progressBarFillView.frame;
    int deltaWidth = frameFill.size.width;
    int deltaX = frameFill.origin.x;
    
	frame.size.width = deltaWidth * (1-progress);
    frame.origin.x = deltaX + (deltaWidth * progress);
    progressView.frame = frame;
   
}*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLangs];

    [langsView setSelectedCover: 0];
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSString* coverName = [ImageManager getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
 
    langSelected = [UserContext getLanguageSelected];
    [langSelected countOfWords]; // start request to the server to check how much words should be downloaded
    langLabel.text = langSelected.name;

    if ([UserContext getIsLocked]) {
        langsView.alpha = 0.5;
        langsView.userInteractionEnabled = NO;
        [lockUnlockButton setImage: [UIImage imageNamed: @"unlock1"] forState: UIControlStateNormal];
    } else {
        langsView.alpha = 1;
        langsView.userInteractionEnabled = YES;
        [lockUnlockButton setImage: [UIImage imageNamed: @"lock1"] forState: UIControlStateNormal];
    }
    //[self updateLevelSlider];
    
    if (langSelected.key >= 6)
        [langsView setSelectedCover: 6];
    
    [langsView setSelectedCover: langSelected.langOrder];
    [langsView centerOnSelectedCover: YES];
    
    [super viewWillAppear: animated];

    // Initialize to check if there are Internet Connection
    /*internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    Reachability *hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachable startNotifier];*/
}

- (void)viewDidAppear:(BOOL)animated {
    if ([UserContext getHelpSelectLang]) [self helpAnimation1];
    [super viewDidAppear: animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) helpClicked {
    [self helpAnimation1];
}

- (void) helpAnimation1 {
    // Make clicking hand visible
    if (flagCancelAllSounds) return;
    
    nextButton.enabled = NO;
    backButton.enabled = NO;
    
    lockUnlockButton.enabled = NO;
    
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
	[UIImageView setAnimationDuration: .3];
	hand.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    // bring hand to language
    if (flagCancelAllSounds) return;
	[Sentence playSpeaker: @"Language_Wizard_1"];
	CGRect handFrame = hand.frame;
    
    langSelected = [UserContext getLanguageSelected];
    int langKey = langSelected.key;
    int dir=1; // if we are in the last flag, the hand has to move to the left.
    
    // La comparaci[on est[a mal !!!!!
    // el key no corresponde con el indice
    if (langKey == [[Language getAllLanguages] count]) dir = -1;
    
    CGRect langsFrame = langsView.frame;
	handFrame.origin.x = langsFrame.origin.x + (langsFrame.size.width / 2)
    + [AFItemView getCoverSpacing] * dir;
	handFrame.origin.y = langsFrame.origin.y + (langsFrame.size.height / 2);
   
	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)];
	[UIImageView setAnimationDuration: 3.2];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation3 {
    // click down
    if (flagCancelAllSounds) return;
    langSelected = [UserContext getLanguageSelected];
    int langKey = langSelected.key;
    if (langKey == [[Language getAllLanguages] count]) langKey--; else langKey++;
    langKey--; // Users array start from 0, while userId start from 1

    Language* l = [[Language getAllLanguages] objectAtIndex: langKey];
    langLabel.text = l.name;

    User *user = [[UserContext getSingleton] userSelected];
    user.langSelected = l;

    [langsView setSelectedCover: langKey];
    [langsView centerOnSelectedCover: YES];

    CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation4)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation4 {
    // Release click
    if (flagCancelAllSounds) return;    
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: Nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .5];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation5)];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation5 {
    // Move hand to lock button
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"Language_Wizard_2"];
    
	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
    angle = 0;    // set it up to start always in the same place in helpAnimation6
	[UIImageView setAnimationDuration: 3];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
    // center hand in lockUnlockButton
    CGPoint center = lockUnlockButton.center;
    center.x += lockUnlockButton.frame.size.height;
    center.y += lockUnlockButton.frame.size.width;
    hand.center = center;
  
	[UIImageView commitAnimations];
  
}

- (void) helpAnimation6 {
    // hover over lock button
    if (flagCancelAllSounds) return;    
    CGPoint center = hand.center;

    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>2.8*M_PI) {
       [UIImageView setAnimationDidStopSelector: @selector(helpAnimation7)];
    }
    else {
       [UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
    }
    [UIImageView setAnimationDuration: .025];
    [UIImageView setAnimationBeginsFromCurrentState: YES];

    center.x = lockUnlockButton.center.x + lockUnlockButton.frame.size.width/2 + lockUnlockButton.frame.size.width/2*cos(angle);
    center.y = lockUnlockButton.center.y + lockUnlockButton.frame.size.height/2 - lockUnlockButton.frame.size.height/2*sin(angle);
    hand.center = center;
  
    angle += M_PI/100;
    [UIImageView commitAnimations];
}


- (void) helpAnimation7 {
    // bring hand to nextButton
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"User_Wizard_3"];
    CGRect handFrame = hand.frame;

	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation8)];
	[UIImageView setAnimationDuration: 2];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	handFrame.origin.x = nextButton.frame.origin.x + (nextButton.frame.size.width / 2);
	handFrame.origin.y = nextButton.frame.origin.y + (nextButton.frame.size.height / 2);

    hand.frame = handFrame;

	[UIImageView commitAnimations];
}

- (void) helpAnimation8 {
    // bring hand to alpha = 0
    if (flagCancelAllSounds) return;    
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation9)];
	[UIImageView setAnimationDuration: .5];

	hand.alpha = 0;
	[UIImageView commitAnimations];
}

- (void) helpAnimation9 {
    // bring hand to start position
    if (flagCancelAllSounds) return;  
	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: .1];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
    hand.center = backButton.center;
	[UIImageView commitAnimations];
  	[UserContext setHelpSelectLang: NO];
    
    nextButton.enabled = YES;
    backButton.enabled = YES;
    lockUnlockButton.enabled = YES;
    
}

@end















