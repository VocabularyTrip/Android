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

- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromPurchase];
    [PurchaseManager getSingleton].delegate = nil;
    [PromoCode getSingleton].delegate = nil;
}

- (IBAction) restorePurchase:(id)sender {
    [PurchaseManager getSingleton].delegate = self;	
    [[PurchaseManager getSingleton] checkPurchasedItems];
	[self disableBuyButtons];
}

- (IBAction) buyAllLevels {
    [self implementParentalGate];
	/*[PurchaseManager getSingleton].delegate = self;
	[PurchaseManager buyAllLevels];
	[self disableBuyButtons];*/
}

- (void) implementParentalGate {
    
    int n1 = arc4random() % 40 + 40;
    int n2 = arc4random() % 40 + 40;
    NSString *message = [NSString stringWithFormat: @"Before, solve this problem: %i + %i", n1, n2];
    
    resultParentalGate = n1 + n2;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"" //cParentalGateTitle
                          message: message
                          delegate:self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex: 0] setKeyboardType: UIKeyboardTypeNumberPad];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![alertView.title isEqualToString: cParentalGateTitle]) return;
    
    NSString *value = [[alertView textFieldAtIndex: 0] text];
    if (resultParentalGate == [value intValue]) {
        [PurchaseManager getSingleton].delegate = self;
        [PurchaseManager buyAllLevels];
    } else {
        [self refreshLevelInfo];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Parental Gate Result"
                              message: @"Ask an adult to unlock purchase"
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction) registerPromoCode {
    [PromoCode getSingleton].delegate = self;
    
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
    
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    vocTripDelegate.levelView.startWithHelpPurchase = 1;
    [self done: nil];
    
/*    [PurchaseManager getSingleton].delegate = nil;
    [PromoCode getSingleton].delegate = nil;

	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];

	[vocTripDelegate pushLevelView]; //]WithHelp];*/
	
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

@end
