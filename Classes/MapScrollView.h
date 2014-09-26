//
//  MapScrollView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/15/14.
//
//

#import <UIKit/UIKit.h>
#import "LevelView.h"


@interface MapScrollView : UIScrollView {
}

@property (nonatomic, unsafe_unretained) bool enabledInteraction;

- (void) openLevelView: (Level*) level;
- (void) reloadAllLevels;
- (void) drawAllLeveles;
- (void) removeAllLevels;
- (UIImageView*) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size;
- (bool) addLockIconToLevel: (Level*) level;
- (void) addProgressLevel: (Level*) level;
- (void) showLevelInMap: (Level*) level;

@end








