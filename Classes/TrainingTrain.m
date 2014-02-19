//
//  TrainingTrain.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/26/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "TrainingTrain.h"
#import "Sentence.h"
#import "TestTrain.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation TrainingTrain

- (IBAction)done:(id)sender {
	[super done: sender];
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromTrainingTrain];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	
	wordButton1.userInteractionEnabled = NO;
	wordButton2.userInteractionEnabled = NO;
	wordButton3.userInteractionEnabled = NO;
    wordButtonLabel1.userInteractionEnabled = NO;
    wordButtonLabel2.userInteractionEnabled = NO;
    wordButtonLabel3.userInteractionEnabled = NO;
}

- (void)trainAnimationDidStop:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	[super trainAnimationDidStop: theAnimation finished: flag context: context];
	[self initFlyWagons];
	if (viewMode == 1 && [UserContext getHelpTraining]) {
		//[Sentence playSpeaker: @"Training-ViewDidAppear"];
		[self helpAnimation1];
	}
}

- (void) initFlyWagons {
	if (flyWords == nil)
		flyWords = [[NSMutableArray alloc] init];
	else
		[flyWords removeAllObjects];

	[self addFlyWord: 0];
	[self addFlyWord: 1];
	[self addFlyWord: 2];
}

-(int) distanceBetweenWords {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return cDistanceBetweenWords * 2;
	else
		return cDistanceBetweenWords;	
}

- (int) getYposOfFlyWords {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return cYposOfFlyWords * 3;
	else
		return cYposOfFlyWords;
}

- (int) getXposOfFlyWords {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return cXposOfFlyWords * 2;
	else
		return cXposOfFlyWords;
}

- (void) addFlyWord: (int) i {
	UIImage *word = [[words objectAtIndex: i] image];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: word];
    
//    [ImageManager resizeImage: imageView toSize: wordButton1.frame.size.width];
    
	CGRect frame = imageView.frame;
	frame.origin.x = [self getXposOfFlyWords] - ([self distanceBetweenWords] * i);
	frame.origin.y = [self getYposOfFlyWords];
    frame.size.width = originalframeWord1ButtonView.size.width;
    frame.size.height = originalframeWord1ButtonView.size.height;
	imageView.frame = frame;
    [ImageManager fitImage: word inImageView: imageView];
    
	[flyWords addObject: imageView];
	[self.view addSubview: imageView];
	[self.view bringSubviewToFront: imageView];	
}

- (void) trainLoop {
	if (gameStatus == cStatusGameIsOn && viewMode == 1) {
		[self shiftFlyWord: 0];
		[self shiftFlyWord: 1];
		[self shiftFlyWord: 2];
		if ([self checkFlyWordsAreExit]) {
			if (viewMode == 1) [Sentence playSpeaker: @"Training-ThreeWordsAreExit"];
			[self endGame];
		}
	}
	[super trainLoop];
}

- (BOOL) checkFlyWordsAreExit { 
	BOOL flyWordsAreExit;
	flyWordsAreExit = YES;
	UIImageView *imageView = [flyWords objectAtIndex:0];
	CGRect frame = imageView.frame;
	if (frame.origin.x < [ImageManager windowWidth]) {
		flyWordsAreExit = NO;
	} else {
		imageView = [flyWords objectAtIndex:1];
		frame = imageView.frame;
		if (frame.origin.x < [ImageManager windowWidth]) {
			flyWordsAreExit = NO;
		} else {
			imageView = [flyWords objectAtIndex:2];
			frame = imageView.frame;
			if (frame.origin.x < [ImageManager windowWidth]) {
				flyWordsAreExit = NO;
			}
		}
	}
	return flyWordsAreExit;
}

- (void) takeOutTrain { 
	[super takeOutTrain];
	UIImageView *image = [flyWords objectAtIndex:0];
	[image removeFromSuperview];
	image = [flyWords objectAtIndex:1];
	[image removeFromSuperview];
	image = [flyWords objectAtIndex:2];
	[image removeFromSuperview];
}

- (void) shiftFlyWord: (int) i {
	UIImageView *image = [flyWords objectAtIndex:i];
	CGRect frame = image.frame;
	frame.origin.x = frame.origin.x + cWordSpeed;
	image.frame = frame;
}

- (void) changeImageTo: (int) i  with: (Word*) word {
	UIImageView *imageView = [flyWords objectAtIndex: i];
//	[imageView setImage: word.image];
	CGRect frame = imageView.frame;
	frame.origin.x = [self calculateXposFromOtherImages: i] - [self distanceBetweenWords];
	frame.origin.y = [self getYposOfFlyWords];
    frame.size.height = originalframeWord1ButtonView.size.height;
    frame.size.width = originalframeWord1ButtonView.size.width;
	imageView.frame = frame;
    [ImageManager fitImage: word.image inImageView: imageView];
	//imageView.frame = frame;
}

