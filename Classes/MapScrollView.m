//
//  MapScrollView.m
//  VocabularyTrip
//
//  Created by Ariel on 1/15/14.
//
//

#import "MapScrollView.h"
#import "UserContext.h"

@implementation MapScrollView

@synthesize levelView;
@synthesize enabledInteraction;

- (instancetype)init
{
    self = [super init];
    if (self) {
        enabledInteraction = YES;
        levelView.view.tag = 998;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    Level *level1 = [UserContext getLevel];
    NSLog(@"offset: %f, levelPLaceInMap: %f, windowWith: %i", self.contentOffset.x, [level1 placeinMap].x, [ImageManager windowWidth]);
    
    if (!enabledInteraction) return;
    if ([self levelView].view.frame.origin.x > 0) return;
    
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
        levelView.view.alpha = 0;
        [self addSubview: levelView.view];
        levelView.parentView = self;
    }
    
    return levelView;
}

- (void) openLevelView: (Level*) level {
    [self setEnabledInteraction: NO];
    [levelView showLevel: level at: self.contentOffset];
}

- (void) setEnabledInteraction: (bool) value {
    self.scrollEnabled = value;
    enabledInteraction = value;
}

@end
