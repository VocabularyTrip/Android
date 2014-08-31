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
    if ([self isLocked]) {
        if ([self unlockLangSelection]) [self done: nil];
    } else {
        if ([self lockLangSelection]) [self done: nil];
    }
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

- (bool) lockLangSelection {
    if ([password1TextField.text isEqualToString:@""]) {
        errorLabel.text = @"Please complete password";
        errorLabel.textColor = [UIColor redColor];
        return NO;
    } else if (![password1TextField.text isEqualToString: password2TextField.text]) {
        errorLabel.text = @"The two passwords do not machted";
        errorLabel.textColor = [UIColor redColor];
        return NO;
    } else {
        return [self privateLockLangSelection];
    }
}

- (bool) privateLockLangSelection {
    if ([self savePassword]) {
        [UserContext setIsLocked: YES];
        errorLabel.text = @"Language selection is locked";
        errorLabel.textColor = [UIColor blueColor];
        [self refreshView];
        [self selectLangToAllUsers];
        return YES;
    } else {
        errorLabel.text = @"Error saving password.";
        errorLabel.textColor = [UIColor redColor];
        return NO;
    }
}

- (void) selectLangToAllUsers {
    Language *lang = [UserContext getLanguageSelected];
	for (int i=0; i < [[UserContext getSingleton].users count]; i++) {
        User* u = [[UserContext getSingleton].users objectAtIndex: i];
        [u setLangSelected: lang];
	}
}

- (bool) savePassword {
    return [UserContext setUserPassword: password1TextField.text];
}

- (bool) unlockLangSelection {
    NSString *savedPassword = [UserContext getUserPassword];
    if ([password1TextField.text isEqualToString:@""]) {
        errorLabel.text = @"Please complete password";
        errorLabel.textColor = [UIColor redColor];
        return NO;
    } else if (![password1TextField.text isEqualToString: savedPassword]) {
        errorLabel.text = @"Incorrect password";
        errorLabel.textColor = [UIColor redColor];
        return NO;
    } else {
        [UserContext setIsLocked: NO];
        errorLabel.text = @"Language selection is unlocked";
        errorLabel.textColor = [UIColor blueColor];
        [self refreshView];
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshView];
    
    NSString* coverName = [ImageManager getIphone5xIpadFile: @"background_wizard"];
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
        [lockUnlockButton setImage: [UIImage imageNamed: @"unlock1"] forState: UIControlStateNormal];
    } else {
        password1TextField.alpha = 1;
        password2TextField.alpha = 1;
        password2Label.alpha = 1;        
        mailTextField.alpha = 0;
        mailMeButton.alpha = 0;
        mailLabel.alpha = 0;        
        mailDescriptionLabel.alpha = 0;        
        [lockUnlockButton setTitle: @"lock" forState: UIControlStateNormal]; 
        [lockUnlockButton setImage: [UIImage imageNamed: @"lock1"] forState: UIControlStateNormal];
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
