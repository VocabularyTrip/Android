//
//  MapScrollView.m
//  VocabularyTrip
//
//  Created by Ariel on 1/15/14.
//
//

#import "MapScrollView.h"

@implementation MapScrollView

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (levelView.view.frame.origin.x>0) return;
	[super touchesBegan: touches withEvent: event];
    
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView: touch.view];
    
    int imageSize = 60;
    Level *level;
    for (int i=0; i< [[UserContext getSingleton] countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        if (CGRectContainsPoint(CGRectMake(level.placeInMap.x, level.placeInMap.y, imageSize, imageSize), touchLocation)) {
            [self openLevelView: level];
            return;
        }
    }
}

- (void) openLevelView: (Level*) level {
    if (!levelView) {
        levelView = [[LevelView alloc] initWithNibName: @"LevelView" bundle:[NSBundle mainBundle]];
        
        [self addSubview: levelView.view];

    }
    [levelView showLevel: level at: self.contentOffset];
}

@end
