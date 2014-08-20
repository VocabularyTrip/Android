//
//  TestTrain.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/14/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "TestTrain.h"
#import "UserContext.h"
#import "Sentence.h"
#import "TrainingTrain.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation TestTrain

- (IBAction) done:(id)sender {
	[super done: sender];

	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromTestTrain];
    //[self evaluateGetIntoNextLevel];
}

/*- (IBAction) playAgainButtonClicked:(id)sender {
    [super done: nil];
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromTestTrain];
    
    NSUInteger result = [self evaluateGetIntoNextLevel];
    // If the result is nextLevel or buyRequired, the play again is ignored. The user is forwarded to map or purchase view.
    if (result == tResultEvaluateNextLevel_none ||
        result == tResultEvaluateNextLevel_closeToNextLevel)
        [vocTripDelegate.mapView playCurrentLevel: nil];
}*/

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	
	wordButton1.userInteractionEnabled = YES;
	wordButton2.userInteractionEnabled = YES;
	wordButton3.userInteractionEnabled = YES;
    wordButtonLabel1.userInteractionEnabled = YES;
    wordButtonLabel2.userInteractionEnabled = YES;
    wordButtonLabel3.userInteractionEnabled = YES;
}

- (IBAction) pauseClicked { 
	inactivity2 = CFAbsoluteTimeGetCurrent();	
	[super pauseClicked];
}

- (void) introduceTrain { 
	[super introduceTrain];
//	if (viewMode == 1 && [UserContext getHelpTest])
//		([Sentence playSpeaker: @"Test-IntroduceTrain"]);
	[self selectNextTarget];		
}

- (void) trainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	[super trainAnimationDidStop: theAnimation finished: flag context: context];
	inactivity2 = CFAbsoluteTimeGetCurrent();
	if ([UserContext getHelpTest]) [self helpAnimation1];
}

- (void)takeoutTrainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    [super takeoutTrainAnimationDidStop: theAnimation finished: flag  context: context];
}

- (void) showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	@try {
		if (qOfImagesRemaining > 0 && gameStatus == cStatusGameIsOn)
			[self sayTargetWord];

		NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
		UIButton *aWordButton = (UIButton*) [parameters objectForKey: @"button"];
		aWordButton.userInteractionEnabled = YES;
		
		[super showWordAnimationDidStop: theAnimation finished: flag context: context];
	} @catch (NSException * e) {
		NSLog(@"Error on showWordAnimationDidStop");
	}
	@finally {
	}
}

- (void) sayTargetWord {
	Word *word = [words objectAtIndex: targetId];
    if (![word playSound]) {
        [self done: nil];
        [self pushLevelWithHelpDownload];
    }
	inactivity1 = CFAbsoluteTimeGetCurrent();
}

- (void) selectNextTarget {
	targetId = arc4random() % 3;
	flagFaild = NO;
}

/*- (void) addMoney {
	if (money <= hitsOfLevel1) {
		[UserContext addMoney1: cBronzeHitPrice];
		[self refreshMoneyViews: cBronzeType];
	} else if (money <= hitsOfLevel2 + hitsOfLevel1) {
		[UserContext addMoney2: cSilverHitPrice];
		[self refreshMoneyViews: cSilverType];
	} else if (money <= hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) {
		[UserContext addMoney3: cGoldHitPrice];
		[self refreshMoneyViews: cGoldType];		
	} 
}

- (void) refreshMoneyLabelsFinished {
    [self takeOutTrain];
}*/

- (bool) checkFinishGame: (Word*) word {
    return (qOfImagesRemaining <= 0 || !word);
}

