//
//  LevelViewViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import "LevelView.h"
#include "VocabularyTrip2AppDelegate.h"
#include "MapView.h"

@interface LevelView ()

@end

@implementation LevelView

@synthesize imageView;
@synthesize wordNamelabel;
@synthesize nativeWordNamelabel;
@synthesize pauseButton;
@synthesize repeatButton;
@synthesize backgroundView;
@synthesize level;
@synthesize levelNamelabel;

- (IBAction) done:(id)sender {
    [theTimer invalidate];
	theTimer = nil;

    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate popMapView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    imageView.alpha = 0;
	wordNamelabel.alpha = 0;
	nativeWordNamelabel.alpha = 0;
    levelNamelabel.text = level.name;

    gameStatus = cStatusGameIsPaused;
    [self pauseClicked]; // This method chanche the gameStatus and refresh button. 
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self showAndSayDictionary];
}

- (void) viewDidLoad {
    originalframeImageView = imageView.frame;
}

- (IBAction) pauseClicked {
	if (gameStatus == cStatusGameIsOn) {
		[pauseButton setImage: [UIImage imageNamed: @"pause_on.png"] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsPaused;
        repeatButton.enabled = YES;
        [theTimer setPaused: YES];
        [self throbPauseButton];
	} else	{
        [theTimer setPaused: NO];
		[pauseButton setImage: [UIImage imageNamed: @"pause_off.png"] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsOn;
        repeatButton.enabled = NO;
	}
}

- (IBAction) repeatClicked {
    [self showAndSayWord];
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


- (void) showAndSayDictionary {
	[singletonVocabulary initializeLevelAt: level.levelNumber];
	[self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(showAndSayNextWord)];
		theTimer.frameInterval = 120;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) showAndSayNextWord {
	word = [singletonVocabulary getOrderedWord];
    
	if ((word != nil)) {
        [self showAndSayWord];
	} else {
		[self helpLevel];
        [self done: nil];
	}
}

- (void) showAndSayWord {
    imageView.frame = originalframeImageView;
    [ImageManager fitImage: word.image inImageView: imageView];
    wordNamelabel.text = word.translatedName;
    nativeWordNamelabel.text =  word.localizationName;

    imageView.alpha = 1;
	wordNamelabel.alpha = 1;
	nativeWordNamelabel.alpha = 1;
    
    if (![word playSound]) {
        //[self mapView].startWithHelpDownload = 1;
        [self done: nil];
    }
}

- (void) helpLevel {
    // the user reach the last level
	if ([UserContext getLevelNumber] >= cSet4OfLevels) return;
    
	if ([UserContext getLevelNumber] == (level.levelNumber))
		[singletonSentenceManager playSpeaker: @"LevelView-DidSelectRow-LearnThisLevel"];
	else if ([UserContext getLevelNumber] < (level.levelNumber))
		[singletonSentenceManager playSpeaker: @"LevelView-DidSelectRow-UnlockLevel"];
}

@end
