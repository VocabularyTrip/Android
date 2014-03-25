//
//  SimonTrain.h
//  VocabularyTrip
//
//  Created by Ariel on 3/17/14.
//
//

#import "TestTrain.h"

@interface SimonTrain : TestTrain {
    NSMutableArray *sequence;
    int currentSeq;
    bool gameIsShowingTargetSequence; // YES the game is showing the sequence. NO the user is repeating the sequence
    // simonMode is used in audioPlayerDidFinishPlaying
}

- (void) showSequence;
- (NSNumber*) getNextRandomSeq;

@end
