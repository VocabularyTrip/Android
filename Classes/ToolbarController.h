//
//  ToolbarController.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 10/26/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolbarController : UIViewController {
}

+(void) saySentence: (CGPoint) touchLocation
		 frame1View: (CGRect) frame1View
		frame1Label: (CGRect) frame1Label
		 frame2View: (CGRect) frame2View
		frame2Label: (CGRect) frame2Label
		 frame3View: (CGRect) frame3View
		frame3Label: (CGRect) frame3Label;
	
@end
