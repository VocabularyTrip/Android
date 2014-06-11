//
//  PurchaseView.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/6/11.
//  Copyright 2011 VocabularyTrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>	
#import "PurchaseProtocol.h"
#import "PurchaseManager.h"
#import "PromoCode.h"

#define cParentalGateTitle @"Parental Gate"

@interface PurchaseView : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, PurchaseDelegate> {

	UIButton *__unsafe_unretained backButton;
	UIButton *__unsafe_unretained buyAllButton;
	UIButton *__unsafe_unretained buyOneSetofLevelesButton;
	UIButton *__unsafe_unretained restorePurchaseButton;
	UIButton *__unsafe_unretained facebookButton;
	UIButton *__unsafe_unretained noReachabilityButton;
	UITextField *__unsafe_unretained promoCodeText;
    UILabel *__unsafe_unretained promoCodeStatus;
    UILabel *__unsafe_unretained promoCodeLabel;
    UIImageView *__unsafe_unretained backgroundView;
    UILabel *__unsafe_unretained buyAllDescLabel;
    UILabel *__unsafe_unretained buyOneSetDescLabel;
    
    int resultParentalGate;
    bool flagBuyAllLevels; // indicate if the requirements is buy all levels. YES --> All Level, NO --> next set of levels.
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *buyAllButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *buyOneSetofLevelesButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *restorePurchaseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *facebookButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *noReachabilityButton;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *promoCodeText;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *promoCodeStatus;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *promoCodeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *buyAllDescLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *buyOneSetDescLabel;


- (IBAction) done:(id)sender;
- (IBAction) restorePurchase:(id)sender;
- (IBAction) buyAllLevels;
- (IBAction) buyOneSetOfLevels;
- (IBAction) registerPromoCode;
- (IBAction) facebookButtonClicked;

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL) textFieldShouldReturn: (UITextField*) textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (void) disableBuyButtons;

//- (void) showPromoCodeResult: (PromoCodeResult) promoCodeResult;
- (void) refreshLevelInfo;
    
- (void) responseToBuyAction;
- (void) responseToCancelAction;
- (void) implementParentalGate;
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex;

@end