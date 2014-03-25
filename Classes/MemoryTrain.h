//
//  MemoryTrain.h
//  VocabularyTrip
//
//  Created by Ariel on 3/17/14.
//
//

#define cStatusShowWordsForMemorize 9

#import "TestTrain.h"

@interface MemoryTrain : TestTrain {
	CADisplayLink *theTimerToShowCard;
    int i; // Is used as a flag. See
    UIButton *wordButtonToHide;
}

- (void) hideImagesAndShowPokerCard;
- (void) initializeTimer: (int) timer;

@end
