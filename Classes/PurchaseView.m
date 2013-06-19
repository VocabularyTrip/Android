//
//  PurchaseView.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/6/11.
//  Copyright 2011 VocabularyTrip. All rights reserved.
//

#import "PurchaseView.h"
#import "UserContext.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation PurchaseView


@synthesize backButton;
@synthesize buyAllButton;
@synthesize restorePurchaseButton;
@synthesize promoCodeText;
@synthesize promoCodeStatus;
@synthesize promoCodeLabel;
@synthesize backgroundView;
@synthesize imageHelp1View;
@synthesize imageHelp2View;

- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromPurchase];
    [PurchaseManager getSingleton].delegate = nil;
}

- (IBAction) restorePurchase:(id)sender {
    [PurchaseManager getSingleton].delegate = self;	
    [[PurchaseManager getSingleton] checkPurchasedItems];
	[self disableBuyButtons];
}

- (IBAction) buyAllLevels {
	[PurchaseManager getSingleton].delegate = self;	
	[PurchaseManager buyAllLevels];
	[self disableBuyButtons];
}

- (IBAction) registerPromoCode {
    
    [PromoCode registerPromoCode: promoCodeText.text];
    //[self showPromoCodeResult: p]; // Has to be called asyncronic from PromoCode
}

- (void) viewWillAppear:(BOOL)animated { 
	[self refreshLevelInfo];
    NSString* coverName = [UserContext getIphone5xIpadFile: @"background_purchase"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    promoCodeStatus.text = [[NSUserDefaults standardUserDefaults] objectForKey: cPromoCodeStatus];
    promoCodeText.text = [[NSUserDefaults standardUserDefaults] objectForKey: cPromoCode];
}

- (NSString*) getPriceOf: (NSString*) purchase {
    for (SKProduct *oneProduct in [PurchaseManager getSingleton].products)
        if ([oneProduct.productIdentifier isEqualToString: purchase]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setLocale: oneProduct.priceLocale];
            return [formatter stringFromNumber: oneProduct.price];
        }    
    return @"";
}

- (void) refreshLevelInfo {

	buyAllButton.enabled = [UserContext getMaxLevel] < 6 ? 1 : 0;
	restorePurchaseButton.enabled = [UserContext getMaxLevel] < 6 ? 1 : 0;
    promoCodeText.enabled = [UserContext getMaxLevel] < 6 ? 1 : 0;

    [buyAllButton 
       setTitle: [self getPriceOf: [PurchaseManager getCompletePurchaseIdentier: cPurchaseAllLevels]] 
       forState: UIControlStateNormal]; 
    
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

-(BOOL) textFieldShouldReturn: (UITextField*) textField {
	[textField resignFirstResponder];
    [self registerPromoCode];
	return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
	//[[NSUserDefaults standardUserDefaults] setObject: textField.text forKey: cMailKey];
}

-(void) disableBuyButtons {
	buyAllButton.enabled = NO; 
    restorePurchaseButton.enabled = NO;
}

-(void) responseToBuyAction {
	//if ([UserContext nextLevel]) 	
	//	[Sentence playSpeaker: @"AppDelegate-ResponseToBuyAction-NextLevel"];

	[self refreshLevelInfo];	
}

-(void) responseToCancelAction {
	[self refreshLevelInfo];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"didReceiveMemoryWarning in LevelView");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction) helpAnimation1 {
	[Sentence playSpeaker: @"Purchase_Help_1"];
    // Make clicking hand visible
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
	[UIImageView setAnimationDuration: 4];
    imageHelp1View.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    // bring hand to language
	[Sentence playSpeaker: @"Purchase_Help_2"];
    imageHelp1View.alpha = 0;
    
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)];
	[UIImageView setAnimationDuration: 4];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    imageHelp2View.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation3 {
    imageHelp2View.alpha = 0;
}

@end
