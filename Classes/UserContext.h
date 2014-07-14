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

#define cDefaultLang 1

// ******** change 400 words - Pending
// Ya no son 9 niveles. Estas dos constantes quedan deprecated
//#define cSilverLevel 6
//#define cBronzeLevel 3
#define cSetLevelsFree 2
#define cSet1OfLevels 12
#define cSet2OfLevels 24
#define cSet3OfLevels 36
#define cSet4OfLevels 50

#define cIsTemporalGameUnlockedKey @"TemporalGameUnlocked"
#define cMaxLevelKey @"keyMaxLevel"
#define cSoundKey @"keySound"

#define cImageModeGame 1
#define cWordModeGame 2
#define cImageAndWordModeGame 3

#define cBronzeType @"bronze"
#define cSilverType @"silver"
#define cGoldType @"gold"

#define cHelpTraining @"helpTraining"
#define cHelpTest @"helpTest"
#define cHelpAlbum @"helpAlbum"
#define cHelpLevel @"helpLevel"
#define cHelpSelectUser @"helpSelectUser"
#define cHelpSelectLang @"helpSelectLang"
#define cHelpMapViewStep1 @"helpMapViewStep1"
#define cHelpMapViewStep2 @"helpMapViewStep2"
#define cHelpMapViewStep3 @"helpMapViewStep3"

#define cNoAskMeAgain @"noAskMeAgain"
#define cCountExecutions @"countExecutions"
#define cAskRateEachTimes 6
#define cAskToReviewTitle @"Review App"
//#define cAskToRedownloadTitle @"Download all words"
#define cNotifyToPromoCodeDetected @"Promo Code Detected !" 
#define cNotifyToPromoCodeLimited @"Promo Code !" 

#define cFirstUser 1
#define cUserselected @"userSelected"
#define cLastTimePlayed @"lastTimePlayed" // This const is used to save the timePlayed. Next execution is saved in tbl_trace as statistic

#define cUsernameServer @"pablj100000"
#define cPasswordServer @"abdDEF123?"

#define cUrlServer @"http://www.vocabularytrip.com/phpTest"
#define cUserPassword @"userPassword"
#define cIsLocked @"langSelectionIsLocked"

#define cqPostInFasebook @"qPostInFacebook"
#define cMaxPostInFasebook 20

enum {
    tLevelModeGame_cumulative = 0, // default mode. If you are in the level 4, the game choose randomly words between words in level 1 to 4.
    tLevelModeGame_currentLevel    = 1,    // choose words from the current level
    tLevelModeGame_random    = 2,    // if you are in level 4, choose a level randomly up to level 4 and then get words from that level
    tLevelModeGame_selectAdHoc     = 3 // Allow the user select the level.
}; typedef NSUInteger tLevelModeGame;


@interface UserContext : NSObject  {
    NSMutableArray *__strong users;
    User *__unsafe_unretained userSelected;
	int maxLevel;
    bool isTemporalGameUnlocked; // The game could be unlocked by 1 day from facebook or promocodes
	NSMutableArray *allLevels;
	int soundEnabled;
    tLevelModeGame levelGameMode;
    NSString* aNewLanguage;
    int qPostInFacebook;
}

extern UserContext *userContextSingleton;

@property (nonatomic, assign) int maxLevel;
@property (nonatomic) NSMutableArray *allLevels;
@property (nonatomic, assign) int soundEnabled;
@property (nonatomic, assign) tLevelModeGame levelGameMode;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, unsafe_unretained) User *userSelected;
@property (nonatomic, strong) NSString* aNewLanguage;
@property (nonatomic, assign) int qPostInFacebook;
@property (nonatomic, assign) bool isTemporalGameUnlocked;

+ (UserContext*) getSingleton;
+ (User*) getUserSelected;
+ (void) addUser: (User*) aUser;
+ (Language*) getLanguageSelected;
+ (bool) existUserData;
    
// **************************************
// ******** Money & Level **********
+ (int)  getMaxLevel;
+ (int) getTemporalMaxLevel; //this method return getMaxLevel or cSet40Level if isTemporalGameUnlocked
+ (void) addLevel: (Level*) aLevel;
+ (int)  getLevelNumber;
+ (Level*) getLevelAt: (int) anIndex;
+ (Level*) getLevel;
+ (void) setaNewLanguage: (NSString*) aLang;
+ (NSString*) getaNewLanguage;
+ (NSString*) getMoneyAsText: (NSDecimalNumber*) money;
+ (NSString*) getMoneyIntAsText: (int) money;
+ (int)  getMoney1;
+ (int)  getMoney2;
+ (int)  getMoney3;
+ (NSString*) getMoney1AsText;
+ (NSString*) getMoney2AsText;
+ (NSString*) getMoney3AsText;
+ (void) addMoney1: (float) aMoney;
+ (void) addMoney2: (float) aMoney;
+ (void) addMoney3: (float) aMoney;
+ (bool) nextLevel;
+ (void) resetLevelAndMoney;
// ******** Money & Level **********
// **************************************

+(bool) getHelpTraining;
+(void) setHelpTraining: (bool) help;
+(bool) getHelpTest;
+(void) setHelpTest: (bool) help;
+(bool) getHelpLevel;
+(void) setHelpLevel: (bool) help;
+(bool) getHelpAlbum;
+(void) setHelpAlbum: (bool) help;
+(bool) getHelpSelectUser;
+(void) setHelpSelectUser: (bool) help;
+(bool) getHelpSelectLang;
+(void) setHelpSelectLang: (bool) help;
+(bool) getHelpMapViewStep1;
+(void) setHelpMapViewStep1: (bool) help;
+(bool) getHelpMapViewStep2;
+(void) setHelpMapViewStep2: (bool) help;
+(bool) getHelpMapViewStep3;
+(void) setHelpMapViewStep3: (bool) help;


+(bool) setUserPassword: (NSString*) password;
+(NSString*) getUserPassword;
+(bool) getIsLocked;
+(void) setIsLocked: (bool) value;
    
+ (NSString*) getPreferredLanguage;
+ (int) soundEnabled;
+ (void) setSoundEnabled: (int) newVal;

+ (int) levelGameMode;
+ (void) setLevelGameMode: (int) newVal;

+ (int) osVersion;
+ (NSString*) getUUID;

-(void) addLevel: (Level*) level;	
-(Level*) getLevelAt: (int) anIndex;
-(void) resetGame;
-(void) initGame;
-(void) addPostInFacebook;
+(void) reloadContext;
+ (NSString*) printUserContext;

@end
