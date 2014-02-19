//
//  SmokeView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/25/12.
//  Copyright 2012 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "SmokeView.h"


@implementation SmokeView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		smokeCnt = 0;
		self.alpha = 0;
    }
    return self;
}

- (void) startAnimation {
	self.alpha = 1;
	smokeCnt = 0;
	endAnimation = NO;
	[self initPosition];
	[self moveSmoke];
}

- (void) endAnimation {
	// Cancel Animation
	endAnimation = YES;
	[UIView beginAnimations: @"smokeAnimation"  context: NULL]; 
	[UIView setAnimationBeginsFromCurrentState: YES]; 
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.alpha = 0;	
	[UIView commitAnimations];	
	
}

- (void) loopSmoke {
	if (endAnimation) return;
	if (smokeCnt < 40) {
		[self moveSmoke];
		smokeCnt++;		
	} else {
		[self startAnimation];
	}
}

- (void) moveSmoke {
		bool currentState = smokeCnt == 0 ? NO : YES;
		int smokeSpeedX = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? cSmokeSpeedX : cSmokeSpeedX / 2;
		int smokeSpeedY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? cSmokeSpeedY : cSmokeSpeedY / 2;
	
		CGRect frame = self.frame;		
		[UIView beginAnimations:@"smokeAnimation" context: (__bridge void *)(self)]; 
		[UIView setAnimationDelegate: self]; 
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration: .2];
		[UIView setAnimationBeginsFromCurrentState: currentState];
		[UIView setAnimationDidStopSelector: @selector(loopSmoke)]; 
		
		frame.origin.x = frame.origin.x + smokeSpeedX;
		frame.origin.y = frame.origin.y + smokeSpeedY * pow(.9, smokeCnt);
		int newWidth = frame.size.width * 1.1;
		int newHeight = frame.size.height * 1.01;
		frame.size.width = newWidth;
		frame.size.height = newHeight;
		self.frame = frame;
		self.alpha = pow(0.9, smokeCnt);
		
		[UIView commitAnimations];
}

- (void) initPosition {
	smokeCnt = 0;
    
    
	/*CGRect frame = self.frame;
	frame.origin.x = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 86 : 45 + [ImageManager getDeltaWidthIphone5];
	frame.origin.y = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 480 : 175;
	frame.size.width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40 : 20;
	frame.size.height= UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40 : 20;
	self.frame = frame;*/

    self.frame = [ImageManager smokeViewInitRect];
}


- (void)dealloc {
	[self endAnimation];
}


@end
