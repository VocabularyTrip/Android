//
//  UIWheelView.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/15/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "UIWheelView.h"
#import <QuartzCore/CADisplayLink.h>
#import <CoreGraphics/CoreGraphics.h>	

@implementation UIWheelView

- (void) initialize {
	i = arc4random() % 8;
}

-(void) setI: (int) j {
	i = j;
}

- (void) wheelLoop {
	UIImage *image;
	if (i==0)
		image = [UIImage imageNamed: @"wheel1.png"];
	else if (i==1) 
		image = [UIImage imageNamed: @"wheel2.png"];
	else if (i==2) 
		image = [UIImage imageNamed: @"wheel3.png"];
	else if (i==3) 
		image = [UIImage imageNamed: @"wheel4.png"];
	else if (i==4) 
		image = [UIImage imageNamed: @"wheel5.png"];
	else if (i==5) 
		image = [UIImage imageNamed: @"wheel6.png"];
	else if (i==6) 
		image = [UIImage imageNamed: @"wheel7.png"];
	else  
		image = [UIImage imageNamed: @"wheel8.png"];
	self.image = image;
	i+=1;
	if (i==8) i = 0;
}

@end
