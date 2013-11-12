//
//  ChangeLangView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "ChangeUserView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation ChangeUserView

@synthesize backButton;
@synthesize nextButton;
@synthesize userNameText;
@synthesize usersView;
@synthesize moneyGoldLabel;
@synthesize moneyBronzeLabel;
@synthesize moneySilverLabel;
@synthesize backgroundView;
@synthesize hand;
@synthesize helpButton;

/*- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromChangeLang];
}*/

- (IBAction) nextButtonPressed: (id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate pushChangeLangView];
    [super done: sender];
}

- (CGSize) getSize {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return CGSizeMake(250, 350);
    else
        return CGSizeMake(125, 175);
}

- (void) initUsers {
    usersView.viewDelegate = self;

	for (int i=0; i < [[UserContext getSingleton].users count]; i++) {
        User* u = [[UserContext getSingleton].users objectAtIndex: i];
        //NSLog(@"user i: %i, name: %@", i, u.userName);
        
		[(AFOpenFlowView *)self.usersView setImage: [ImageManager imageWithImage: u.image scaledToSize: [self getSize]] forIndex: i];
	}
    //NSLog(@"User Count: %i", [[UserContext getSingleton].users count]);
	[(AFOpenFlowView *)self.usersView setNumberOfImages: [[UserContext getSingleton].users count]];
}

- (IBAction) updateUserName {
    User *user = [[UserContext getSingleton] userSelected];
    user.userName = userNameText.text;
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {

    // Set user Selected
    User *user = [[UserContext getSingleton].users objectAtIndex: index];
    [[UserContext getSingleton] setUserSelected: user];
    [UserContext reloadContext];
     
    // Update user name
    userNameText.text = user.userName;
    [self refreshLabels];
    //[AnimatorHelper avatarGreet: [openFlowView getSelectedCoverView].imageView];
 }

- (void) refreshLabels {
	moneyBronzeLabel.text = [UserContext getMoney1AsText];	
	moneySilverLabel.text = [UserContext getMoney2AsText];
	moneyGoldLabel.text = [UserContext getMoney3AsText];
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
    [self initUsers];

    [usersView setSelectedCover: 0];
   
    userNameText.delegate = self;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString: @"My Name"]) textField.text = @"";
}

- (BOOL) textFieldShouldReturn: (UITextField*) aTextField {
    if ([aTextField.text isEqualToString: @""]) aTextField.text = @"My Name";
    [userNameText resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString* coverName = [UserContext getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
    
    User *user = [UserContext getUserSelected];
    if (!user) {
        user = [[UserContext getSingleton].users objectAtIndex: 0];
        [[UserContext getSingleton] setUserSelected: user];
    }
    
    if (user.userId >= 6)
        [usersView setSelectedCover: 6];
    
    [usersView setSelectedCover: [[UserContext getSingleton].users indexOfObject: user]];
    [usersView centerOnSelectedCover: YES];
    
    userNameText.text = user.userName;
    [self refreshLabels];
    
    [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([UserContext getHelpSelectUser]) [self helpAnimation1];
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
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
	[UIImageView setAnimationDuration: .3];
	hand.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    // bring clicking hand onto a character
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"User_Wizard_1"];

    CGRect handFrame = hand.frame;
    CGRect usersFrame = usersView.frame;
    int deltaX = [AFItemView getCoverSpacing];
    int userId = [UserContext getUserSelected].userId;
    if (userId == [[UserContext getSingleton].users count]) deltaX=deltaX*-1;

	handFrame.origin.x = usersFrame.origin.x + (usersFrame.size.width / 2) + deltaX;

	handFrame.origin.y = usersFrame.origin.y + (usersFrame.size.height / 2); 
	
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)];
	[UIImageView setAnimationDuration: 2.5];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation3 {
    // click down
    if (flagCancelAllSounds) return;
    
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

    int userId = [UserContext getUserSelected].userId;
    if (userId == [[UserContext getSingleton].users count]) userId--; else userId++;
    userId--; // Users array start from 0, while userId start from 1
    User *user = [[UserContext getSingleton].users objectAtIndex: userId];
    [[UserContext getSingleton] setUserSelected: user];
    [usersView setSelectedCover: userId];
    [usersView centerOnSelectedCover: YES];
    userNameText.text = user.userName;
    
	[UIImageView beginAnimations: @"helpAnimation" context: Nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .3];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation5)];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation5 {
    // bring hand to name
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"User_Wizard_2"];

	CGRect handFrame = hand.frame;
  
    CGRect userNameFrame = userNameText.frame;
	handFrame.origin.x = userNameFrame.origin.x + (userNameFrame.size.width / 2);
	handFrame.origin.y = userNameFrame.origin.y + (userNameFrame.size.height / 2);

	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
	[UIImageView setAnimationDuration: 2.5];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation6 {
    // click down
    if (flagCancelAllSounds) return;
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
    // Release click and write name
    if (flagCancelAllSounds) return;    
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
    // Move hand to nextButton
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"User_Wizard_3"];
  
    CGPoint handCenter = hand.center;

    // bring hand to arrow pointing to next page
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: 2];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation9)];

    handCenter.x = nextButton.center.x + hand.frame.size.width/2;
    handCenter.y = nextButton.center.y + hand.frame.size.height/2;
    hand.center = handCenter;
  
    [UIImageView commitAnimations];
  
	[UserContext setHelpSelectUser: NO];
	helpButton.enabled = YES;
}

- (void) helpAnimation9 {
    // make hand dissapear
    if (flagCancelAllSounds) return;
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: .5];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation10)];
	hand.alpha = 0;
	[UIImageView commitAnimations];
  
  
	[UserContext setHelpSelectUser: NO];
	helpButton.enabled = YES;
}

- (void) helpAnimation10 {
    // Bring hand to original position
    if (flagCancelAllSounds) return;
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDuration: .5];
    CGPoint handCenter = userNameText.center;
    handCenter.x = userNameText.center.x;
    handCenter.y = userNameText.center.y;
    hand.center = handCenter;
  
	[UIImageView commitAnimations];
  
	[UserContext setHelpSelectUser: NO];
	helpButton.enabled = YES;
}

@end











