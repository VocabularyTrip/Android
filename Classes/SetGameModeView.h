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
    
    UIButton *__unsafe_unretained noReadAbilityButton;
    UIButton *__unsafe_unretained readAbilityButton;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *noReadAbilityButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *readAbilityButton;

- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) nextButtonPressed:(id)sender;
- (IBAction) helpClicked;
- (IBAction) noReadAbilityClicked;
- (IBAction) readAbilityClicked;

@end

