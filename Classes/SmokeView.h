//
//  SmokeView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/25/12.
//  Copyright 2012 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserContext.h"

#define cSmokeSpeedX 10
#define cSmokeSpeedY -30

@interface SmokeView : UIImageView {
	int smokeCnt;
	bool endAnimation;
}

- (void) startAnimation;
- (void) endAnimation;
- (void) loopSmoke;
- (void) moveSmoke;
- (void) initPosition;
	
@end
