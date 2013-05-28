//
//  UIWheelView.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/15/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>	
#import "UserContext.h"

@interface UIWheelView : UIImageView {
	//CADisplayLink *theTimer; 
	int i;
}

- (void) initialize;
- (void) wheelLoop;
- (void) setI: (int) j;

@end
