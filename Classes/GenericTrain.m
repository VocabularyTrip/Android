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
@synthesize gameModeButton;
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
@synthesize landscape;
@synthesize landscapeSky;
@synthesize wheel1;
@synthesize wheel2;
@synthesize wheel3;
@synthesize wheel4;
@synthesize wheel5;
@synthesize wheel6;
@synthesize wheel7;
@synthesize wheel8;
@synthesize wheel9;
@synthesize loadingView;
@synthesize railView;
@synthesize smokeView;

@synthesize closeSoundId;
@synthesize viewMode;
@synthesize trainSound;
//@synthesize alertDownloadSounds;

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
	//PracticeTrain doesn´t has behaviour
}

- (IBAction)wordButton2Clicked { 
	//Implemented in TestTrain subclass
	//PracticeTrain doesn´t has behaviour	
}

- (IBAction)wordButton3Clicked { 
	//Implemented in TestTrain subclass
	//PracticeTrain doesn´t has behaviour
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

- (IBAction) gameModeClicked {
	NSString *imageFile;
	if ([UserContext imageWordGameMode] == cImageModeGame) {
        [UserContext setImageWordGameMode: cWordModeGame];
		imageFile = [ImageManager getIphoneIpadFile: @"wheel1"];
		[gameModeButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
        [self setWordModeGame];
    } else if ([UserContext imageWordGameMode] == cWordModeGame) {
        [UserContext setImageWordGameMode: cImageAndWordModeGame];
		imageFile = [ImageManager getIphoneIpadFile: @"wheel2"];
		[gameModeButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
        [self setImageAndWordModeGame];
    } else {
        [UserContext setImageWordGameMode: cImageModeGame];
		imageFile = [ImageManager getIphoneIpadFile: @"wheel3"];
		[gameModeButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
        [self setImageModeGame];
    }
}

- (void) refreshGameMode {
	if ([UserContext imageWordGameMode] == cImageModeGame) {
        [self setImageModeGame];
    } else if ([UserContext imageWordGameMode] == cWordModeGame) {
        [self setWordModeGame];
    } else {
        [self setImageAndWordModeGame];
    }
}

- (void) setImageModeGame {
    wordButtonLabel1.alpha = 0;
    wordButtonLabel2.alpha = 0;
    wordButtonLabel3.alpha = 0;
    wordButton1.alpha = 1;
    wordButton2.alpha = 1;
    wordButton3.alpha = 1;
    
	[UIView beginAnimations: @"MoveButtons" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: nil];
	[UIView setAnimationDuration: .4];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];

    CGRect frame = wordButton1.frame;
	frame.origin.y = wagon1.frame.origin.y - wordButton1.frame.size.height;
	wordButton1.frame = frame;
    
    frame = wordButton2.frame;
	frame.origin.y = wagon2.frame.origin.y - wordButton2.frame.size.height;
	wordButton2.frame = frame;

    frame = wordButton3.frame;
	frame.origin.y = wagon3.frame.origin.y - wordButton3.frame.size.height;
	wordButton3.frame = frame;
	
    [UIView commitAnimations];
}

- (void) setWordModeGame {
    wordButtonLabel1.alpha = 1;
    wordButtonLabel2.alpha = 1;
    wordButtonLabel3.alpha = 1;
    wordButton1.alpha = 0;
    wordButton2.alpha = 0;
    wordButton3.alpha = 0;
}

- (void) setImageAndWordModeGame {
    wordButtonLabel1.alpha = 1;
    wordButtonLabel2.alpha = 1;
    wordButtonLabel3.alpha = 1;
    wordButton1.alpha = 1;
    wordButton2.alpha = 1;
    wordButton3.alpha = 1;

    CGRect frame = wordButton1.frame;
	frame.origin.y = wagon1.frame.origin.y - wordButtonLabel1.frame.size.height - wordButton1.frame.size.height;
	wordButton1.frame = frame;
    
    frame = wordButton2.frame;
	frame.origin.y = wagon2.frame.origin.y - wordButtonLabel2.frame.size.height - wordButton2.frame.size.height;
	wordButton2.frame = frame;
    
    frame = wordButton3.frame;
	frame.origin.y = wagon3.frame.origin.y - wordButtonLabel3.frame.size.height - wordButton3.frame.size.height;
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
	if (aLevel <= cLimitLevelBronze) hitsOfLevel1++;
	if (aLevel > cLimitLevelBronze && aLevel <= cLimitLevelSilver) hitsOfLevel2++;
	if (aLevel > cLimitLevelSilver) hitsOfLevel3++;		
}

// Hide the Word Clicked.
- (Word*) changeImageOn: (UIButton *) aWordButton wordButtonLabel: (UIButton *) aWordButtonLabel id: (int) idButton {

	AudioServicesPlaySystemSound(self.closeSoundId);

	Word *word = [self getNextWord];
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

	[parameters setObject: aWordButton forKey: @"button"];
	[parameters setObject: aWordButtonLabel forKey: @"buttonLabel"];
	[parameters setObject: [NSNumber numberWithInt: idButton] forKey: @"id"];
	if (word) [parameters setObject: word forKey: @"word"];	

	// Hide Image
	[UIView beginAnimations:@"HideWordAnimation" context: CFBridgingRetain(parameters)]; 
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDidStopSelector: @selector(hideWordAnimationDidStop:finished:context:)]; 	
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];

    if ([UserContext imageWordGameMode] == cImageModeGame) {
        aWordButton.alpha = 0;
    } else if ([UserContext imageWordGameMode] == cWordModeGame) {
        aWordButtonLabel.alpha = 0;
    } else { // cImageAndWordModeGame
        aWordButton.alpha = 0;
        aWordButtonLabel.alpha = 0;
    }
    
	[UIView commitAnimations];

	return word;
}

- (Word*) getNextWord {
	return [Vocabulary getAWord];
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
		NSLog(@"End game abnormally. getAWord return nil");
		[self endGame];
	}
	
}