- (int) calculateXposFromOtherImages: (int) i {
	UIImageView *image1;
	UIImageView *image2;

	if (i==0) { 
		image1 = [flyWords objectAtIndex: 1];
		image2 = [flyWords objectAtIndex: 2];
	} else if (i==1) {
		image1 = [flyWords objectAtIndex: 0];
		image2 = [flyWords objectAtIndex: 2];
	} else {
		image1 = [flyWords objectAtIndex: 0];
		image2 = [flyWords objectAtIndex: 1];
	}	

	int x1 = image1.frame.origin.x;
	int x2 = image2.frame.origin.x;
	if (x2 >= [self getXposOfFlyWords] && x1 >= [self getXposOfFlyWords]) {
		return [self getXposOfFlyWords];
	} else if (x1 < x2) {
		return x1;
	} else {
		return x2;
	}

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan: touches withEvent: event];
	if (gameStatus == cStatusGameIsPaused || gameStatus == cStatusHelpOn) return;
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView: touch.view];
	
	int r = [self beginFlyWord: 0 touch: touchLocation];
	if (r < 0) r = [self beginFlyWord: 1 touch: touchLocation]; 
	if (r < 0) r = [self beginFlyWord: 2 touch: touchLocation];
	if (r >= 0) {
		Word *word = [words objectAtIndex: r];
        if (![word playSound]) // playSound should always return true. In case download faild, cound be posible the file sound doesn't exists and return false.
            [self pushLevelWithHelpDownload];
		wordFlying = r;
	} else {
		wordFlying = -1;
	}
}

- (int) beginFlyWord: (int) i touch: (CGPoint) touchLocation {
	UIImageView *imageView = [flyWords objectAtIndex: i];
	if (CGRectContainsPoint(imageView.frame, touchLocation)) { 
		imageView.center = touchLocation;
		return i;
	}
	return -1;
}	

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (gameStatus != cStatusGameIsOn) return; 
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView: touch.view];
	
	if (wordFlying >= 0) 
		[self moveFlyWord: touchLocation];
}	

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	wordFlying = -1;	
}

- (void) moveFlyWord: (CGPoint) touchLocation {
	if (wordFlying >= 0) {
		UIImageView *imageView = [flyWords objectAtIndex: wordFlying];
		if (CGRectContainsPoint(imageView.frame, touchLocation)) { 
			imageView.center = touchLocation;
			[self checkFlyWordArriveTarget: touchLocation];
		}
	}
}	

- (BOOL) checkFlyWordArriveTarget: (CGPoint) touchLocation {
	UIButton *button;
    UIButton* buttonLabel;
    UIButton* buttonToCheckArrival;
	@try {
		if (wordFlying == 0 ) {
            button = wordButton1;
            buttonLabel = wordButtonLabel1;
        }
		if (wordFlying == 1 )  {
            button = wordButton2;
            buttonLabel = wordButtonLabel2;
        }
		if (wordFlying == 2 ) {
            button = wordButton3;
            buttonLabel = wordButtonLabel3;
        }
        buttonToCheckArrival = [GameSequenceManager getCurrentGameSequence].includeImages ? button : buttonLabel;
		if (CGRectContainsPoint(buttonToCheckArrival.frame, touchLocation)) {
			int tempWordFlying = wordFlying;	// Prevent Recursive entry.
			wordFlying = -1;
			Word* word = [self changeImageOn: button wordButtonLabel: buttonLabel id: tempWordFlying];
			[self changeImageTo: tempWordFlying with: word];
			[self incrementHitAtLevel: word.theme];
			return YES;
		}
	} @catch (NSException * e) {
		NSLog(@"Exception at checkFlyWordArriveTarget");
	}
	@finally {
	}
	return NO;
}

- (void) addMoney { 
	if (money <= hitsOfLevel1) {
		[UserContext addMoney1: 1];
		[self refreshMoneyViews: cBronzeType];
	} else if (money <= hitsOfLevel2 + hitsOfLevel1) {
		[UserContext addMoney2: 1];
		[self refreshMoneyViews: cSilverType];
	} else if (money <= hitsOfLevel1 + hitsOfLevel2 + hitsOfLevel3) {
		[UserContext addMoney3: 1];
		[self refreshMoneyViews: cGoldType];		
	} 
}

- (void) refreshMoneyLabelsFinished {
	[self takeOutTrain];
}

- (void) endGame { 
	[super endGame];
	[self refreshMoneyLabels];
}	

// *****************************************
// Help Animation **************************

- (IBAction) helpClicked {
	[self helpAnimation1];
}

