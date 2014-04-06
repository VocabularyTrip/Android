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
    LevelView *levelView;
    bool enabledInteraction;
}

@property (nonatomic, unsafe_unretained) bool enabledInteraction;
@property (nonatomic) LevelView *levelView;

- (void) openLevelView: (Level*) level;

@end








