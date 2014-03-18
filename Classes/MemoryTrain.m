//
//  MemoryTrainViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 3/17/14.
//
//

#import "MemoryTrain.h"
#import "Sentence.h"

@interface MemoryTrain ()

@end

@implementation MemoryTrain

- (void) startGame {
    [super startGame];
    gameStatus =  cStatusShowWordsForMemorize;
}

- (void) trainLoop {
  	if (gameStatus == cStatusShowWordsForMemorize && [self shortInactivity]) {
        gameStatus = cStatusGameIsOn;

        wordButton1.alpha = 0;
        wordButton2.alpha = 0;
        wordButton3.alpha = 0;
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton1];
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton2];
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton3];

        [UIView beginAnimations:@"TestFlip" context: nil];
        [UIView setAnimationDuration: 0.7];
        [UIView setAnimationCurve: UIViewAnimationOptionTransitionCrossDissolve];

        wordButton1.alpha = 1;
        wordButton2.alpha = 1;
        wordButton3.alpha = 1;

        [UIView commitAnimations];
    }
    
	[super trainLoop];
}

- (void) showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	@try {
		if (qOfImagesRemaining > 0)
			[self sayTargetWord];
        
		NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
		UIButton *aWordButton = (UIButton*) [parameters objectForKey: @"button"];
		aWordButton.userInteractionEnabled = YES;
        
        [UIView beginAnimations:@"TestFlip" context: nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationTransitionFlipFromLeft];
        
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: aWordButton];
        
        [UIView commitAnimations];

		[super showWordAnimationDidStop: theAnimation finished: flag context: context];
	} @catch (NSException * e) {
		NSLog(@"Error on showWordAnimationDidStop");
	}
	@finally {
	}
}

- (void) helpAnimation1 {
}

@end
