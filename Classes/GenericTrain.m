//
//  GenericTrain.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 6/26/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "GenericTrain.h"
#import "LandscapeManager.h"
#import "Vocabulary.h"
#import "UserContext.h"
#import "Sentence.h"
#import "TestTrain.h"
#import "VocabularyTrip2AppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>	
#import <QuartzCore/CADisplayLink.h>
#import <AVFoundation/AVFoundation.h>

@protocol GenericTrainDelegate;

@implementation GenericTrain

@synthesize pauseButton;
@synthesize helpButton;
@synthesize train;
@synthesize wagon1;
@synthesize wagon2;
@synthesize wagon3;
@synthesize wordButton1;
@synthesize wordButton2;
@synthesize wordButton3;
@synthesize driverView;
@synthesize langView;
@synthesize landscape_1;
@synthesize landscape_2;
@synthesize landscape_3;
@synthesize wheel1;
@synthesize wheel2;
@synthesize wheel3;
@synthesize wheel4;
@synthesize wheel5;
@synthesize wheel6;
@synthesize wheel7;
@synthesize wheel8;
@synthesize wheel9;
//@synthesize loadingView;
@synthesize railView;
@synthesize smokeView;
@synthesize closeSoundId;
@synthesize viewMode;
@synthesize trainSound;
@synthesize backButton;
@synthesize soundButton;
@synthesize money1View;
@synthesize money1Label;	
@synthesize money2View;
@synthesize money2Label;	
@synthesize money3View;
@synthesize money3Label;	
@synthesize hand;
@synthesize wordButtonLabel1;
@synthesize wordButtonLabel2;
@synthesize wordButtonLabel3;
@synthesize playAgainButton;
@synthesize returnMapButton;
@synthesize purchaseButton;

// ********************
// **** IBActions *****

// Return to Main Menu
- (IBAction)done:(id)sender {
	
	[self cancelAllAnimations];
	
	viewMode = 0;
	if ([theTimer isKindOfClass: [CADisplayLink class]]) {
		[theTimer invalidate];
		theTimer = nil;
	}
	
	[smokeView endAnimation];
}

- (void) cancelAllAnimations {
	// Cancel actual animation
	[UIView beginAnimations: nil context: NULL]; 
	[UIView setAnimationBeginsFromCurrentState: YES]; 
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView commitAnimations];
	
	[self.view.layer removeAllAnimations];
}

- (IBAction)wordButton1Clicked { 
	//Implemented in TestTrain subclass
	//TrainingTrain doesn´t has behaviour
}

- (IBAction)wordButton2Clicked { 
	//Implemented in TestTrain subclass
	//TrainingTrain doesn´t has behaviour
}

- (IBAction)wordButton3Clicked { 
	//Implemented in TestTrain subclass
	//TrainingTrain doesn´t has behaviour
}

- (IBAction) helpClicked {
	// Implemented by subclass
}


