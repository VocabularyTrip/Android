//
//  ChangeUserView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import "Language.h"
#import "GenericViewController.h"

@interface ChangeUserView : GenericViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource, UITextFieldDelegate> {
    
    AFOpenFlowView *__unsafe_unretained usersView;
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained nextButton;    
    UITextField *__unsafe_unretained userNameText;
    UILabel *__unsafe_unretained moneyBronzeLabel;
    UILabel *__unsafe_unretained moneySilverLabel;
    UILabel *__unsafe_unretained moneyGoldLabel;
    UIImageView *__unsafe_unretained backgroundView;

    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained hand;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *userNameText;
@property (nonatomic, unsafe_unretained) IBOutlet AFOpenFlowView *usersView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneyBronzeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneySilverLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneyGoldLabel;    
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;

//- (IBAction)done:(id)sender;
- (IBAction) nextButtonPressed: (id)sender;
- (void) initUsers;
- (IBAction) updateUserName;
- (void) openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index;
- (void) viewDidLoad;
- (BOOL) textFieldShouldReturn: (UITextField*) aTextField;
- (void) refreshLabels;
- (IBAction) helpClicked;
- (void) helpAnimation1;
- (void) helpAnimation2;
- (void) helpAnimation3;
- (void) helpAnimation4;
- (void) helpAnimation5;
- (void) helpAnimation6;
- (void) helpAnimation7;
- (void) helpAnimation8;
- (void) helpAnimation9;
- (void) helpAnimation8;
//- (void) helpAnimation11;
@end

