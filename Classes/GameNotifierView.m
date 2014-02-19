//
//  SelectGameMode.m
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import "GameNotifierView.h"
#import "GenericTrain.h"

@implementation GameNotifierView

@synthesize gameTypelabel;
@synthesize includeWordsLabel;
@synthesize includeImagesLabel;
@synthesize readAbilityLabel;
@synthesize cumulativeLabel;
@synthesize parentView;

- (void) viewDidLoad {
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) show {
    
    gameTypelabel.text = [GameSequenceManager getCurrentGameSequence].gameType;
    cumulativeLabel.text = [GameSequenceManager getCurrentGameSequence].cumulative ? @"Yes" : @"No";
    includeImagesLabel.text = [GameSequenceManager getCurrentGameSequence].includeImages ? @"Yes" : @"No";
    includeWordsLabel.text = [GameSequenceManager getCurrentGameSequence].includeWords ? @"Yes" : @"No";

    self.view.frame = CGRectMake(50, 50, 0, 0);
    self.view.alpha = 0;
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 430, 220);
        self.view.alpha = 1;
    }];
    
}

- (IBAction) hide {
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 0, 0);
        self.view.alpha = 0;
    }];
    
    //[parentView startGame];
    [parentView introduceTrain];
}

@end