- (void) helpAnimation1 {
	gameStatus = cStatusHelpOn;
	helpButton.enabled = NO;

	[Sentence playSpeaker: @"Training-ViewDidAppear"];	
    // Make clicking hand visible
    [UIImageView beginAnimations: @"helpAnimation1" context: ( void *)(hand)];
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2:finished:context:)]; 
    [UIImageView setAnimationDuration: .5];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.alpha = 1;
	
    [UIImageView commitAnimations];	
}

- (void) helpAnimation2:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    // Bring clicking hand to clicking place
	
    CGRect handFrame = hand.frame;
    [self.view bringSubviewToFront:hand];
    
    UIImageView *image = [flyWords objectAtIndex:0];
    int x1 = image.frame.origin.x;
    image = [flyWords objectAtIndex:1];
    int x2 = image.frame.origin.x;
    image = [flyWords objectAtIndex:2];
    int x3 = image.frame.origin.x;
	
	int x;
	int helpWagonSelected;
    if (x1>x2 && x1>x3) {
        helpWagonSelected = 0;
		x = x1;
    } else if (x2 > x3) {
        helpWagonSelected = 1;
		x = x2;
    } else {
        helpWagonSelected = 2;
		x = x3;
    }

    [UIImageView beginAnimations: @"helpAnimation2" context: (__bridge void *)([NSNumber numberWithInt: helpWagonSelected])]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2b:finished:context:)]; 
    [UIImageView setAnimationDuration: 1];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    handFrame.origin.x = x + (image.frame.size.width / 2);
    handFrame.origin.y = [self getYposOfFlyWords] + (image.frame.size.height / 2);
    hand.frame = handFrame;
    [UIImageView commitAnimations];
	
}

- (void) helpAnimation2b:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    // click down
	CGRect frame = hand.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: context]; 
	[UIImageView setAnimationDelegate: self]; 
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3:finished:context:)]; 
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
    
	[UIImageView commitAnimations];
}


- (void) helpAnimation3:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
	// (*) move clicking hand + flying object to corresponding wagon
    int helpWagonSelected = [((__bridge NSNumber*) context) intValue];
    CGRect handFrame = hand.frame;	
    UIImageView *image = [flyWords objectAtIndex: helpWagonSelected];
    CGRect flyWordFrame = image.frame;

    [UIView beginAnimations: @"helpAnimation3" context: context]; 
    [UIView setAnimationDelegate: self]; 
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 2];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4:finished:context:)]; 
    [UIView setAnimationBeginsFromCurrentState: YES];
    switch (helpWagonSelected) {
        case 0:
            flyWordFrame.origin.x = wordButton1.frame.origin.x; 
            break;
        case 1:            
            flyWordFrame.origin.x = wordButton2.frame.origin.x; 
            break;
        case 2:
            flyWordFrame.origin.x = wordButton3.frame.origin.x;
        default:
            break;
    }
    handFrame.origin.x = flyWordFrame.origin.x + (flyWordFrame.size.width / 2);
    flyWordFrame.origin.y = wordButton1.frame.origin.y;
    handFrame.origin.y = wordButton1.frame.origin.y + (flyWordFrame.size.width / 2);
    hand.frame = handFrame;
    image.frame = flyWordFrame;
    [UIView commitAnimations];
}

- (void) helpAnimation4:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    // Change image on selected wagon
    int helpWagonSelected = [((__bridge NSNumber*) context) intValue];
    UIButton *button;
    UIButton *buttonLabel;
    switch (helpWagonSelected) {
        case 0: {
            button = wordButton1;
            buttonLabel = wordButtonLabel1;
            break;
        }
        case 1: {
            button = wordButton2;
            buttonLabel = wordButtonLabel2;
            break;
        }
        case 2: {
            button = wordButton3;
            buttonLabel = wordButtonLabel3;
            break;
        }
        default:
            break;
    }
    Word* word = [self changeImageOn: button wordButtonLabel: buttonLabel id: helpWagonSelected];
    [self changeImageTo: helpWagonSelected  with: word];
    [self helpAnimation5];
}

-(void) helpAnimation5 {
    // Make hand transparent
    [UIView beginAnimations:@"helpAnimation5" context:( void *)(hand)];
    [UIView setAnimationDelegate: self]; 
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)]; 
    [UIView setAnimationDuration:.5];
    [UIView setAnimationBeginsFromCurrentState: YES];
    hand.alpha = 0;
    [UIView commitAnimations];
}

- (void) helpAnimation6 {
	gameStatus = cStatusGameIsOn;
	[Sentence playSpeaker: @"Training-HelpEnded"];
	[UserContext setHelpTraining: NO];
	helpButton.enabled = YES;
}

// Help Animation **************************
// *****************************************

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in TrainingTrain");
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void) dealloc {
	[flyWords removeAllObjects];
}


@end