- (IBAction)pauseClicked { 
	NSString *imageFile;
	if (gameStatus == cStatusGameIsOn) { 
		imageFile = [ImageManager getIphoneIpadFile: @"pause1"];
		[pauseButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsPaused;
		[self.trainSound pause];
		wordButton1.enabled = NO;
		wordButton2.enabled = NO;
		wordButton3.enabled = NO;		
		helpButton.enabled = NO;
        wordButtonLabel1.enabled = NO;
        wordButtonLabel2.enabled = NO;
        wordButtonLabel3.enabled = NO;
        
        [self throbPauseButton];
	} else	{
		imageFile = [ImageManager getIphoneIpadFile: @"pause2"];
		[pauseButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsOn;
		wordButton1.enabled = YES;
		wordButton2.enabled = YES;
		wordButton3.enabled = YES;	
		helpButton.enabled = YES;
        wordButtonLabel1.enabled = YES;
        wordButtonLabel2.enabled = YES;
        wordButtonLabel3.enabled = YES;
	}
}

- (void) refreshGameMode {
    
    ([GameSequenceManager getCurrentGameSequence].cumulative) ?
        [UserContext setLevelGameMode: tLevelModeGame_cumulative] :
        [UserContext setLevelGameMode: tLevelModeGame_currentLevel];

    if ([GameSequenceManager getCurrentGameSequence].includeImages) {
        wordButton1.alpha = 1;
        wordButton2.alpha = 1;
        wordButton3.alpha = 1;
    } else {
        wordButton1.alpha = 0;
        wordButton2.alpha = 0;
        wordButton3.alpha = 0;
    }
    
    if ([GameSequenceManager getCurrentGameSequence].includeWords) {
        wordButtonLabel1.alpha = 1;
        wordButtonLabel2.alpha = 1;
        wordButtonLabel3.alpha = 1;
    } else {
        wordButtonLabel1.alpha = 0;
        wordButtonLabel2.alpha = 0;
        wordButtonLabel3.alpha = 0;
    }
    
    
    // Depending if words are visible or not, the images has to be moved down to replace the word labels places
    int deltaY = [GameSequenceManager getCurrentGameSequence].includeWords &&
    [GameSequenceManager getCurrentGameSequence].includeImages ? wordButtonLabel1.frame.size.height : 0;

    CGRect frame = wordButton1.frame;
    originalframeWord1ButtonView.origin.y =
    wagon1.frame.origin.y - deltaY - originalframeWord1ButtonView.size.height;
    frame.origin.y = originalframeWord1ButtonView.origin.y;
	wordButton1.frame = frame;
    
    frame = wordButton2.frame;
	originalframeWord2ButtonView.origin.y =
        wagon2.frame.origin.y - deltaY - originalframeWord2ButtonView.size.height;
    frame.origin.y = originalframeWord2ButtonView.origin.y;
	wordButton2.frame = frame;

    frame = wordButton3.frame;
	originalframeWord3ButtonView.origin.y =
        wagon3.frame.origin.y - deltaY - originalframeWord3ButtonView.size.height;
    frame.origin.y = originalframeWord3ButtonView.origin.y;
	wordButton3.frame = frame;
	

}

- (void) throbPauseButton {
    if (gameStatus != cStatusGameIsPaused) {
        pauseButton.alpha = 1;
        return;
    }
    
	[UIView beginAnimations:@"HideWordAnimation" context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDidStopSelector: @selector(throbPauseButtonOff)];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	pauseButton.alpha = 0.5;
	[UIView commitAnimations];
}

- (void) throbPauseButtonOff {
    if (gameStatus != cStatusGameIsPaused) {
        pauseButton.alpha = 1;
        return;
    }
    
	[UIView beginAnimations:@"HideWordAnimation" context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDidStopSelector: @selector(throbPauseButton)];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	pauseButton.alpha = 1;
	[UIView commitAnimations];
}

- (IBAction)soundClicked { 
	if (UserContext.soundEnabled == YES) { 
		UserContext.soundEnabled = NO;
		[self.trainSound pause];
	} else	{
		UserContext.soundEnabled = YES;
	}
	[self refreshSoundButton];
}

// **** IBActions *****
// ********************

-(void) sentenceDidFinish: (NSString*) method {
}

// ************************
// **** Core Business *****

- (void) incrementHitAtLevel: (int) aLevel {
    int range;
	if (aLevel <= cLimitLevelBronze) range = 1;
	if (aLevel > cLimitLevelBronze && aLevel <= cLimitLevelSilver) range = 2;
	if (aLevel > cLimitLevelSilver) range = 3;
	
  	int hit = arc4random() % range;
	if (hit == 0) hitsOfLevel1++;
	if (hit == 1) hitsOfLevel2++;
	if (hit == 2) hitsOfLevel3++;
    
	/*if (aLevel <= cLimitLevelBronze) hitsOfLevel1++;
	if (aLevel > cLimitLevelBronze && aLevel <= cLimitLevelSilver) hitsOfLevel2++;
	if (aLevel > cLimitLevelSilver) hitsOfLevel3++;*/
    
}

// Hide the Word Clicked.
- (Word*) changeImageOn: (UIButton *) aWordButton wordButtonLabel: (UIButton *) aWordButtonLabel id: (int) idButton {

	//AudioServicesPlaySystemSound(self.closeSoundId);
    [closeSoundId play];
    
	Word *word = [self getNextWord];
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

	[parameters setObject: aWordButton forKey: @"button"];
	[parameters setObject: aWordButtonLabel forKey: @"buttonLabel"];
	[parameters setObject: [NSNumber numberWithInt: idButton] forKey: @"id"];
	if (word) [parameters setObject: word forKey: @"word"];	

	// Hide Image
	[UIView beginAnimations:@"HideWordAnimation" context: CFBridgingRetain(parameters)]; 
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationDidStopSelector: @selector(hideWordAnimationDidStop:finished:context:)]; 	
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];

    
    if ([GameSequenceManager getCurrentGameSequence].includeWords) aWordButtonLabel.alpha = 0;
    if ([GameSequenceManager getCurrentGameSequence].includeImages) aWordButton.alpha = 0;

	[UIView commitAnimations];

	return word;
}