- (void) endGame {
	[super endGame];
    gameStatus = cStatusGameIsMoneyCount;
	if (viewMode == 1) {
		int hitRate = [self hitRate];
		if (hitRate < 4) {
			[Sentence playSpeaker: @"Test-EndGame-Level0" delegate: self selector: @selector(refreshMoneyLabels)];
            [[UserContext getUserSelected] nextSequence: @"Training"];
		} else if (hitRate < 6) {
			[Sentence playSpeaker: @"Test-EndGame-Level1" delegate: self selector: @selector(refreshMoneyLabels)];
            [[UserContext getUserSelected] nextSequence];
		} else if (hitRate < 8) {
			[Sentence playSpeaker: @"Test-EndGame-Level2" delegate: self selector: @selector(refreshMoneyLabels)];
            [[UserContext getUserSelected] nextSequence: @"Challenge"];
		} else if (hitRate < 10) {
			[Sentence playSpeaker: @"Test-EndGame-Level3" delegate: self selector: @selector(refreshMoneyLabels)];
            [[UserContext getUserSelected] nextSequence: @"Challenge"];
		} else {
			[Sentence playSpeaker: @"Test-EndGame-Level4" delegate: self selector: @selector(refreshMoneyLabels)];
            [[UserContext getUserSelected] nextSequence: @"Challenge"];
		}
	}
//	[self refreshMoneyLabels];
}

/*-(void) sentenceDidFinish: (NSString*) method {
    if ([method isEqualToString: @"Test-EndGame-PracticeMore"]
        || [method isEqualToString: @"Test-EndGame-GoodJob"]
        || [method isEqualToString: @"Test-EndGame-GreatJob"]
        || [method isEqualToString: @"Test-EndGame-Amazing"])
	[self refreshMoneyLabels];
}*/

- (void) trainLoop {
	if (gameStatus == cStatusGameIsOn) {
		if ([self shortInactivity]) {
			[self sayTargetWord];
		}
		if ([self longInactivity]) {
			[self pauseClicked];
			if (viewMode == 1) [Sentence playSpeaker: @"Test-TrainLoop-inactivity"];
			inactivity2 = CFAbsoluteTimeGetCurrent();	
		}
	}
	[super trainLoop];
}

- (bool) shortInactivity {
	return 
	//gameStatus == cStatusGameIsOn &&
	viewMode == 1 && 
	CFAbsoluteTimeGetCurrent() - inactivity1 > cElapsedInactivity1;
}

- (bool) longInactivity {
	return 
	gameStatus == cStatusGameIsOn && 
	viewMode == 1 && 
	CFAbsoluteTimeGetCurrent() - inactivity2 > cElapsedInactivity2;
}

- (tResultEvaluateNextLevel) evaluateGetIntoNextLevel {
	// The limit of the game. There are no more levels over cLimitLevel
    //NSLog(@"Level: %i, Limit: %i", [UserContext getLevelNumber], cLimitLevel);
	if ([UserContext getLevelNumber] >= cLimitLevel - 1) {
		//[self takeOutTrain];
		return tResultEvaluateNextLevel_none;
	}
	
	double wasLearnedResult = [Vocabulary wasLearned];
    double wasLearned5LastLevelsResult = [Vocabulary wasLearnedLast5Levels];
    //NSLog(@"wasLearnedResult: %f, wasLearned5LastLevelsResult: %f, cPercentageCloseToLearnd: %f, viewMode: %i", wasLearnedResult, wasLearned5LastLevelsResult, cPercentageCloseToLearnd, viewMode);
    
	if (wasLearnedResult >= cPercentageLearnd &&
        wasLearned5LastLevelsResult >= cPercentageLearnd && [self hitRate] >= 5) {
		return [self goToNextLevel];
	} else if (wasLearnedResult >= cPercentageCloseToLearnd && [self hitRate] >= 5) {
		if (viewMode == 1) {
            returnMapButton.enabled = 0;
            playAgainButton.enabled = 0;
            purchaseButton.enabled = 0;
            [Sentence playSpeaker: @"Test-EvaluateGetIntoNextLevel-CloseToLearned" delegate: self selector:@selector(endSayCloseToLearnd)];
        }
		return tResultEvaluateNextLevel_closeToNextLevel;
	}
    
    return tResultEvaluateNextLevel_none;
	//[self takeOutTrain];
}

