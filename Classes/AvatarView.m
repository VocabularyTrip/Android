//
//  AvatarView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/22/13.
//  Copyright (c) 2013 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationImages  = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1.png"],
                                 [UIImage imageNamed:@"2.png"],
                                 [UIImage imageNamed:@"3.png"],
                                 [UIImage imageNamed:@"4.png"],
                                 [UIImage imageNamed:@"5.png"],
                                 [UIImage imageNamed:@"6.png"],
                                 [UIImage imageNamed:@"7.png"],
                                 [UIImage imageNamed:@"8.png"],
                                 [UIImage imageNamed:@"9.png"],
                                 [UIImage imageNamed:@"10.png"],
                                 [UIImage imageNamed:@"11.png"],
                                 [UIImage imageNamed:@"12.png"],
                                 nil];
        self.animationDuration = 1.1;
        self.animationRepeatCount = 2;
    }
    return self;
}

- (void) startAnimatingEyes: (UIView*) aView {

    CGPoint p = self.center;
    p.x += 100;
    self.center = p;
    
    [UIView animateWithDuration:20
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.center = CGPointMake(p.x, p.y);
                     }
                     completion:^(BOOL finished){
                     }];
    self.contentMode = UIViewContentModeBottomLeft;
    [aView addSubview: self];
    [self startAnimating];
}


@end
