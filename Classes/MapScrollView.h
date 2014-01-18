//
//  MapScrollView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/15/14.
//
//

#import <UIKit/UIKit.h>
#include "LevelView.h"
#include "UserContext.h"

@interface MapScrollView : UIScrollView {
    LevelView *levelView;
}

- (void) openLevelView: (Level*) level;

@end
