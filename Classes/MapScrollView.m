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
    
    Level *level;
    for (int i=0; i< [Vocabulary countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        
        if (CGRectContainsPoint(CGRectMake([level placeinMap].x, [level placeinMap].y, [ImageManager getMapViewLevelSize], [ImageManager getMapViewLevelSize]), touchLocation)) {
            [self openLevelView: level];
            return;
        }
    }
}

- (LevelView*) levelView {
    if (!levelView) {
      	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            levelView = [[LevelView alloc] initWithNibName: @"LevelView~ipad" bundle:[NSBundle mainBundle]];
        } else {
            levelView = [[LevelView alloc] initWithNibName: @"LevelView" bundle:[NSBundle mainBundle]];
        }
    }
    return levelView;
}

- (void) openLevelView: (Level*) level {
    
    //if (!levelView) {
    //    levelView = [[LevelView alloc] initWithNibName: @"LevelView" bundle:[NSBundle mainBundle]];
        [self addSubview: [self levelView].view];
    //}
    [levelView showLevel: level at: self.contentOffset];
}


/*- (void) initialize {
    [[self levelView] initialize];
}*/

@end
