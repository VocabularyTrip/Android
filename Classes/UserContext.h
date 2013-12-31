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
// Ya no son 9 niveles. Usar [Vocabulary countOfLevels]
#define cLastLevel 9
#define cSilverLevel 6
#define cBronzeLevel 3

#define cMaxLevelKey @"keyMaxLevel"
#define cSoundKey @"keySound"

#define cImageWordGameModeKey @"keyImageWordGameModeKey"
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

#define cNoAskMeAgain @"noAskMeAgain"
#define cCountExecutions @"countExecutions"
#define cAskRateEachTimes 6
#define cAskToReviewTitle @"Review App"
#define cAskToRedownloadTitle @"Download all words"
#define cNotifyToPromoCodeDetected @"Promo Code Detected !" 
#define cNotifyToPromoCodeLimited @"Promo Code !" 

#define cFirstUser 1
#define cUserselected @"userSelected"
#define cLastTimePlayed @"lastTimePlayed" // This const is used to save the timePlayed. Next execution is saved in tbl_trace as statistic

#define cUsernameServer @"pablj100000"
#define cPasswordServer @"abdDEF123?"

#define cUrlServer @"http://www.vocabularytrip.com/phpProd"
#define cUserPassword @"userPassword"
#define cIsLocked @"langSelectionIsLocked"


@interface UserContext : NSObject  {
    NSMutableArray *__strong users;
    User *__unsafe_unretained userSelected;
	int maxLevel;
	NSMutableArray *allLevels;
	int soundEnabled;
    int imageWordGameMode;
    NSString* aNewLanguage;
}

extern UserContext *userContextSingleton;

@property (nonatomic, assign) int maxLevel;
@property (nonatomic) NSMutableArray *allLevels;
@property (nonatomic, assign) int soundEnabled;
@property (nonatomic, assign) int imageWordGameMode;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, unsafe_unretained) User *userSelected;
@property (nonatomic, strong) NSString* aNewLanguage;

+ (UserContext*) getSingleton;
+ (User*) getUserSelected;
+ (void) addUser: (User*) aUser;
+ (Language*) getLanguageSelected;
+ (bool) existUserData;
    
// **************************************
// ******** Money & Level **********
+ (int)  getMaxLevel;
+ (void) addLevel: (Level*) aLevel;
+ (int)  getLevel;
+ (void) setaNewLanguage: (NSString*) aLang;
+ (NSString*) getaNewLanguage;
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
+ (Level*) getLevelAt: (int) anIndex;
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

+(bool) setUserPassword: (NSString*) password;
+(NSString*) getUserPassword;
+(bool) getIsLocked;
+(void) setIsLocked: (bool) value;
    
+ (NSString*) getPreferredLanguage;
+ (int) soundEnabled;
+ (void) setSoundEnabled: (int) newVal;

+ (int) imageWordGameMode;
+ (void) setImageWordGameMode: (int) newVal;

+ (int) osVersion;
+ (NSString*) getUUID;

-(void) addThreeLevels; // deprecated?
-(void) addLevel: (Level*) level;	
-(int)  countOfLevels;
-(Level*) getLevelAt: (int) anIndex;
-(void) resetGame;
-(void) initGame;
+(void) reloadContext;
    
@end