- (void) showThisWord: (Word*) aWord id: (int) idButton button: (UIButton*) aWordButton buttonLabel: (UIButton*) aWordButtonLabel context:(void *)context {
    
	NSMutableDictionary *parameters = (__bridge  NSMutableDictionary*) context; // *** ARC
    [aWordButton setImage: aWord.image forState: UIControlStateNormal];
    [aWordButtonLabel setTitle: aWord.translatedName forState: UIControlStateNormal];
    
    [words replaceObjectAtIndex: idButton withObject: aWord];
    
    // Show new Image
    [UIView beginAnimations:@"ShowWordAnimation" context: ( void *)(parameters)];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(showWordAnimationDidStop:finished:context:)]; 
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];

    if ([UserContext imageWordGameMode] == cImageModeGame) {
        aWordButton.alpha = 1;
    } else if ([UserContext imageWordGameMode] == cWordModeGame) {
        aWordButtonLabel.alpha = 1;
    } else { // cImageAndWordModeGame
        aWordButton.alpha = 1;
        aWordButtonLabel.alpha = 1;
    }
    
    [UIView commitAnimations];
    qOfImagesRemaining--;
    if (qOfImagesRemaining <= 0) {
        [self endGame];
    }
}

- (void)showWordAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	//NSMutableDictionary *parameters = (__bridge  NSMutableDictionary*) context;
	//UIButton *aWordButton = (UIButton*) [parameters objectForKey: @"button"];
}

// When the train animation stop, the Game Start...
- (void) startGame { 
	[self.trainSound stop];
	pauseButton.alpha = 1;
	helpButton.alpha = 1;
	gameStatus = cStatusGameIsOn;
	[smokeView startAnimation];
}

- (void) endGame { 
}

// Train animation
- (void)introduceTrain { 
	gameStatus = cStatusGameIsIntroducingTrain;
	pauseButton.alpha = 0;
	helpButton.alpha = 0;	
	qOfImagesRemaining = [self hitsPerGame]; 

	hitsOfLevel1 = 0; // hits corresponding of cooper coins
	hitsOfLevel2 = 0; // hits corresponding to silver coins
	hitsOfLevel3 = 0; // hits corresponding to gold coins
	money = 0;  // Is used to refresh the moneyLabel one by one. Is used just in the method refreshMoneyLabels

	if (UserContext.soundEnabled) {
		[self.trainSound play]; 
	}	
	[self shiftTrain: [ImageManager windowWidth]];
	
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
    
    [self refreshGameMode];
	
}

- (void) initializeLevel {
    [Vocabulary initializeLevelUntil: [UserContext getLevel]];
}