- (Word*) getNextWord {
	return [Vocabulary getRandomWeightedWord];
}

// Show new Word
- (void)hideWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context; // *** ARC
	
	UIButton *aWordButton = (UIButton*) [parameters objectForKey: @"button"];
	UIButton *aWordButtonLabel = (UIButton*) [parameters objectForKey: @"buttonLabel"];
	NSNumber *n = (NSNumber*) [parameters objectForKey: @"id"];
	int idButton = [n intValue];
	Word* word = (Word*) [parameters objectForKey: @"word"];
	
	if (word != nil && idButton >= 0 && idButton < 3) {
		@try {
            [self showThisWord: word id: idButton button: aWordButton buttonLabel: aWordButtonLabel context: context];
		} @catch (NSException * e) {
			NSLog(@"Error on changeImageOn %@", word.name);
		}
		@finally {
		}
		
	} else {
		NSLog(@"End game abnormally. getRandomWeightedWord return nil");
		[self endGame];
	}
	
}

- (void) showThisWord: (Word*) aWord id: (int) idButton button: (UIButton*) aWordButton buttonLabel: (UIButton*) aWordButtonLabel context:(void *)context {
    
	NSMutableDictionary *parameters = (__bridge  NSMutableDictionary*) context; // *** ARC
    //[aWordButton setImage: aWord.image forState: UIControlStateNormal];
    
	if (idButton==0) aWordButton.frame = originalframeWord1ButtonView;
	if (idButton==1) aWordButton.frame = originalframeWord2ButtonView;
	if (idButton==2) aWordButton.frame = originalframeWord3ButtonView;

    [ImageManager fitImage: aWord.image inButton: aWordButton];
    [aWordButtonLabel setTitle: aWord.translatedName forState: UIControlStateNormal];
    
    [words replaceObjectAtIndex: idButton withObject: aWord];
    
    // Show new Image
    [UIView beginAnimations:@"ShowWordAnimation" context: ( void *)(parameters)];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(showWordAnimationDidStop:finished:context:)]; 
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];

    if ([GameSequenceManager getCurrentGameSequence].includeWords) aWordButtonLabel.alpha = 1;
    if ([GameSequenceManager getCurrentGameSequence].includeImages) aWordButton.alpha = 1;
    
    [UIView commitAnimations];
    qOfImagesRemaining--;
    if (qOfImagesRemaining <= 0) {
        [self endGame];
    }
}

- (void)showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	//NSMutableDictionary *parameters = (__bridge  NSMutableDictionary*) context;
	//UIButton *aWordButton = (UIButton*) [parameters objectForKey: @"button"];
    //NSLog(@"Origin.x: %f, size.width: %f", aWordButton.frame.origin.x, aWordButton.frame.size.width);
}

// When the train animation stop, the Game Start...
- (void) startGame { 
	[self.trainSound stop];
	pauseButton.alpha = 1;
	helpButton.alpha = 1;
    backButton.alpha = 1;
	gameStatus = cStatusGameIsOn;
	[smokeView startAnimation];
}

- (void) endGame {
    // [GameSequenceManager nextSequence];
}

- (void) prepareIntroduceTrain {
    gameStatus = cStatusGameIsIntroducingTrain;
	pauseButton.alpha = 0;
	helpButton.alpha = 0;
	qOfImagesRemaining = [self hitsPerGame];
    
	hitsOfLevel1 = 0; // hits corresponding of cooper coins
	hitsOfLevel2 = 0; // hits corresponding to silver coins
	hitsOfLevel3 = 0; // hits corresponding to gold coins
	//money = 0;  // Is used to refresh the moneyLabel one by one. Is used just in the method refreshMoneyLabels
	[self shiftTrain: [ImageManager windowWidth]];
}

