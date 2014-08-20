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
@synthesize buyOneSetofLevelesButton;
@synthesize restorePurchaseButton;
@synthesize promoCodeText;
@synthesize promoCodeStatus;
@synthesize promoCodeLabel;
@synthesize backgroundView;
@synthesize buyAllDescLabel;
@synthesize buyOneSetDescLabel;
@synthesize buyAllNameLabel;
@synthesize buyOneSetNameLabel;
@synthesize facebookButton;
@synthesize noReachabilityButton;

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
    flagBuyAllLevels = YES;
    [self implementParentalGate];
}

- (IBAction) buyOneSetOfLevels {
    flagBuyAllLevels = NO;
    [self implementParentalGate];
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
    if ([alertView.title isEqualToString: @""]) {
        NSString *value = [[alertView textFieldAtIndex: 0] text];
        if (resultParentalGate == [value intValue]) {
            [PurchaseManager getSingleton].delegate = self;
            if (flagBuyAllLevels)
                [PurchaseManager buyAllLevels];
            else
                [PurchaseManager buyNextSetOfLevel];
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
}

- (IBAction) registerPromoCode {
    [PromoCode getSingleton].delegate = self;
    
    [PromoCode registerPromoCode: promoCodeText.text];
    //[self showPromoCodeResult: p]; // Has to be called asyncronic from PromoCode
}

- (IBAction) facebookButtonClicked {
    
    [FacebookManager initFacebookSession];
    //[FacebookManager facebookLogin];
    //[FacebookManager requestForMe];
    //[FacebookManager requestWritePermissions];
    //[FacebookManager inviteAFriend];
    //[FacebookManager loadListOfFriends];
    //[FacebookManager requestWritePermissions];
    
    if ([FacebookManager postFeedDialog: 0] == tFacebookNotFacebookApp) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Facebook Result"
                              message: @"Facebook app has to be installed"
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
        [alert show];
    };
}

- (IBAction) claimProductsAgain: (id) sender {
    [[PurchaseManager getSingleton] initializeObserver];
}

- (void) viewWillAppear:(BOOL)animated { 
	[self refreshLevelInfo];
    NSString* coverName = [ImageManager getIphone5xIpadFile: @"level_bg"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    promoCodeStatus.text = [[NSUserDefaults standardUserDefaults] objectForKey: cPromoCodeStatus];
    promoCodeText.text = [[NSUserDefaults standardUserDefaults] objectForKey: cPromoCode];
}

- (void) refreshLevelInfo {
    SKProduct* aProduct;
	restorePurchaseButton.enabled = 1; //[UserContext getMaxLevel] >= cSet1OfLevels ? 1 : 0;
    promoCodeText.enabled = [UserContext getMaxLevel] <= cSet2OfLevels ? 1 : 0;
    facebookButton.enabled = [[UserContext getSingleton] qPostInFacebook] < cMaxPostInFasebook ? 1 : 0;
    noReachabilityButton.alpha = 0;

    aProduct = [PurchaseManager getProductoFromIdentifier: [PurchaseManager getPurchaseOneSet]];
    [buyOneSetofLevelesButton
     setTitle: [PurchaseManager getPriceAsText: aProduct]
     forState: UIControlStateNormal];
    
    if ([UserContext getMaxLevel] < [Vocabulary countOfLevels]) {
        buyOneSetofLevelesButton.enabled  =  1;
        if (!aProduct) {
            noReachabilityButton.alpha = 1;
            buyOneSetDescLabel.alpha = 0;
            buyOneSetNameLabel.alpha = 0;
            buyAllButton.alpha = 0;
            buyOneSetofLevelesButton.alpha = 0;
            [self throbNoReachabilityButton];
        } else {
            buyAllButton.alpha = 1;
            buyOneSetofLevelesButton.alpha = 1;
            noReachabilityButton.alpha = 0;
            buyOneSetDescLabel.alpha = 1;
            buyOneSetNameLabel.alpha = 1;
            buyOneSetDescLabel.text = aProduct.localizedDescription;
            buyOneSetNameLabel.text = aProduct.localizedTitle;
        }
    } else {
        buyOneSetofLevelesButton.enabled  =  0;
        [buyOneSetofLevelesButton setTitle: @"" forState: UIControlStateNormal];
        buyOneSetDescLabel.text = @"";
        buyOneSetNameLabel.text = @"";
    }

    aProduct = [PurchaseManager getProductoFromIdentifier: [PurchaseManager getPurchaseAllSet]];
    [buyAllButton
     setTitle: [PurchaseManager getPriceAsText: aProduct]
     forState: UIControlStateNormal];
    
    if ([UserContext getMaxLevel] < cSet2OfLevels) {
        buyAllButton.enabled =  1;
        if (!aProduct) {
            noReachabilityButton.alpha = 1;
            buyAllDescLabel.alpha = 0;
            buyAllNameLabel.alpha = 0;
        } else {
            noReachabilityButton.alpha = 0;
            buyAllDescLabel.alpha = 1;
            buyAllNameLabel.alpha = 1;
            buyAllDescLabel.text = aProduct.localizedDescription;
            buyAllNameLabel.text = aProduct.localizedTitle;
        }
    } else {
        buyAllButton.enabled =  0;
        [buyAllButton setTitle: @"" forState: UIControlStateNormal];
        buyAllDescLabel.text = @"";
        buyAllNameLabel.text = @"";
    }


}

- (void) throbNoReachabilityButton {
    SKProduct* aProduct;
    aProduct = [PurchaseManager getProductoFromIdentifier: [PurchaseManager getPurchaseAllSet]];
    if (aProduct) {
        [self refreshLevelInfo];
        return;
    }
    
	[UIView beginAnimations:@"HideWordAnimation" context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDidStopSelector: @selector(throbNnoReachabilityButtonOff)];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	noReachabilityButton.alpha = 0.5;
	[UIView commitAnimations];
}

- (void) throbNnoReachabilityButtonOff {
    SKProduct* aProduct;
    aProduct = [PurchaseManager getProductoFromIdentifier: [PurchaseManager getPurchaseAllSet]];
    if (aProduct) {
        [self refreshLevelInfo];
        return;
    }
    
	[UIView beginAnimations:@"HideWordAnimation" context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDidStopSelector: @selector(throbNoReachabilityButton)];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	noReachabilityButton.alpha = 1;
	[UIView commitAnimations];
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
    buyOneSetofLevelesButton.enabled = NO;
    restorePurchaseButton.enabled = NO;
}

-(void) responseToBuyAction {
    
    //VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
//    vocTripDelegate.mapView.startWithHelpPurchase = 1;
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
