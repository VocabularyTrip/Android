//
//  ChangeLangView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import "Language.h"
#import "ImageManager.h"
#import "GenericViewController.h"
#import "Reachability.h"

@interface ChangeLangView : GenericViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource> {
    AFOpenFlowView *__unsafe_unretained langsView;
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained nextButton;
    UILabel *__unsafe_unretained langLabel;
    Language *langSelected;
    //UIImageView *__unsafe_unretained progressView;
    //UIImageView *__unsafe_unretained progressBarFillView;
    UIButton *__unsafe_unretained lockUnlockButton;
    UIImageView *__unsafe_unretained backgroundView;

    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained hand;
    float angle;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *langLabel;
@property (nonatomic, unsafe_unretained) IBOutlet AFOpenFlowView *langsView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *lockUnlockButton;
//@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressView;
//@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressBarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;

- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) nextButtonPressed:(id)sender;
- (IBAction) lockLangPressed:(id)sender;

- (void) initLangs;
- (void) openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index;
- (void) viewDidLoad;
- (void) viewDidAppear:(BOOL)animated;
//- (void) updateLevelSlider;
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
//- (void) helpAnimation10;

@end

