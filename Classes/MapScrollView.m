//
//  MapScrollView.m
//  VocabularyTrip
//
//  Created by Ariel on 1/15/14.
//
//

#import "MapScrollView.h"
#import "UserContext.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation MapScrollView

- (void) reloadAllLevels {
    [self removeAllLevels];
    [self drawAllLeveles];
}

- (void) removeAllLevels {
    int i = 0;
    while (self.subviews.count > i) {
        UIView *aView = [self.subviews objectAtIndex: i];
        if (aView.tag < 100) { // Three UIViews are fixed with tag 999. The rest of views belong to levels and icons. Will be added in drawAllLevels
            [aView removeFromSuperview];
        } else {
            i++;
        }
    }
}

- (void) drawAllLeveles {
    Level *level;
    for (int i=0; i< [Vocabulary countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        UIImage* stage = [UserContext getLevelNumber] >= i ? [UIImage imageNamed: @"stage_on.png"] : [UIImage imageNamed: @"stage_off.png"];
        [self addImage: stage
                   pos: [level placeinMap]
                  size: [ImageManager getMapViewLevelSize]];
        
        // We add progress if the level is unlocked.
        // Often you need unlock to reach the level and make any progress
        // Is posible to temprally unlock the game (via facebook for example).
        // In this case the user can advance, make some progress. If the unlock due, the lock and the progress are located in the same position.
        if ([self addAccessibleIconToLevel: level])
            [self addProgressLevel: level];
    }
}

-(UIImageView*) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    CGRect frame = imageView.frame;
    frame.origin = pos;
    frame.size.width = size;
    frame.size.height = size;
    imageView.frame = frame;
    [ImageManager fitImage: image inImageView: imageView];
    
    [self addSubview: imageView];
    [self bringSubviewToFront: imageView];
    return imageView;
}

- (bool) addAccessibleIconToLevel: (Level*) level {
    // To each level is added:
    //     * Nothing if the level is accessible
    //     * Lock icon if the user didn't reach this level
    //     * Buy icon if the user has to buy to unlock the level
    
    CGPoint newPlace = CGPointMake([level placeinMap].x + [ImageManager getMapViewLevelSize] * 0.8, [level placeinMap].y + [ImageManager getMapViewLevelSize] * 0.3);
    
    if (level.order > [UserContext getTemporalMaxLevel] && level.order > cSetLevelsFree) {
        [self addImage: [UIImage imageNamed:@"lock2.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
        return NO;
    }/* else if (level.order > ([UserContext getLevelNumber]+1) && level.order != 1) {
      [self addImage: [UIImage imageNamed:@"token-bronze.png"] pos: newPlace size: [ImageManager getMapViewLevelSize] * 0.4];
      }*/
    return YES;
}

- (void) addProgressLevel: (Level*) level {
    
    if (level.order <= ([UserContext getLevelNumber]+1) || level.order == 1) {
        int starSize = [ImageManager getMapViewLevelSize] / 2 * 1.1;
        CGPoint newPlace = CGPointMake(
                                       [level placeinMap].x + [ImageManager getMapViewLevelSize] * 0.6,
                                       [level placeinMap].y + [ImageManager getMapViewLevelSize] * 0.3);
        
        double progress = [Vocabulary progressLevel: level.levelNumber];
        UIImage *star1, *star2, *star3;
        
        star1 = progress > cThresholdStar1 ? [UIImage imageNamed:@"star_on.png"] : [UIImage imageNamed:@"star_off.png"];
        star2 = progress > cThresholdStar2 ? [UIImage imageNamed:@"star_on.png"] : [UIImage imageNamed:@"star_off.png"];
        star3 = progress > cThresholdStar3 ? [UIImage imageNamed:@"star_on.png"] : [UIImage imageNamed:@"star_off.png"];
        
        [self addImage: star1
                   pos: (CGPoint) {newPlace.x, newPlace.y}
                  size: starSize];
        
        [self addImage: star2
                   pos: (CGPoint) {newPlace.x + starSize * 0.6, newPlace.y}
                  size: starSize];
        
        [self addImage: star3
                   pos: (CGPoint) { newPlace.x + starSize * 1.2, newPlace.y}
                  size: starSize];
        
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan: touches withEvent: event];
    
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView: touch.view];
    
    Level *level;
    for (int i=0; i< [Vocabulary countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        
        if (CGRectContainsPoint(CGRectMake([level placeinMap].x, [level placeinMap].y, [ImageManager getMapViewLevelSize], [ImageManager getMapViewLevelSize]), touchLocation)) {
            
            if ([[touches anyObject] tapCount] == 2)
                [self openLevelView: level];
            else
                [self showLevelInMap: level];
            return;
        }
    }
}

- (void) showLevelInMap: (Level*) level {
    UIImageView* imageLevel = [self addImage: level.image
               pos: [level placeinMap]
              size: [ImageManager getMapViewLevelSize]];
    
	[UIView beginAnimations: @"ShowLevelInMap" context: (__bridge void *)(imageLevel)];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(showLevelInMapDidStop:finished:context:)];
	[UIView setAnimationDuration: 4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    imageLevel.alpha = 0;
	[UIView commitAnimations];
}

- (void)showLevelInMapDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    UIImageView* imageLevel = (__bridge UIImageView*) context;
    [imageLevel removeFromSuperview];
}

- (void) openLevelView: (Level*) level {

	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.mapView stopBackgroundSound];
    vcDelegate.levelView.level = level;
	[vcDelegate pushLevelView];
    
}

@end
