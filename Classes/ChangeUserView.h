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

@interface ChangeUserView : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource, UITextFieldDelegate> {
    
    AFOpenFlowView *__unsafe_unretained usersView;
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained nextButton;    
    UITextField *__unsafe_unretained userNameText;
    UIImageView *__unsafe_unretained backgroundView;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *userNameText;
@property (nonatomic, unsafe_unretained) IBOutlet AFOpenFlowView *usersView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) nextButtonPressed: (id)sender;
- (void) initUsers;
- (IBAction) updateUserName;
- (void) openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index;
- (void) viewDidLoad;
- (BOOL) textFieldShouldReturn: (UITextField*) aTextField;
- (void) refreshLabels;

@end

