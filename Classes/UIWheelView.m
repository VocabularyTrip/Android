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
	//[super init];
	i = arc4random() % 8;
	//return self;
}

-(void) setI: (int) j {
	i = j;
}

- (void) wheelLoop {
	//CGAffineTransform t = CGAffineTransformRotate(self.transform, cRotate); //M_PI*i/180);
	//self.transform = t;
	UIImage *image;
	if (i==0)
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel1"]];	
	else if (i==1) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel2"]];
	else if (i==2) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel3"]];
	else if (i==3) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel4"]];
	else if (i==4) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel5"]];	
	else if (i==5) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel6"]];
	else if (i==6) 
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel7"]];
	else  
		image = [UIImage imageNamed: [UserContext getIphoneIpadFile: @"wheel8"]];	
	self.image = image;
	i+=1;
	if (i==8) i = 0;
}

@end