// Train animation
- (void)introduceTrain { 

	if (UserContext.soundEnabled) {
		[self.trainSound play]; 
	}
	
	[UIView beginAnimations:@"TrainAnimation" context: (__bridge void *)(train)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(trainAnimationDidStop:finished:context:)]; 
	[UIView setAnimationDuration: 3.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	[self shiftTrain: -1 * [ImageManager windowWidth] + [ImageManager getDeltaWidthIphone5]];
	
	[UIView commitAnimations];
}

- (void)trainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	[self startGame];
}

- (void) viewWillAppear:(BOOL)animated { 
	viewMode = 1;
    
    returnMapButton.alpha = 0;
    playAgainButton.alpha = 0;
    purchaseButton.alpha = 0;
    
    [self refreshGameMode];
    
	if (gameStatus != cStatusGameIsOn && gameStatus != cStatusGameIsPaused) {	
		//[self hideAllViews];
        [self initializeLevel];
		[words removeAllObjects];
		[self initWagons];	

        User *user = [UserContext getUserSelected];
        [driverView setImage: user.image];
        
        Language *lang = [UserContext getLanguageSelected];
        [langView setImage: lang.image];
        
		if (gameStatus == cStatusGameIsFinished) { 
			[self shiftTrain: [ImageManager windowWidth]];
		}
        [self prepareIntroduceTrain];
	}
    
	[self moveLandscape];
	money1Label.text = [UserContext getMoney1AsText];
	money2Label.text = [UserContext getMoney2AsText];
	money3Label.text = [UserContext getMoney3AsText];	

	// Initialize the first position of each wheel (random)
	[wheel1 initialize];
	[wheel2 initialize];
	[wheel3 initialize];
	[wheel4 initialize];
	[wheel5 initialize];
	[wheel6 initialize];
	[wheel7 initialize];
	[wheel8 initialize];
    [wheel9 initialize];
}

- (void) initializeLevel {
    if ([UserContext levelGameMode] == tLevelModeGame_currentLevel)
        [Vocabulary initializeLevelAt: [Vocabulary getLevelLessLearned]];
    // [UserContext getLevelNumber]];
    else
        [Vocabulary initializeLevelUntil: [UserContext getLevelNumber]];
        // default mode is tLevelModeGame_cumulative
}

- (void) viewDidAppear:(BOOL)animated {
	if (gameStatus != cStatusGameIsOn && gameStatus != cStatusGameIsPaused) {
		[self introduceTrain];
	}
	[self refreshSoundButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!words) words = [[NSMutableArray alloc] init];		
	[self initializeTimer];
	[self initMusicPlayer];
    
    wordButtonLabel1.titleLabel.minimumFontSize = 8;
    wordButtonLabel1.titleLabel.adjustsFontSizeToFitWidth = true;
    wordButtonLabel2.titleLabel.minimumFontSize = 8;
    wordButtonLabel2.titleLabel.adjustsFontSizeToFitWidth = true;
    wordButtonLabel3.titleLabel.minimumFontSize = 8;
    wordButtonLabel3.titleLabel.adjustsFontSizeToFitWidth = true;
    
    originalframeWord1ButtonView = CGRectMake(wordButton1.frame.origin.x, wordButton1.frame.origin.y, wordButton1.frame.size.width, wordButton1.frame.size.height);
    originalframeWord2ButtonView = CGRectMake(wordButton2.frame.origin.x, wordButton2.frame.origin.y, wordButton2.frame.size.width, wordButton2.frame.size.height);
    originalframeWord3ButtonView = CGRectMake(wordButton3.frame.origin.x, wordButton3.frame.origin.y, wordButton3.frame.size.width, wordButton3.frame.size.height);
    
    
    CGRect frame = returnMapButton.frame;
    frame.origin.x = frame.origin.x + [ImageManager getDeltaWidthIphone5];
    returnMapButton.frame = frame;
    
    frame = playAgainButton.frame;
    frame.origin.x = frame.origin.x + [ImageManager getDeltaWidthIphone5];
    playAgainButton.frame = frame;
    
    frame = purchaseButton.frame;
    frame.origin.x = frame.origin.x + [ImageManager getDeltaWidthIphone5];
    purchaseButton.frame = frame;
    
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        gameStartView = [[GameStartView alloc] initWithNibName: @"GameStartView~ipad" bundle:[NSBundle mainBundle]];
    } else {
        gameStartView = [[GameStartView alloc] initWithNibName: @"GameStartView" bundle:[NSBundle mainBundle]];
    }
    [self.view addSubview: gameStartView.view];
    gameStartView.view.alpha = 0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        gameEndView = [[GameEndView alloc] initWithNibName: @"GameEndView~ipad" bundle:[NSBundle mainBundle]];
    } else {
        gameEndView = [[GameEndView alloc] initWithNibName: @"GameEndView" bundle:[NSBundle mainBundle]];
    }
    [self.view addSubview: gameEndView.view];
    gameEndView.view.alpha = 0;*/

}

