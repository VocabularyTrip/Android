    //
//  ToolbarController.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 10/26/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "ToolbarController.h"
#import "Sentence.h"
#import "UserContext.h"

@implementation ToolbarController

+(void) saySentence: (CGPoint) touchLocation
		 frame1View: (CGRect) frame1View
		 frame1Label: (CGRect) frame1Label
		 frame2View: (CGRect) frame2View
		 frame2Label: (CGRect) frame2Label
		 frame3View: (CGRect) frame3View
		 frame3Label: (CGRect) frame3Label {
	
	// Check toolbar click
	if (CGRectContainsPoint(frame1View, touchLocation) ||
		CGRectContainsPoint(frame1Label, touchLocation)) { 
		[Sentence playSpeaker: @"Toolbar-saySentence-BronzeToolbar"];
	}

	if (CGRectContainsPoint(frame2View, touchLocation) ||
		CGRectContainsPoint(frame2Label, touchLocation)) { 
		if ([UserContext getLevelNumber] <= cLimitLevelBronze) 
			[Sentence playSpeaker: @"Toolbar-saySentence-NotInSilverSection"];
		else 
			[Sentence playSpeaker: @"Toolbar-saySentence-BronzeToolbar"];
	}

	if (CGRectContainsPoint(frame3View, touchLocation) ||
		CGRectContainsPoint(frame3Label, touchLocation) ) { 
		if ([UserContext getLevelNumber] <= cLimitLevelSilver) 		
			[Sentence playSpeaker: @"Toolbar-saySentence-NotInGoldSection"];
		else 
			[Sentence playSpeaker: @"Toolbar-saySentence-BronzeToolbar"];
	}	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"didReceiveMemoryWarning in ToolbarController");
    // Release any cached data, images, etc. that aren't in use.
}



@end
