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

@interface PurchaseView : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, PurchaseDelegate> { 

	UIButton *__unsafe_unretained backButton;
	UIButton *__unsafe_unretained buyAllButton;
	UIButton *__unsafe_unretained restorePurchaseButton;
	UITextField *__unsafe_unretained promoCodeText;
    UILabel *__unsafe_unretained promoCodeStatus;
    UILabel *__unsafe_unretained promoCodeLabel;
    UIImageView *__unsafe_unretained backgroundView;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *buyAllButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *restorePurchaseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *promoCodeText;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *promoCodeStatus;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *promoCodeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) done:(id)sender;
- (IBAction) restorePurchase:(id)sender;
- (IBAction) buyAllLevels;
- (IBAction) registerPromoCode;

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL) textFieldShouldReturn: (UITextField*) textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (void) disableBuyButtons;
- (NSString*) getPriceOf: (NSString*) purchase;
//- (void) showPromoCodeResult: (PromoCodeResult) promoCodeResult;
- (void) refreshLevelInfo;
    
- (void) responseToBuyAction;
- (void) responseToCancelAction;



@end