- (void) takeOutTrain {
	[smokeView endAnimation];
	
	gameStatus = cStatusGameIsTakeoutTrain;
	pauseButton.alpha = 0;
	helpButton.alpha = 0;
	backButton.alpha = 0;
    
	if (UserContext.soundEnabled) {
		[self.trainSound play]; 
	}
	
	[UIView beginAnimations: @"TakeOutTrainAnimation" context: ( void *)(train)];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(takeoutTrainAnimationDidStop:finished:context:)]; 
	[UIView setAnimationDuration: 5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[self shiftTrain: -1 * [ImageManager windowWidth]];
	
	[UIView commitAnimations];
}

- (void)takeoutTrainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	[self.trainSound pause];	// 
	gameStatus = cStatusGameIsFinished;
    
    //gameEndView.parentView = self;
    //[gameEndView show];
    
	// [self done: nil];			// Return to main menu
    [self showButtonsPlayAgainAndReturnToMap];
}

- (tResultEvaluateNextLevel) evaluateGetIntoNextLevel {
    // This method is implemented by TestTrain. Others not measure learning and never improve the ranking
    return  tResultEvaluateNextLevel_none;
}

- (void) showButtonsPlayAgainAndReturnToMap {
    NSUInteger result = [self evaluateGetIntoNextLevel];
    // If the result is nextLevel or buyRequired, the play again is ignored. The user is forwarded to map or purchase view.
    if (result == tResultEvaluateNextLevel_NextLevel) {
        [self done: nil];
    } else {
        returnMapButton.alpha = 1;
        playAgainButton.alpha = 1;
        if (result == tResultEvaluateNextLevel_BuyRequired)
            purchaseButton.alpha = 1;
    }
}

- (IBAction) playAgainButtonClicked:(id)sender {
    [self done: nil];
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate.mapView playCurrentLevel: nil];
}

- (IBAction) purchaseButtonClicked:(id)sender {
    [self done: nil];
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate pushPurchaseView];
}

- (int) hitRate {
	return (hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) * 10 / [self hitsPerGame];
}

- (int) hitsPerGame {
	return cHitsPerGame;
}

/*- (void) refreshMoneyViews: (NSString*) moneyType {
	gameStatus = cStatusGameIsMoneyCount;
	
	[self alphaByType: moneyType];
	
	[UIView beginAnimations:@"GoldAnimation" context:(__bridge void *)(train)];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(goldAnimationDidStop:finished:context:)]; 
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatAutoreverses: NO];
	
	[self showMoneyViews];
	
	[UIView commitAnimations];
}

- (void)goldAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	[self refreshMoneyLabels];	
}*/

- (void) refreshMoneyLabels {
    money1Label.method = UILabelCountingMethodLinear;
    money1Label.format = @"%d";
    [money1Label countFrom: [UserContext getMoney1]
                        to: [UserContext getMoney1] + hitsOfLevel1 * cBronzeHitPrice
                        withDuration: 3.0];
    [UserContext addMoney1: hitsOfLevel1 * cBronzeHitPrice];
    
    money2Label.method = UILabelCountingMethodLinear;
    money2Label.format = @"%d";
    [money2Label countFrom: [UserContext getMoney2]
                        to: [UserContext getMoney2] + hitsOfLevel2 * cSilverHitPrice
              withDuration: 3.0];
    [UserContext addMoney2: hitsOfLevel2 * cBronzeHitPrice];
    
    money3Label.method = UILabelCountingMethodLinear;
    money3Label.format = @"%d";
    [money3Label countFrom: [UserContext getMoney3]
                        to: [UserContext getMoney3] + hitsOfLevel3 * cGoldHitPrice
              withDuration: 3.0];
    [UserContext addMoney3: hitsOfLevel3 * cBronzeHitPrice];
    
    [self takeOutTrain];
}

