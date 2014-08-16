//
//  TrainingTrain.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/26/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTrain.h"

#define cDistanceBetweenWords 100
#define cYposOfFlyWords 60
#define cXposOfFlyWords 50
#define cWordSpeed 5

@interface TrainingTrain : GenericTrain {
	NSMutableArray *flyWords;
	int wordFlying;
}

- (void) initFlyWagons;
- (void) addFlyWord: (int) i;
- (void) shiftFlyWord: (int) i;
- (BOOL) checkFlyWordArriveTarget: (CGPoint) touchLocation;
- (void) changeImageTo: (int) i  with: (Word*) word;
- (BOOL) checkFlyWordsAreExit;
- (int)  calculateXposFromOtherImages: (int) i;
- (int) beginFlyWord: (int) i touch: (CGPoint) touchLocation;
- (void) moveFlyWord: (CGPoint) touchLocation;
- (int) getYposOfFlyWords;
- (int) distanceBetweenWords;

// *****************************************
// Help Animation **************************

- (void) helpAnimation1;
- (void) helpAnimation2: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation2b: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation3: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation4: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation5;
- (void) helpAnimation6;	

@end
