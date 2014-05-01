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
@synthesize noReadAbilityImageButton;
@synthesize noReadAbilityLabel;
@synthesize noReadAbilityWagonView;
@synthesize noReadAbilityWheel1View;
@synthesize noReadAbilityWheel2View;

// ReadAbility
@synthesize readAbilityButton;
@synthesize readAbilityImageButton;
@synthesize readAbilityLabel;
@synthesize readAbilityWagonView;
@synthesize readAbilityWheel1View;
@synthesize readAbilityWheel2View;


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
    
    [self setAlphaToReadAbility];
}

- (void)viewDidAppear:(BOOL)animated {
    //if ([UserContext getHelpSelectLang]) [self helpAnimation1];
    [super viewDidAppear: animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) setAlphaToReadAbility {
    float alphaReadAbility, alphaNoReadAbility;
    
    alphaReadAbility = [UserContext getUserSelected].readAbility ? 1 : 0.5;
    alphaNoReadAbility = [UserContext getUserSelected].readAbility ? 0.5 : 1;
 
    // No ReadAbility
    noReadAbilityButton.alpha = alphaNoReadAbility;
    noReadAbilityImageButton.alpha = alphaNoReadAbility;
    noReadAbilityLabel.alpha = alphaNoReadAbility;
    noReadAbilityWagonView.alpha = alphaNoReadAbility;
    noReadAbilityWheel1View.alpha = alphaNoReadAbility;
    noReadAbilityWheel2View.alpha = alphaNoReadAbility;
    
    // ReadAbility
    readAbilityButton.alpha = alphaReadAbility;
    readAbilityImageButton.alpha = alphaReadAbility;
    readAbilityLabel.alpha = alphaReadAbility;
    readAbilityWagonView.alpha = alphaReadAbility;
    readAbilityWheel1View.alpha = alphaReadAbility;
    readAbilityWheel2View.alpha = alphaReadAbility;
}

- (IBAction) noReadAbilityClicked {
    [UserContext getUserSelected].readAbility = NO;
    [[UserContext getUserSelected] reloadLevel];
    [self setAlphaToReadAbility];
}

- (IBAction) readAbilityClicked {
    [UserContext getUserSelected].readAbility = YES;
    [[UserContext getUserSelected] reloadLevel]; // Force read the level corresponding with read ability
    [self setAlphaToReadAbility];
}

-(void) helpClicked {

}

@end
