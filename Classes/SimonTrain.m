//
//  SimonTrain.m
//  VocabularyTrip
//
//  Created by Ariel on 3/17/14.
//
//

#import "SimonTrain.h"
#import "Sentence.h"

@interface SimonTrain ()

@end

@implementation SimonTrain

- (void) startGame {
    [super startGame];
    qOfImagesRemaining = 12;
    sequence = [[NSMutableArray alloc] init];
    [sequence addObject: [self getNextRandomSeq]];
    [self startSequence];
 }

- (void) startSequence {
    [NSThread sleepForTimeInterval: 0.2];
    currentSeq = 0;
    gameIsShowingTargetSequence = YES;
    wordButton1.userInteractionEnabled = NO;
    wordButton2.userInteractionEnabled = NO;
    wordButton3.userInteractionEnabled = NO;
    [self showSequence];
}

- (void) showSequence {

    NSLog(@"Remaining: %i", qOfImagesRemaining);
    
    if (currentSeq < [sequence count]) {
        int wordIndex = [[sequence objectAtIndex: currentSeq] intValue];
        Word *word = [words objectAtIndex: wordIndex];
        if (![word playSoundWithDelegate: self])
            [self pushLevelWithHelpDownload];

        NSLog(@"Seg: %i, value: %i", currentSeq, wordIndex);
        if (wordIndex == 0)
            [AnimatorHelper shakeView: wordButton1];
        else if (wordIndex == 1)
            [AnimatorHelper shakeView: wordButton2];
        else if (wordIndex == 2)
            [AnimatorHelper shakeView: wordButton3];

    } else {
        currentSeq = 0;
        gameIsShowingTargetSequence = NO;
        wordButton1.userInteractionEnabled = YES;
        wordButton2.userInteractionEnabled = YES;
        wordButton3.userInteractionEnabled = YES;
        
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (gameIsShowingTargetSequence) {
        currentSeq++;
        [self performSelector: @selector(showSequence) withObject: nil afterDelay: 0.3];
    }
}

- (void) wordButton: (UIButton*) aButton buttonLabel: (UIButton*) aButtonLabel clicked: (int) i {
    if (gameIsShowingTargetSequence) return;
    NSLog(@"Remaining: %i", qOfImagesRemaining);
    qOfImagesRemaining--;
    if ([[sequence objectAtIndex: currentSeq] intValue] == i) {
        AudioServicesPlaySystemSound(self.closeSoundId);
        /*Word *word = [words objectAtIndex: i];
        if (![word playSound])
            [self pushLevelWithHelpDownload];*/
        currentSeq ++;
        if (currentSeq >= [sequence count]) { // Finish the sequence successfully
            if (qOfImagesRemaining <= 0) // End Game
                [self endGame];
            else {
                //[Sentence playSpeaker: @"Test-EndGame-Amazing"];
                [sequence addObject: [self getNextRandomSeq]];
                [self startSequence];
            }
        }
    } else {
        AudioServicesPlayAlertSound(errorSoundId);
        [sequence removeAllObjects];
        if (qOfImagesRemaining <= 0) // End Game
            [self endGame];
        else {
            [sequence addObject: [self getNextRandomSeq]];
            [self startSequence];
        }
    }
}

- (void) endGame {
	//[super endGame];
    [GameSequenceManager nextSequence];
	[self refreshMoneyLabels];
}

- (NSNumber*) getNextRandomSeq {
    // First sequence is a random between 0 - 2
    if ([sequence count] == 0) return [NSNumber numberWithInt: arc4random() % 3];

    // Following sequence avoid repeated number
    int i = arc4random() % 2;
    int lastI = [[sequence lastObject] intValue];
    int r;
    if (lastI == 0) r = i == 0 ? 1 : 2;
    if (lastI == 1) r = i == 0 ? 0 : 2;
    if (lastI == 2) r = i == 0 ? 0 : 1;
    return [NSNumber numberWithInt: r];
}

- (void) trainLoop {
	if (gameStatus == cStatusGameIsOn) {
		if ([self shortInactivity]) {
			//[self sayTargetWord];
		}
        
/*		if ([self longInactivity]) {
			[self pauseClicked];
			if (viewMode == 1) [Sentence playSpeaker: @"Test-TrainLoop-inactivity"];
			inactivity2 = CFAbsoluteTimeGetCurrent();
		}*/
	}
	[self moveWagon];
}

- (void) helpAnimation1 {
}

@end
