//
//  SelectGameMode.m
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import "SelectGameMode.h"

@implementation SelectGameMode

- (void) viewDidLoad {
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) show {
    self.view.frame = CGRectMake(50, 50, 0, 0);
    self.view.alpha = 0;
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 430, 220);
        self.view.alpha = 1;
    }];
}

- (IBAction) closeClicked {
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 0, 0);
        self.view.alpha = 0;
    }];
}

@end
