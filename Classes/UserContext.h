//
//  UserContext.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/21/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"
#import "User.h"
#import "Vocabulary.h"

#define cDefaultLang 1

#define cSetLevelsFree 6
#define cSet1OfLevels 12
//#define cSet2OfLevels 24
//#define cSet3OfLevels 36
#define cSet4OfLevels 46

#define cMaxLevelKey @"keyMaxLevel"
#define cSoundKey @"keySound"

#define cNoAskMeAgain @"noAskMeAgain"
#define cCountExecutions @"countExecutions"
#define cAskRateEachTimes 6
#define cAskToReviewTitle @"Review App"

#define cFirstUser 1
#define cUserselected @"userSelected"

#define cUrlServer @"http://www.vocabularytrip.com/android"

@interface UserContext : NSObject  {
    NSMutableArray *__strong users;
    User *__unsafe_unretained userSelected;
	int maxLevel;
	int soundEnabled;
}

extern UserContext *userContextSingleton; // Public Variable

@property (nonatomic, assign) int maxLevel;
@property (nonatomic, assign) int soundEnabled;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, unsafe_unretained) User *userSelected;

+ (UserContext*) getSingleton;
+ (User*) getUserSelected;
+ (Language*) getLanguageSelected;

// *************************
// ******** Level **********
+ (int)  getMaxLevel; // Once the app is downloaded, the maxLevel is 2 (cSetLevelsFree). Thats mean the user can play free up to level 2. Depending on diferents purchases the maxLevel could be cSet1OfLevels, cSet2OfLevels, etc.
+ (int)  getLevelNumber;
+ (Level*) getLevel;
+ (bool) nextLevel;
// ******** Level **********
// *************************

+ (NSString*) getPreferredLanguage;
+ (int) soundEnabled;
+ (void) setSoundEnabled: (int) newVal;
+ (int) osVersion;
+ (NSString*) printUserContext;

+ (void) reloadContext;
- (void) initAllUsers;
- (void) resetGame;
- (void) initGame;
- (void) initGameOnVersionChange;

@end
