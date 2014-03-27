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

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) viewDidLoad {
    originalframeImageView = imageView.frame;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // This empty method is intended to overwrite the MapScrollView method.
    // the idea is not scrolling when Level is visible
}

- (void) showLevel: (Level*) aLevel at: (CGPoint) offset {
    VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.mapView stopBackgroundSound];
    level = aLevel;

    
    gameStatus = cStatusGameIsOn;
    
    self.view.frame = CGRectMake(offset.x, offset.y, 0, 0);
    self.view.alpha = 0;
    imageView.alpha = 0;
    wordNamelabel.alpha = 0;
    nativeWordNamelabel.alpha = 0;

    int deltaX = ([ImageManager windowWidthXIB] - backgroundView.frame.size.width) / 2;
    // [ImageManager levelViewDeltaXYCorner];

    NSLog(@"%f, %f", vcDelegate.mapView.langButton.frame.size.height, ([ImageManager windowHeightXIB] - backgroundView.frame.size.height) / 2);
    int deltaY = vcDelegate.mapView.langButton.frame.size.height + ([ImageManager windowHeightXIB] - backgroundView.frame.size.height - vcDelegate.mapView.langButton.frame.size.height) / 2;
    NSLog(@"delta :%i", deltaY);
    
    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(
            offset.x + deltaX, offset.y + deltaY,
            backgroundView.frame.size.width,
            backgroundView.frame.size.height);
        self.view.alpha = 1;
    }];
    
    [self showAndSayDictionary];
}

- (IBAction) close {
    [parentView setEnabledInteraction: YES];

    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(0, 0, 0, 0);
        self.view.alpha = 0;
    }];
    [theTimer invalidate];
	theTimer = nil;
    VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.mapView initializeTimeoutToPlayBackgroundSound];
}

- (IBAction) pauseClicked {
	NSString *imageFile;
	if (gameStatus == cStatusGameIsOn) {
		imageFile = [ImageManager getIphoneIpadFile: @"pause1"];
		[pauseButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
		gameStatus = cStatusGameIsPaused;
        repeatButton.enabled = YES;
        [theTimer setPaused: YES];
        [self throbPauseButton];
	} else	{
        [theTimer setPaused: NO];
		imageFile = [ImageManager getIphoneIpadFile: @"pause2"];
		[pauseButton setImage: [UIImage imageNamed: imageFile] forState: UIControlStateNormal];
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
    
    MapView* mapView = [self mapView];
    
    //if (i > 0 && [UserContext getMaxLevel] == 0) return;
    //if (mapView.helpButton.enabled == NO) [self cancelAnimation];
	[Vocabulary initializeLevelAt: level.levelNumber];
	mapView.helpButton.enabled = NO;
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
    
    if (![word playSound] && !singletonVocabulary.isDownloading) {
        //if (angle==0) {    // I want this help to start only if it is not running already. Not to start every time it tries to say a word that does not exist.
        [[self mapView] helpDownload1];
        //    angle = 1;
        //}
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

-(void) helpLevel {
    // the user reach the last level
	if ([UserContext getLevelNumber] >= cLimitLevel) return;
    
	if ([UserContext getLevelNumber] >= (level.levelNumber + 1))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-LearnThisLevel"];
	else if ([UserContext getLevelNumber] < (level.levelNumber + 1))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-UnlockLevel"];
}

-(void) cancelAnimation {
	//imageView.alpha = 0;
	//wordNamelabel.alpha = 0;
    //nativeWordNamelabel.alpha = 0;
	//helpButton.enabled = YES;
	if (theTimer) [theTimer invalidate];
	theTimer = nil;
    [self close];
}

@end
