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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ((self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil])) {
    }
    return self;
}

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) showLevel: (Level*) aLevel at: (CGPoint) offset {
    level = aLevel;
    originalframeImageView = imageView.frame;
    gameStatus = cStatusGameIsOn;
    
    self.view.frame = CGRectMake(offset.x, offset.y, 0, 0);
    self.view.alpha = 0;
    imageView.alpha = 0;
    wordNamelabel.alpha = 0;
    nativeWordNamelabel.alpha = 0;
    
    //NSLog(@"width: %i, width: %f", [ImageManager windowWidth], backgroundView.frame.size.width);
    int deltaX = 50; // ([ImageManager windowWidth] - backgroundView.frame.size.width) / 2;
    int deltaY = 50; // backgroundView.frame.size.height;
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
    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(0, 0, 0, 0);
        self.view.alpha = 0;
    }];
    [theTimer invalidate];
	theTimer = nil;
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
    if (![wordNamelabel.text isEqualToString: word.localizationName])
        nativeWordNamelabel.text =  word.localizationName;
    else
        nativeWordNamelabel.text = @"";
    
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
	if ([UserContext getLevel] >= cLimitLevelGold) return;
    
	if ([UserContext getLevel] >= (level.levelNumber + 1))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-LearnThisLevel"];
	else if ([UserContext getLevel] < (level.levelNumber + 1))
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
