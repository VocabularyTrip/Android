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
@synthesize parentView;
@synthesize level;
@synthesize levelNamelabel;

- (IBAction) done:(id)sender {
    [theTimer invalidate];
	theTimer = nil;

    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate popMainMenuFromChangeLang];
}

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    imageView.alpha = 0;
	wordNamelabel.alpha = 0;
	nativeWordNamelabel.alpha = 0;
    levelNamelabel.text = level.name;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [UserContext setHelpMapViewStep3: NO];
    [self showAndSayDictionary];
}

- (void) viewDidLoad {
    originalframeImageView = imageView.frame;
    //[parentView setEnabledInteraction: YES];
}

- (IBAction) pauseClicked {
	//NSString *imageFile;
	if (gameStatus == cStatusGameIsOn) {
		//imageFile = [ImageManager getIphoneIpadFile: @"pause1"];
		[pauseButton setImage: [UIImage imageNamed: @"pause1.png"] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsPaused;
        repeatButton.enabled = YES;
        [theTimer setPaused: YES];
        [self throbPauseButton];
	} else	{
        [theTimer setPaused: NO];
		//imageFile = [ImageManager getIphoneIpadFile: @"pause2"];
		[pauseButton setImage: [UIImage imageNamed: @"pause2.png"] forState: UIControlStateNormal];
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
    
	[Vocabulary initializeLevelAt: level.levelNumber];
	[self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(showAndSayNextWord)];
		theTimer.frameInterval = 120;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
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
    
    //NSLog(@"Word: %@, Translated: %@, Loc: %@", word.name, word.translatedName, word.localizationName);
    imageView.alpha = 1;
    wordNamelabel.alpha = 1;
    nativeWordNamelabel.alpha = 1;
    //NSLog(@"is downloading: %i", singletonVocabulary.isDownloading);
    if (![word playSound]) { // && !singletonVocabulary.isDownloading
        [self mapView].startWithHelpDownload = 1;
        [self done: nil];
    }
}

- (void) showAndSayNextWord {
    

	word = [Vocabulary getOrderedWord];
    
	if ((word != nil)) {
        [self showAndSayWord];
	} else {
		[self cancelAnimation];
		[self helpLevel];
	}
}

- (void) helpLevel {
    // the user reach the last level
	if ([UserContext getLevelNumber] >= cLimitLevel) return;
    
	if ([UserContext getLevelNumber] == (level.levelNumber))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-LearnThisLevel"];
	else if ([UserContext getLevelNumber] < (level.levelNumber))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-UnlockLevel"];
}

- (void) cancelAnimation {
	if (theTimer) [theTimer invalidate];
	theTimer = nil;
    [self done: nil];
}

@end
