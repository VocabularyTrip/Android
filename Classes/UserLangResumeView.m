//
//  UserLangResumeView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/12/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "UserLangResumeView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation UserLangResumeView

@synthesize userView;
@synthesize flagView;
@synthesize nameLabel;
@synthesize moneyGoldLabel;
@synthesize moneyBronzeLabel;
@synthesize moneySilverLabel;
@synthesize progressView;
@synthesize langSelectedLabel;
@synthesize backgroundView;
@synthesize progressBarFillView;
@synthesize hand;
@synthesize helpButton;
@synthesize userInfoView;
@synthesize backButton;
@synthesize buyButton;

- (IBAction)done:(id)sender {
    [self cancelDownload: nil];      
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromUserLangResume];
}

- (IBAction) prevButtonPressed:(id)sender {
    [self cancelDownload: nil];      
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate.navController popViewControllerAnimated: YES];
}

/*- (IBAction) showMoney {
    //moneyView.hidden = NO;
}*/

- (void) updateLevelSlider {
    
    float progress = [Vocabulary wasLearned] / 1;
    progress = [Vocabulary progressIndividualLevel]; // Overwrite with new formula

    CGRect frame = progressView.frame;

    CGRect frameFill = progressBarFillView.frame;
    int deltaWidth = frameFill.size.width;
    int deltaX = frameFill.origin.x;
    
	frame.size.width = deltaWidth * (1-progress);
    frame.origin.x = deltaX + (deltaWidth * progress);
    progressView.frame = frame;
    
}

- (IBAction) buyButtonClicked {
    [self done: nil];
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate pushPurchaseView];
}

- (IBAction) resetButtonClicked {
    //[self startTestAnimation];
    
	UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: @"WORNING!" 
                          message: @"By reseting, all coins, levels and sticker information about this user will be lost. Are you sure you want to reset?"
                          delegate: self 
                          cancelButtonTitle: @"No" 
                          otherButtonTitles: @"Yes", nil];	
	[alert show];
}

/*- (void) startTestAnimation {
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"wheel1@ipad.png"],
                             [UIImage imageNamed:@"wheel2@ipad.png"],
                             [UIImage imageNamed:@"wheel3@ipad.png"],
                             [UIImage imageNamed:@"wheel4@ipad.png"],
                             [UIImage imageNamed:@"wheel5@ipad.png"],
                             [UIImage imageNamed:@"wheel6@ipad.png"],
                             [UIImage imageNamed:@"wheel7@ipad.png"],
                             [UIImage imageNamed:@"wheel8@ipad.png"],
                             nil];
    UIImageView * ryuJump = [[UIImageView alloc] initWithFrame:
                             CGRectMake(100, 125, 61, 61)];
    ryuJump.animationImages = imageArray;
    ryuJump.animationDuration = 1;
    ryuJump.animationRepeatCount = 1;
    
    ryuJump.contentMode = UIViewContentModeBottomLeft;
    [self.view addSubview:ryuJump];
    [ryuJump startAnimating];
}*/

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) aButtonIndex {
	switch (aButtonIndex) {
		case 0:
			break;
		case 1:
			[[UserContext getSingleton] resetGame];
            [self refreshToolbar];
			break;
		default:
			break;
	}	
}



- (void)viewWillAppear:(BOOL)animated {
    User *user = [UserContext getUserSelected];

    nameLabel.text = user.userName;
    [userView setImage: user.imageBig];
    
    Language *lang = [UserContext getLanguageSelected];
    [lang countOfWords];
    
    [flagView setImage: lang.image];
    langSelectedLabel.text = lang.name;

    
    if ([UserContext getMaxLevel] >= 6)
        buyButton.alpha = 0;
    else
        buyButton.alpha = 1;
        
    [self refreshToolbar];

 
    NSString* coverName = [UserContext getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
    [super viewWillAppear: animated];
}

- (void) refreshToolbar {
	moneyBronzeLabel.text = [UserContext getMoney1AsText];	
	moneySilverLabel.text = [UserContext getMoney2AsText];
	moneyGoldLabel.text = [UserContext getMoney3AsText];
    [self updateLevelSlider];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
  if (![Vocabulary isDownloadCompleted]) [self helpAnimation1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) helpAnimation1 {
    // Make clicking hand visible
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
	[UIImageView setAnimationDuration: .5];
	hand.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    // bring clicking hand over download button
	CGRect handFrame = hand.frame;
 	[Sentence playSpeaker: @"LevelView-HelpA"]; 
    CGPoint targetOrigin = [self.view convertPoint: cancelDownloadButton.frame.origin fromView: userInfoView];
    CGRect targetFrame = cancelDownloadButton.frame;
	handFrame.origin.x = targetOrigin.x + (targetFrame.size.width / 2);
	handFrame.origin.y = targetOrigin.y + (targetFrame.size.height / 2);
    
	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)];
    //	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2b:finished:context:)];
	[UIImageView setAnimationDuration: 4];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation3 {
    // click down
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
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: Nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation5)];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation5 {
    // bring hand to name
	CGRect handFrame = hand.frame;
  
    CGRect backFrame = backButton.frame;
	handFrame.origin.x = backFrame.origin.x + (backFrame.size.width / 2);
	handFrame.origin.y = backFrame.origin.y + (backFrame.size.height / 2);

	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
    //	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2b:finished:context:)];
	[UIImageView setAnimationDuration: 2];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation6 {
    // click down
	//[Sentence playSpeaker: @"LevelView-Help"];
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation7)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation7 {
    // Release click
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: Nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation8)];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation8 {
    // bring hand to original position
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: .5];
	hand.alpha = 0;
	[UIImageView commitAnimations];
  
	[UserContext setHelpLevel: NO];
	helpButton.enabled = YES;
}



@end
