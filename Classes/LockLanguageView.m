//
//  LockLanguageView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/21/13.
//  Copyright (c) 2013 __VocabularyTrip__. All rights reserved.
//

#import "LockLanguageView.h"
#import "VocabularyTrip2AppDelegate.h"
#import "MailingManager.h"

@implementation LockLanguageView

@synthesize password1TextField;
@synthesize password2TextField;
@synthesize mailTextField;
@synthesize langView;
@synthesize lockUnlockButton;
@synthesize mailMeButton;
@synthesize password2Label;
@synthesize mailLabel;
@synthesize mailDescriptionLabel;
@synthesize errorLabel;
@synthesize backgroundView;

- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popFromLockLanguageView];
}

- (IBAction) lockUnlockButtonClicked :(id)sender {
    [self.view endEditing: YES];
    if ([self isLocked]) 
        [self unlockLangSelection];
    else
        [self lockLangSelection];
}

- (IBAction) mailMePasswordButtonClicked :(id)sender {
    if ([mailTextField.text isEqualToString:@""]) {
        errorLabel.text = @"Please add a mail";
        errorLabel.textColor = [UIColor redColor];
    } else if (![self validateEmailWithString: mailTextField.text]) {
        errorLabel.text = @"Mail format is not valid";
        errorLabel.textColor = [UIColor redColor];
    } else {
        [MailingManager sendMail: [UserContext getUserPassword] to: mailTextField.text];
        errorLabel.text = @"Password sent to your mailbox";
        errorLabel.textColor = [UIColor blueColor];    
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

- (bool) isLocked {
    return [UserContext getIsLocked];
}

- (void) lockLangSelection {
    if ([password1TextField.text isEqualToString:@""]) {
        errorLabel.text = @"Please complete password";
        errorLabel.textColor = [UIColor redColor];
    } else if (![password1TextField.text isEqualToString: password2TextField.text]) {
        errorLabel.text = @"The two passwords do not machted";
        errorLabel.textColor = [UIColor redColor];
    } else {
        [self privateLockLangSelection];        
    }
}

- (void) privateLockLangSelection {
    if ([self savePassword]) {
        [UserContext setIsLocked: YES];
        errorLabel.text = @"Language selection is locked";
        errorLabel.textColor = [UIColor blueColor];
        [self refreshView];
    } else {
        errorLabel.text = @"Error saving password.";
        errorLabel.textColor = [UIColor redColor];        
    }
}

- (bool) savePassword {
    return [UserContext setUserPassword: password1TextField.text];
}

- (void) unlockLangSelection {
    NSString *savedPassword = [UserContext getUserPassword];
    if ([password1TextField.text isEqualToString:@""]) {
        errorLabel.text = @"Please complete password";
        errorLabel.textColor = [UIColor redColor];
    } else if (![password1TextField.text isEqualToString: savedPassword]) {
        errorLabel.text = @"Incorrect password";
        errorLabel.textColor = [UIColor redColor];
    } else {
        [UserContext setIsLocked: NO];
        errorLabel.text = @"Language selection is unlocked";
        errorLabel.textColor = [UIColor blueColor];
        [self refreshView];    
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshView];
    
    NSString* coverName = [UserContext getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
    [super viewWillAppear: animated];
        
}

- (void) refreshView {
    Language *lang = [UserContext getLanguageSelected];
    [langView setImage: lang.image];
    if ([self isLocked]) {
        password1TextField.alpha = 1;
        password2TextField.alpha = 0;
        password2Label.alpha = 0;
        mailTextField.alpha = 1;
        mailMeButton.alpha = 1;        
        mailLabel.alpha = 1;
        mailDescriptionLabel.alpha = 1;
        [lockUnlockButton setTitle: @"Unlock" forState: UIControlStateNormal]; 
        [lockUnlockButton setImage: [UIImage imageNamed: [UserContext getIphoneIpadFile: @"unlock"]] forState: UIControlStateNormal];
    } else {
        password1TextField.alpha = 1;
        password2TextField.alpha = 1;
        password2Label.alpha = 1;        
        mailTextField.alpha = 0;
        mailMeButton.alpha = 0;
        mailLabel.alpha = 0;        
        mailDescriptionLabel.alpha = 0;        
        [lockUnlockButton setTitle: @"lock" forState: UIControlStateNormal]; 
        [lockUnlockButton setImage: [UIImage imageNamed: [UserContext getIphoneIpadFile: @"lock"]] forState: UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	password2TextField.delegate = self;
    password1TextField.delegate = self;
    mailTextField.delegate = self;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

-(BOOL) textFieldShouldReturn: (UITextField*) textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag: nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
	//[[NSUserDefaults standardUserDefaults] setObject: textField.text forKey: cMailKey];
}
@end