/*- (void) refreshMoneyLabels {
	money++;
	
	if (money > hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) {
		[self refreshMoneyLabelsFinished];
		return;
	}	
	
	//AudioServicesPlaySystemSound(self.closeSoundId);
	[closeSoundId play];
    
	[self addMoney];
	
	money1Label.text = [UserContext getMoney1AsText];
	money2Label.text = [UserContext getMoney2AsText];
	money3Label.text = [UserContext getMoney3AsText];	
}*/

// Implemented by subclass
/*- (void) refreshMoneyLabelsFinished {
}


// Implemented by subclass
- (void) addMoney { 
}*/

// **** Core Business *****
// ************************

-(void) setToolbarAlpha: (int) aValue {
	backButton.alpha = aValue;
	money1View.alpha = aValue;
	money1Label.alpha = aValue;	
	money2View.alpha = aValue;
	money2Label.alpha = aValue;	
	money3View.alpha = aValue;
	money3Label.alpha = aValue;	
	soundButton.alpha = aValue;
}

- (void) refreshSoundButton {
	NSString *soundImageFile;
	soundImageFile = UserContext.soundEnabled == YES ? @"sound-on" : @"sound-of";
    soundImageFile = [ImageManager getIphoneIpadFile: soundImageFile];
	[soundButton setImage: [UIImage imageNamed: soundImageFile] forState: UIControlStateNormal];	
	[self.view.layer removeAllAnimations];
}

-(void) alphaByType: (NSString*) moneyType {
	money1View.alpha = [moneyType isEqualToString: cBronzeType] ? 0 : 1;
	money2View.alpha = [moneyType isEqualToString: cSilverType] ? 0 : 1;
	money3View.alpha = [moneyType isEqualToString: cGoldType] ? 0 : 1;
}

-(void) showMoneyViews {
	money1View.alpha = 1;			
	money2View.alpha = 1;
	money3View.alpha = 1;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView: touch.view];

	[ToolbarController saySentence: touchLocation
		frame1View: money1View.frame
		frame1Label: money1Label.frame
		frame2View: money2View.frame
		frame2Label: money2Label.frame
		frame3View: money3View.frame
 	    frame3Label: money3Label.frame];

}

-(void) pushLevelWithHelpDownload {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    vocTripDelegate.mapView.startWithHelpDownload = 1;
    [vocTripDelegate pushMapViewWithHelpDownload];
}

/*-(void) showAlertDownloadSounds {
    
    [Sentence playSpeaker: @"AlertDownloadSounds"];
    //alertDownloadSounds.alpha = 0.0;
	[UIImageView beginAnimations: @"helpAnimation" context: Nil]; 
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: 2];
    //[UIImageView setAnimationRepeatAutoreverses: YES];
    [UIImageView setAnimationCurve: UIViewAnimationCurveEaseOut];    
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(alertDownloadSoundsFinished)]; 
    
    alertDownloadSounds.alpha = 0.8;                
	[UIImageView commitAnimations];
}

- (void) alertDownloadSoundsFinished {
   alertDownloadSounds.alpha = 0.0;
}*/

/*- (IBAction) jumpDownloadDictionary {
    [self done: nil];
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate pushUserLangResumView];
}*/

- (int) getLandscapeOffset {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)	
		return cLandscapeOffsetIpad;
	else
		return cLandscapeOffset;
}

