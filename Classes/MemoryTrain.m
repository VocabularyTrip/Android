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

        wordButtonToHide = nil; // Thats mean Hide all words
        [self initializeTimer: 120];

        [UIView commitAnimations];
    }
    
	//[super trainLoop];
}


- (void) initializeTimer: (int) timer {
	if (theTimerToShowCard == nil) {
        i = 0;
		theTimerToShowCard = [CADisplayLink displayLinkWithTarget:self selector:@selector(hideImagesAndShowPokerCard)];
		theTimerToShowCard.frameInterval = timer;
		[theTimerToShowCard addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) hideImagesAndShowPokerCard {
    if (i == 0) { i++; return;}
    
    if (!wordButtonToHide) {
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton1];
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton2];
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButton3];
        //[AnimatorHelper rotateView: wordButton1];
    } else {
        [ImageManager fitImage: [UIImage imageNamed: @"PokerCard.png"] inButton: wordButtonToHide];

    }
    
    if (qOfImagesRemaining > 0)
    	[self sayTargetWord];

    [theTimerToShowCard invalidate];
    theTimerToShowCard = nil;
}

- (void) showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	@try {
        //if (qOfImagesRemaining > 0)
		//	[self sayTargetWord];
        
		NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
        wordButtonToHide = (UIButton*) [parameters objectForKey: @"button"];
		wordButtonToHide.userInteractionEnabled = YES;
        
        [self initializeTimer: 60];
        
		//[super showWordAnimationDidStop: theAnimation finished: flag context: context];
	} @catch (NSException * e) {
		NSLog(@"Error on showWordAnimationDidStop");
	}
	@finally {
	}
}

- (void) helpAnimation1 {
}


/*
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"key"];
 CATransform3D tranform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
 tranform.m34 = 1.0 / 800.0;
 [animation setToValue: [NSValue valueWithCATransform3D: tranform]];
 [animation setDuration: 0.5];
 [animation setFillMode: kCAFillModeForwards];
 //[animation setTimingFunction: [CAMediaTimingFunction functionWithName: @"kCAMediaTimingFunctionEasyIn"]];
 
 
 wordButton2.alpha = 0;
 wordButton3.alpha = 0;
 
 [UIView beginAnimations:@"TestFlip" context: nil];
 [UIView setAnimationDuration: 0.7];
 [UIView setAnimationCurve: UIViewAnimationOptionTransitionCrossDissolve];
 
 
 [wordButton1.layer addAnimation: animation forKey: @"test"];
 wordButton2.alpha = 1;
 wordButton3.alpha = 1;
 
 */

@end
