//
//  TestTrain.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/14/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GenericTrain.h"
#import "UserContext.h"
#import "AnimatorHelper.h"

#define cElapsedInactivity1 4 // Is used to repeat the target word each 4 seconds
#define cElapsedInactivity2 16 // Is used to pause the application after 16 seconds with no clic.

#define cBronzeHitPrice 2 // Each hit is rewarded with money. This is the amount of money to win in each hit
#define cSilverHitPrice 2 // Each hit is rewarded with money. This is the amount of money to win in each hit
#define cGoldHitPrice 2 // Each hit is rewarded with money. This is the amount of money to win in each hit

@interface TestTrain : GenericTrain  {
	int targetId; // From three words over wagons, one is selected as a target. This target is said allowd each 2 second until the user clic in the corresponding wagon. 
	int flagFaild; 
	CFTimeInterval inactivity1;
	CFTimeInterval inactivity2;
	SystemSoundID errorSoundId;
}

- (IBAction) wordButton1Clicked;
- (IBAction) wordButton2Clicked;
- (IBAction) wordButton3Clicked;
- (bool) shortInactivity;
- (bool) longInactivity;
- (void) selectNextTarget;
- (void) sayTargetWord;
- (void) wordButton: (UIButton*) aButton buttonLabel: (UIButton*) aButtonLabel clicked: (int) i;
- (void) evaluateGetIntoNextLevel;
- (void) goToNextLevel;
- (IBAction) askToBuyNewLevels;

- (void) helpAnimation1;
- (void) helpAnimation2;
- (void) helpAnimation2b: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation2c: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation3;
- (void) helpAnimation4;
- (void) helpAnimation5;

@end