- (void) moveLandscape { 
	
	Landscape *l = [LandscapeManager switchLandscape];
    landscape_1.image = l.layer1;
    landscape_2.image = l.layer2;
    landscape_3.image = l.layer3;
    
    int duration = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60 : 30;
	CGRect frame = landscape_1.frame;
	frame.origin.x = [self getLandscapeOffset] + [ImageManager windowWidth];
	landscape_1.frame = frame;
	[UIView beginAnimations: @"LandscapeAnimation1" context: (__bridge void *)(landscape_1)];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(landscapeAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration: duration];
	[UIView setAnimationRepeatCount: 40];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    frame.origin.x = 0;
	landscape_1.frame = frame;
	[UIView commitAnimations];

    duration = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 360 : 180;
    frame = landscape_2.frame;
    frame.origin.x = [self getLandscapeOffset] + [ImageManager windowWidth];
	landscape_2.frame = frame;
	[UIView beginAnimations: @"LandscapeAnimation2" context: (__bridge void *)(landscape_2)];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(landscapeAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration: duration];
	[UIView setAnimationRepeatCount: 20];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    frame.origin.x = 0;
	landscape_2.frame = frame;
	[UIView commitAnimations];

    /*duration = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 500 : 250;
    frame = landscape_3.frame;
    frame.origin.x = [self getLandscapeOffset] + [ImageManager windowWidth];
	landscape_3.frame = frame;
	[UIView beginAnimations: @"LandscapeAnimation3" context: (__bridge void *)(landscape_3)];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(landscapeAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration: duration];
	[UIView setAnimationRepeatCount: 1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    frame.origin.x = 0;
	landscape_3.frame = frame;
	[UIView commitAnimations];*/

    
	/*Landscape *l = [LandscapeManager switchLandscape];
	landscape.image = l.image;
	landscapeSky.image = l.sky;
	
	CGRect frame = landscape.frame;
	frame.origin.x = [self getLandscapeOffset] + [ImageManager windowWidth];
	landscape.frame = frame;
	
	[UIView beginAnimations: @"LandscapeAnimation" context: (__bridge void *)(landscape)];
	[UIView setAnimationDelegate: self]; 
	[UIView setAnimationDidStopSelector: @selector(landscapeAnimationDidStop:finished:context:)]; 
	[UIView setAnimationDuration: 50];
	[UIView setAnimationRepeatCount: 20];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	frame = landscape.frame;
	frame.origin.x = frame.origin.x - [self getLandscapeOffset] - [ImageManager windowWidth];
	landscape.frame = frame;
	
	[UIView commitAnimations];*/
}

- (void)landscapeAnimationDidStop: (NSString *)theAnimation finished: (BOOL)flag context: (void *)context {
	//[self endGame]; 
}

- (void) trainLoop {
	[self moveWagon];
}

- (void) moveWagon {
	[wheel1 wheelLoop];
	[wheel2 wheelLoop];
	[wheel3 wheelLoop];
	[wheel4 wheelLoop];
	[wheel5 wheelLoop];
	[wheel6 wheelLoop];
	[wheel7 wheelLoop];
	[wheel8 wheelLoop];
	[wheel9 wheelLoop];
    
	int maxDeltaY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4 : 2;
	int trainY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 410 : 152;
	int wheelY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 680 : 285;
	int wagonY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 609 : 256;
    int driverY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 520 : 202;
    int flagY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 415 : 152;
    
    // train
    CGRect frame = self.train.frame;
    int deltaY = arc4random() % maxDeltaY;
    frame.origin.y = trainY + deltaY;
    self.train.frame = frame;    

    // Driver
    frame = self.driverView.frame;
    frame.origin.y = driverY + deltaY;
    self.driverView.frame = frame;

    // Flag
    frame = self.langView.frame;
    frame.origin.y = flagY + deltaY;
    self.langView.frame = frame;
    
    // Train's wheels
    frame = self.wheel2.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel2.frame = frame;    

    frame = self.wheel5.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel5.frame = frame;
	
    // wagon1
    frame = self.wagon1.frame;
    deltaY = arc4random() % maxDeltaY;
    frame.origin.y = wagonY + deltaY;
    self.wagon1.frame = frame;
    // Wagon1, 1st wheel
    frame = self.wheel3.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel3.frame = frame;       
    // Wagon1, 2nd wheel
    frame = self.wheel4.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel4.frame = frame;    
    // Wagon1, 3nd wheel
    frame = self.wheel9.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel9.frame = frame;
    
    // wagon2
    frame = self.wagon2.frame;
    deltaY = arc4random() % maxDeltaY;
    frame.origin.y = wagonY + deltaY;
    self.wagon2.frame = frame;
    // Wagon1, 2nd wheel
    frame = self.wheel1.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel1.frame = frame;    
    frame = self.wheel6.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel6.frame = frame;    
	
    // wagon3
    frame = self.wagon3.frame;
    deltaY = arc4random() % maxDeltaY;
    frame.origin.y = wagonY + deltaY;
    self.wagon3.frame = frame;
    // Wagon1, 2nd wheel
    frame = self.wheel7.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel7.frame = frame;    
    // Wagon1, 2nd wheel
    frame = self.wheel8.frame;
    frame.origin.y = wheelY + deltaY;
    self.wheel8.frame = frame;
    
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(trainLoop)];
		theTimer.frameInterval = 5;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) initWagons {
	
	Word *word = [Vocabulary getRandomWeightedWord];
	[words addObject: word];
	//[wordButton1 setImage: word.image forState: UIControlStateNormal];
    [ImageManager fitImage: word.image inButton: wordButton1];
	[wordButtonLabel1 setTitle: word.translatedName forState: UIControlStateNormal];
    
	word = [Vocabulary getRandomWeightedWord];
	[words addObject: word];
	//[wordButton2 setImage: word.image forState: UIControlStateNormal];
    [ImageManager fitImage: word.image inButton: wordButton2];
	[wordButtonLabel2 setTitle: word.translatedName forState: UIControlStateNormal];
    
	word = [Vocabulary getRandomWeightedWord];
	[words addObject: word];
	//[wordButton3 setImage: word.image forState: UIControlStateNormal];
    [ImageManager fitImage: word.image inButton: wordButton3];
	[wordButtonLabel3 setTitle: word.translatedName forState: UIControlStateNormal];
	
}