-(void) endSayCloseToLearnd {
    returnMapButton.enabled = 1;
    playAgainButton.enabled = 1;
    purchaseButton.enabled = 1;
}

-(tResultEvaluateNextLevel) goToNextLevel {
	gameStatus = cStatusGameIsGoingToNextLevel;
    //NSLog(@"LevelNumber: %i, level: %i", [UserContext getLevelNumber], [UserContext getMaxLevel]);
	if (([UserContext getLevelNumber]+1) >= [UserContext getTemporalMaxLevel]) {
		//[self askToBuyNewLevels];
        return tResultEvaluateNextLevel_BuyRequired;
	} else {
		if ([UserContext nextLevel]) {
			//[Sentence playSpeaker: @"Test-EvaluateGetIntoNextLevel-NextLevel"];
            return tResultEvaluateNextLevel_NextLevel;
		}
	}
    return tResultEvaluateNextLevel_none;
}

- (IBAction) askToBuyNewLevels {
	
	VocabularyTrip2AppDelegate *vcDelegate;
	vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	
	/*UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: @"Buy New Level" 
						  message: @"To advance to the next level, you need to buy more words"
						  delegate: vcDelegate 
						  cancelButtonTitle: @"OK"
						  otherButtonTitles: nil];	
	[alert show];*/
	//[self takeOutTrain];
    
    [vcDelegate pushPurchaseView];

}


// Hide the Word Clicked and then replace with the new one
- (Word*) changeImageOn: (UIButton *) aWordButton wordButtonLabel: (UIButton *) aWordButtonLabel id: (int) idButton {
	aWordButton.userInteractionEnabled = NO;
	Word* word = [super changeImageOn: aWordButton wordButtonLabel: aWordButtonLabel id: idButton];
	if (qOfImagesRemaining > 0) {
		[self selectNextTarget]; // Random chose new target	
	}
	return word;
}

- (void) takeOutTrain { 
	[super takeOutTrain];
}

- (IBAction)wordButton1Clicked { 
	[self wordButton: wordButton1 buttonLabel: wordButtonLabel1 clicked: 0];
}

- (IBAction)wordButton2Clicked { 
	[self wordButton: wordButton2 buttonLabel: wordButtonLabel2 clicked: 1];
}

- (IBAction)wordButton3Clicked { 
	[self wordButton: wordButton3 buttonLabel: wordButtonLabel3 clicked: 2];
}

- (void) wordButton: (UIButton*) aButton buttonLabel: (UIButton*) aButtonLabel clicked: (int) i {
	// We should say something if the button is clicked and paused.
	//if (gameStatus == cStatusGameIsPaused) 
		// Say something...
	
	if (gameStatus != cStatusGameIsOn) return;

	inactivity2 = CFAbsoluteTimeGetCurrent();	
	Word* w = [words objectAtIndex: targetId];
	
	@try {
		if (targetId == i) {
			if (flagFaild == NO) {
				[w decWeight];
               	int avatarAnim = arc4random() % 2;
                NSLog(@"Anim %i", avatarAnim);
                if (avatarAnim == 1)
                    [AnimatorHelper avatarDance: driverView];
                else
                    [AnimatorHelper avatarOk: driverView];
				// Increment the hit of Level
				[self incrementHitAtLevel: w.theme];
			}
			[self changeImageOn: aButton wordButtonLabel: aButtonLabel id: i];
		} else {
			flagFaild = YES;
            Word* w2 = [words objectAtIndex: i];
            [w2 incWeight];
			[w incWeight];
            [errorSoundId play];
            [AnimatorHelper avatarFrustrated: driverView];
		}
	} @catch (NSException * e) {
		NSLog(@"Exception in wordButton:clicked");
		NSLog(@".. in word %@", w.name);
	}
	@finally {
	}
	
}

-(void) initMusicPlayer {

	[super initMusicPlayer];

	// Error Sound
	//NSURL* soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ErrorSound" ofType:@"wav"]];
	//AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundUrl, &errorSoundId);
    errorSoundId = [Sentence getAudioPlayer: @"ErrorSound"];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in TestTrain");
    // Release any cached data, images, etc. that aren't in use.
}

