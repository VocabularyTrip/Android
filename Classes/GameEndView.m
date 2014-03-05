//
//  SelectGameMode.m
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import "GameEndView.h"
#import "GenericTrain.h"

@implementation GameEndView

@synthesize backgroundView;
@synthesize parentView;

- (void) viewDidLoad {
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) show {
    int deltaX = ([ImageManager windowWidthXIB] - backgroundView.frame.size.width) / 2;
    int deltaY = ([ImageManager windowHeightXIB] - backgroundView.frame.size.height) / 2;
    
    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(
                                     deltaX, deltaY,
                                     backgroundView.frame.size.width,
                                     backgroundView.frame.size.height);
        self.view.alpha = 1;
    }];
}

- (IBAction) hide {
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 0, 0);
        self.view.alpha = 0;
    }];
  	[parentView done: nil];			// Return to main menu
}

@end
