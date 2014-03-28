//
//  SetGameModeView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "SetGameModeView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation SetGameModeView

@synthesize backButton;
@synthesize nextButton;
@synthesize backgroundView;
@synthesize hand;
@synthesize helpButton;
@synthesize noReadAbilityButton;
@synthesize readAbilityButton;

- (IBAction) prevButtonPressed:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate.navController popViewControllerAnimated: YES];
    [super done: sender];
}

- (IBAction) nextButtonPressed:(id)sender {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate popMainMenuFromSetGameMode];
    [super done: sender];
}

#pragma mark - View lifecycle


- (void) viewWillAppear:(BOOL)animated {
    NSString* coverName = [ImageManager getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];

    [super viewWillAppear: animated];
    
    noReadAbilityButton.alpha = [UserContext getUserSelected].readAbility ? 0.5 : 1;
    readAbilityButton.alpha = [UserContext getUserSelected].readAbility ? 1 : 0.5;
}

- (void)viewDidAppear:(BOOL)animated {
    //if ([UserContext getHelpSelectLang]) [self helpAnimation1];
    [super viewDidAppear: animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction) noReadAbilityClicked {
    noReadAbilityButton.alpha = 1;
    readAbilityButton.alpha = 0.5;
    if ([UserContext getUserSelected].readAbility)
        [GameSequenceManager resetSequence];
    [UserContext getUserSelected].readAbility = NO;
}

- (IBAction) readAbilityClicked {
    noReadAbilityButton.alpha = 0.5;
    readAbilityButton.alpha = 1;
    if (![UserContext getUserSelected].readAbility)
        [GameSequenceManager resetSequence];
    [UserContext getUserSelected].readAbility = YES;
}

-(void) helpClicked {

}

@end