// *****************************
// ***** Help Animation

- (IBAction) helpClicked {
	[self helpAnimation1];
}

- (void) helpAnimation1 {
    // Make clicking hand visible
	//[self pauseClicked];
	gameStatus = cStatusHelpOn;
    
	helpButton.enabled = NO;
    backButton.enabled = NO;
	[Sentence playSpeaker: @"Test-IntroduceTrain" delegate: self selector: @selector(changeStatusOnEndHelp)];

	
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)(hand) ];
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)]; 
    [UIImageView setAnimationDuration: .5];
    hand.alpha = 1;
    [UIImageView commitAnimations];    
}

- (void) helpAnimation2 {
    // say word and bring clicking hand onto the corresponding wagon
	int halfSizeWagon = wordButton1.frame.size.width / 2;
    //[self sayTargetWord];
	
    CGRect handFrame = hand.frame;
    
    handFrame.origin.y = wordButton1.frame.origin.y + halfSizeWagon;
	int wagonCenter;
    switch (targetId) {
        case 0: {
            wagonCenter = wordButton1.frame.origin.x + halfSizeWagon; 
            break;
        } case 1: {
            wagonCenter = wordButton2.frame.origin.x + halfSizeWagon; 
            break;
        } case 2: {
            wagonCenter = wordButton3.frame.origin.x + halfSizeWagon; 
            break;
        }
        default:
            break;
    }
    handFrame.origin.x = wagonCenter;
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)(hand)]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2b:finished:context:)]; 
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    hand.frame = handFrame;
    [UIImageView commitAnimations];
}

- (void) helpAnimation2b:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    // click down
	CGRect frame = hand.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: context]; 
	[UIImageView setAnimationDelegate: self]; 
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2c:finished:context:)]; 
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
    
	[UIImageView commitAnimations];
}

- (void) helpAnimation2c:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	// Release click
	CGRect frame = hand.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: Nil]; 
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)]; 
    
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
    
	[UIImageView commitAnimations];
}



- (void) helpAnimation3 {
    // change image on the wagon just clicked onto
    switch (targetId) {
        case 0: {
            [self changeImageOn: wordButton1 wordButtonLabel: wordButtonLabel1 id: 0];
            break;
        } case 1: {
            [self changeImageOn: wordButton2 wordButtonLabel: wordButtonLabel2 id: 1];
            break;
        } case 2: {
            [self changeImageOn: wordButton3 wordButtonLabel: wordButtonLabel3 id: 2];
            break;
        }
        default:
            break;
    }
	
    [self helpAnimation4];
}


-(void) helpAnimation4 {
    // make hand dissapear
    [UIView beginAnimations: @"helpAnimation" context: nil]; 
    [UIView setAnimationDelegate: self]; 
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation5)]; 
    [UIView setAnimationDuration: 2];
    [UIView setAnimationBeginsFromCurrentState: YES];
    hand.alpha = 0;
    [UIView commitAnimations];
}

- (void) helpAnimation5 {
    // bring hand to original position
    //[self finishHelp];
    CGRect frame = hand.frame;
    frame.origin.x = 100;
    frame.origin.y = 50;
    hand.frame = frame;
	[UserContext setHelpTest: NO];
	helpButton.enabled = YES;
    backButton.enabled = YES;
	[self pauseClicked];
  	gameStatus = cStatusHelpOn; // pauseClicked put gameStatus in on. Enable to say the target Wotd. At this moment the help sentence didn-t finish. Wait to sentence to finish to change the status. See the following method. Otherwise the word target is superimposed with the end of the help sentence.
}

- (void) changeStatusOnEndHelp {
  	gameStatus = cStatusGameIsOn;
}

// ***** Help Animation
// *****************************

- (void)dealloc {
	//AudioServicesDisposeSystemSoundID(errorSoundId);
}

@end


