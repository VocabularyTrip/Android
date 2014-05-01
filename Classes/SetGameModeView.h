//
//  SetGameModeView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageManager.h"
#import "GenericViewController.h"

@interface SetGameModeView : GenericViewController  {
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained nextButton;
    UIImageView *__unsafe_unretained backgroundView;
    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained hand;
    float angle;

    // No ReadAbility
    UIButton *__unsafe_unretained noReadAbilityButton;
    UIButton *__unsafe_unretained noReadAbilityImageButton;
    UILabel *__unsafe_unretained noReadAbilityLabel;
    UIImageView *__unsafe_unretained noReadAbilityWagonView;
    UIImageView *__unsafe_unretained noReadAbilityWheel1View;
    UIImageView *__unsafe_unretained noReadAbilityWheel2View;

    // ReadAbility
    UIButton *__unsafe_unretained readAbilityButton;
    UIButton *__unsafe_unretained readAbilityImageButton;
    UILabel *__unsafe_unretained readAbilityLabel;
    UIImageView *__unsafe_unretained readAbilityWagonView;
    UIImageView *__unsafe_unretained readAbilityWheel1View;
    UIImageView *__unsafe_unretained readAbilityWheel2View;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;

// No ReadAbility
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *noReadAbilityButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *noReadAbilityImageButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *noReadAbilityLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *noReadAbilityWagonView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *noReadAbilityWheel1View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *noReadAbilityWheel2View;

// ReadAbility
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *readAbilityButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *readAbilityImageButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *readAbilityLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *readAbilityWagonView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *readAbilityWheel1View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *readAbilityWheel2View;

- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) nextButtonPressed:(id)sender;
- (IBAction) helpClicked;
- (IBAction) noReadAbilityClicked;
- (IBAction) readAbilityClicked;
- (void) setAlphaToReadAbility;

@end