/*-(void) hideAllViews {
    [self.view bringSubviewToFront:loadingView];
	loadingView.alpha = 1;	
}*/

-(void) initMusicPlayer {
	
	// Close Sound
	//NSURL* closeSoundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Finished" ofType:@"wav"]];
    //NSLog(@"%@", closeSoundUrl);
    
	//AudioServicesCreateSystemSoundID((__bridge CFURLRef) closeSoundUrl, &closeSoundId);
    closeSoundId = [Sentence getAudioPlayer: @"Finished"];
    
	self.trainSound = [Sentence getAudioPlayer: @"ToyTrain"];
	self.trainSound.delegate = self; 
}

- (void) shiftTrain: (int) xPix {

	CGRect frame = train.frame;
	frame.origin.x = frame.origin.x + xPix;
	train.frame = frame;

	frame = driverView.frame;
	frame.origin.x = frame.origin.x + xPix;
	driverView.frame = frame;

	frame = langView.frame;
	frame.origin.x = frame.origin.x + xPix;
	langView.frame = frame;
    
	frame = wagon1.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wagon1.frame = frame;	

	frame = wagon2.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wagon2.frame = frame;	

	frame = wagon3.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wagon3.frame = frame;	

	frame = wordButton1.frame;
	originalframeWord1ButtonView.origin.x = originalframeWord1ButtonView.origin.x + xPix;
    frame.origin.x = frame.origin.x + xPix;
	wordButton1.frame = frame;

	frame = wordButton2.frame;
	originalframeWord2ButtonView.origin.x = originalframeWord2ButtonView.origin.x + xPix;
    frame.origin.x = frame.origin.x + xPix;
	wordButton2.frame = frame;

	frame = wordButton3.frame;
	originalframeWord3ButtonView.origin.x = originalframeWord3ButtonView.origin.x + xPix;
    frame.origin.x = frame.origin.x + xPix;
	wordButton3.frame = frame;

    frame = wordButtonLabel1.frame;
	frame.origin.x = frame.origin.x + xPix;
	wordButtonLabel1.frame = frame;

    frame = wordButtonLabel2.frame;
	frame.origin.x = frame.origin.x + xPix;
	wordButtonLabel2.frame = frame;

    frame = wordButtonLabel3.frame;
	frame.origin.x = frame.origin.x + xPix;
	wordButtonLabel3.frame = frame;
    
	frame = wheel1.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel1.frame = frame;	

	frame = wheel2.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel2.frame = frame;	

	frame = wheel3.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel3.frame = frame;	

	frame = wheel4.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel4.frame = frame;	

	frame = wheel5.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel5.frame = frame;	

	frame = wheel6.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel6.frame = frame;	

	frame = wheel7.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel7.frame = frame;	

	frame = wheel8.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel8.frame = frame;	

    frame = wheel9.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wheel9.frame = frame;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in GenericTrain");
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[words removeAllObjects];
	trainSound.delegate = nil;
	
	//AudioServicesDisposeSystemSoundID(closeSoundId);
	
}

@end
