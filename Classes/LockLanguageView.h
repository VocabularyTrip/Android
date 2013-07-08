//
//  LockLanguageView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/21/13.
//  Copyright (c) 2013 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LockLanguageView : UIViewController <UITextFieldDelegate> {
    UITextField *__unsafe_unretained password1TextField;
    UITextField *__unsafe_unretained password2TextField;
    UITextField *__unsafe_unretained mailTextField;
    UILabel *__unsafe_unretained password2Label;
    UILabel *__unsafe_unretained mailLabel;
    UILabel *__unsafe_unretained mailDescriptionLabel;
    UILabel *__unsafe_unretained errorLabel;
    UIImageView *__unsafe_unretained langView;
    UIButton *__unsafe_unretained lockUnlockButton;
    UIButton *__unsafe_unretained mailMeButton;
    UIImageView *__unsafe_unretained backgroundView;    
    bool isLocked;
}

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *password1TextField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *password2TextField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *mailTextField;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *langView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *lockUnlockButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *mailMeButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *password2Label;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *mailLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *mailDescriptionLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *errorLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) done:(id)sender;
- (BOOL) textFieldShouldReturn: (UITextField*) textField;
- (IBAction) lockUnlockButtonClicked :(id)sender;
- (IBAction) mailMePasswordButtonClicked :(id)sender;
- (bool) isLocked;
- (bool) lockLangSelection;
- (bool) unlockLangSelection;
- (bool) privateLockLangSelection;
- (void) refreshView;
- (bool) savePassword;
- (BOOL)validateEmailWithString:(NSString*)email;

@end
