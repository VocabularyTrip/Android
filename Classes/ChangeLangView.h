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
#import "Reachability.h"

@interface ChangeLangView : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource> {
    AFOpenFlowView *__unsafe_unretained langsView;
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained nextButton;
    UILabel *__unsafe_unretained langLabel;
    Language *langSelected;
    UIImageView *__unsafe_unretained backgroundView;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *langLabel;
@property (nonatomic, unsafe_unretained) IBOutlet AFOpenFlowView *langsView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) nextButtonPressed:(id)sender;

- (void) initLangs;
- (void) openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index;
- (void) viewDidLoad;


@end

