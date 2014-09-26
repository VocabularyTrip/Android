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
@synthesize backgroundView;

- (IBAction) nextButtonPressed: (id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate pushChangeLangView];
    //[super done: sender];
}

- (void) initUsers {
    usersView.viewDelegate = self;

	for (int i=0; i < [[UserContext getSingleton].users count]; i++) {
        User* u = [[UserContext getSingleton].users objectAtIndex: i];

		[(AFOpenFlowView *)self.usersView setImage: [ImageManager imageWithImage: u.image scaledToSize: [ImageManager changeUserUserSize: u.image]] forIndex: i];
	}
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
    
    NSString* coverName = @"background_wizard"; // [ImageManager getIphone5xIpadFile: @"background_wizard"];
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


@end