- (void) viewDidAppear:(BOOL)animated {
	if (gameStatus != cStatusGameIsOn && gameStatus != cStatusGameIsPaused) {
		[self showAllViews];
		[self introduceTrain];
	}
	[self refreshSoundButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!words) words = [[NSMutableArray alloc] init];		
	[self initializeTimer];
	[self initMusicPlayer];
    
    wordButtonLabel1.titleLabel.minimumFontSize = 9;
    wordButtonLabel1.titleLabel.adjustsFontSizeToFitWidth = true;
    wordButtonLabel2.titleLabel.minimumFontSize = 9;
    wordButtonLabel2.titleLabel.adjustsFontSizeToFitWidth = true;
    wordButtonLabel3.titleLabel.minimumFontSize = 9;
    wordButtonLabel3.titleLabel.adjustsFontSizeToFitWidth = true;
}

- (void) takeOutTrain { 
	[smokeView endAnimation];
	
	gameStatus = cStatusGameIsTakeoutTrain;
	pauseButton.alpha = 0;
	helpButton.alpha = 0;
	
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
	[self done: nil];			// Return to main menu
}

- (int) hitRate {
    // ******** change 400 words - Revisar
    // Validar si el hitsPerGame se deja fijo o variable. El 10 est[a ok
	return (hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) * 10 / [self hitsPerGame];
}

- (int) hitsPerGame {
	return cHitsPerGame;
}

- (void) refreshMoneyViews: (NSString*) moneyType {
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
}

- (void) refreshMoneyLabels {
	money++;
	
	if (money > hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) {
		[self refreshMoneyLabelsFinished];
		return;
	}	
	
	AudioServicesPlaySystemSound(self.closeSoundId);
	
	[self addMoney];
	
	money1Label.text = [UserContext getMoney1AsText];
	money2Label.text = [UserContext getMoney2AsText];
	money3Label.text = [UserContext getMoney3AsText];	
}

// Implemented by subclass
- (void) refreshMoneyLabelsFinished { 
}


// Implemented by subclass
- (void) addMoney { 
}

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
    vocTripDelegate.levelView.startWithHelpDownload = 1;
    [vocTripDelegate pushLevelViewWithHelpDownload];
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
	
	[UIView commitAnimations];
}

- (void)landscapeAnimationDidStop: (NSString *)theAnimation finished: (BOOL)flag context: (void *)context {
	//[self endGame]; 
}

- (void) trainLoop {
	[wheel1 wheelLoop];
	[wheel2 wheelLoop];
	[wheel3 wheelLoop];
	[wheel4 wheelLoop];
	[wheel5 wheelLoop];
	[wheel6 wheelLoop];
	[wheel7 wheelLoop];
	[wheel8 wheelLoop];
	[wheel9 wheelLoop];
    
	[self moveWagon];
}

- (void) moveWagon {
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
	
	Word *word = [Vocabulary getAWord];
	[words addObject: word];
	[wordButton1 setImage: word.image forState: UIControlStateNormal];
	[wordButtonLabel1 setTitle: word.translatedName forState: UIControlStateNormal];
    
	word = [Vocabulary getAWord];
	[words addObject: word];
	[wordButton2 setImage: word.image forState: UIControlStateNormal];
	[wordButtonLabel2 setTitle: word.translatedName forState: UIControlStateNormal];
    
	word = [Vocabulary getAWord];
	[words addObject: word];
	[wordButton3 setImage: word.image forState: UIControlStateNormal];
	[wordButtonLabel3 setTitle: word.translatedName forState: UIControlStateNormal];
	
}

-(void) hideAllViews {	
    [self.view bringSubviewToFront:loadingView];
	loadingView.alpha = 1;	
}

-(void) showAllViews {
    /*CGRect frame = loadingView.frame;
    
	[UIView beginAnimations: @"LandscapeAnimation" context: landscape]; 
	[UIView setAnimationDelegate: self]; 
	[UIView setAnimationDuration: .2];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    frame.origin.x = frame.origin.x - [self windowWidth];
 
    loadingView.frame = frame;
	[UIView commitAnimations];*/

}

-(void) initMusicPlayer {
	
	// Close Sound
	NSURL* closeSoundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Finished" ofType:@"wav"]];
    //NSLog(@"%@", closeSoundUrl);
    
	AudioServicesCreateSystemSoundID((__bridge CFURLRef) closeSoundUrl, &closeSoundId);
	
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
	frame.origin.x = frame.origin.x + xPix; 
	wordButton1.frame = frame;	

	frame = wordButton2.frame;
	frame.origin.x = frame.origin.x + xPix; 
	wordButton2.frame = frame;	

	frame = wordButton3.frame;
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
	
	AudioServicesDisposeSystemSoundID(closeSoundId);
	
}

@end
