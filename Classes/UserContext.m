//
//  UserContext.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/21/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "UserContext.h"
#import "Sentence.h"
#import "VocabularyTrip2AppDelegate.h"


UserContext *userContextSingleton;

@implementation UserContext 

@synthesize maxLevel;	
@synthesize soundEnabled;
//@synthesize allLevels;
@synthesize users;
@synthesize userSelected;

+(UserContext*) getSingleton {
	if (userContextSingleton == nil)
		userContextSingleton = [[UserContext alloc] init];
	return userContextSingleton;
}

+(User*) getUserSelected {
    UserContext *c = [UserContext getSingleton];
    return c.userSelected;
}

+(Language*) getLanguageSelected {
    User *user = [self getUserSelected];
    if (!user) return nil;
    return user.langSelected;    
}

+(int) soundEnabled {
	return [[UserContext getSingleton] soundEnabled];
}

+(void) setSoundEnabled: (int) newVal {
	[[UserContext getSingleton] setSoundEnabled: newVal];
}

+(int) getLevelNumber {
    User *user = [self getUserSelected];
	return user.level;
}

+(int) getMaxLevel {
	return [[UserContext getSingleton] maxLevel];
}

/*+(Level*) getLevelAt: (int) anIndex {
	return [[UserContext getSingleton] getLevelAt: anIndex];
}*/

+(Level*) getLevel {
	return [singletonVocabulary.allLevels objectAtIndex: [self getLevelNumber]];
}

/*+(void) addLevel: (Level*) aLevel {
	return [[UserContext getSingleton] addLevel: aLevel];
}*/

+(bool) nextLevel {
    User *user = [self getUserSelected];
	return [user nextLevel];
}

+ (NSString*) getPreferredLanguage {
    return 	[[NSLocale preferredLanguages] objectAtIndex: 0];
}

+ (int) osVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}


-(id) init { 
    if (self=[super init]) {    
        soundEnabled = -1;
    }
	return self;
}

- (void) initAllUsers {
    User *user;
    users = [[NSMutableArray alloc] initWithCapacity: 1];
    
    for (int i=1; i<=6; i++) {
        user = [[User alloc] init];
        user.userId = i;
        [users addObject: user];
    }
}

-(int) soundEnabled {   
	if (soundEnabled == -1) {
		soundEnabled = [[NSUserDefaults standardUserDefaults] integerForKey: cSoundKey];
	}
	return soundEnabled;
}

- (void) setUserSelected: (User *) aUser {
    userSelected = aUser;
	[[NSUserDefaults standardUserDefaults] setInteger: userSelected.userId forKey: cUserselected];
}

- (User *) userSelected {
    if (!userSelected) {
        int i=0;
        i = [[NSUserDefaults standardUserDefaults] integerForKey: cUserselected];
        i--; // users array start from 0, while userId start from 1
        if (i<0) 
            return nil;
        userSelected = [[[UserContext getSingleton] users] objectAtIndex: i];        
    }
    return userSelected;
}

- (void) setSoundEnabled: (int) newVal {
	soundEnabled = newVal;
	[[NSUserDefaults standardUserDefaults] setInteger:soundEnabled forKey: cSoundKey];
}

-(int) maxLevel {
	maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey: cMaxLevelKey];
	return maxLevel;
}

-(void) setMaxLevel: (int) aLevel {
   
	[[NSUserDefaults standardUserDefaults] setInteger: aLevel forKey: cMaxLevelKey];
}

-(void) initGame {
    [self resetGame];

   	[[NSUserDefaults standardUserDefaults] setInteger: cDefaultLang forKey: cLangSelected];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey: cNoAskMeAgain];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: cCountExecutions];
    
	UserContext.soundEnabled = YES;
	[[UserContext getSingleton] setMaxLevel: cSet4OfLevels]; // ]cSetLevelsFree];
}

- (void) initGameOnVersionChange {
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey: cNoAskMeAgain];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: cCountExecutions];

    User *originalUser = [UserContext getUserSelected];
    Language *originalLang = [UserContext getLanguageSelected];
    
    for (int i=0; i < [[UserContext getSingleton].users count]; i++) {
        User* u = [[UserContext getSingleton].users objectAtIndex: i];
        [[UserContext getSingleton] setUserSelected: u];
        
        for (int j=0; j < [[Language getAllLanguages] count]; j++) {
            Language* l = [[Language getAllLanguages] objectAtIndex: j];
            [u setLangSelected: l];
            [u resetLevel];
        }
	}
    
    // Restore original selection
    [originalUser setLangSelected: originalLang];
    [[UserContext getSingleton] setUserSelected: originalUser];

    // Set max Level
    if ([UserContext getMaxLevel] > 1 && [UserContext getMaxLevel] < cSet1OfLevels)
        [[UserContext getSingleton] setMaxLevel: cSet1OfLevels];
    else
        [[UserContext getSingleton] setMaxLevel: cSetLevelsFree];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) resetGame {
    
    User *u = [UserContext getUserSelected];
    [u resetLevel];
	//[UserContext resetLevel];
	//[Vocabulary resetAllWeigths];

}

+(void) reloadContext {
    // Money is lazy initialization

    // Weights
    //[Vocabulary reloadAllWeigths];

}

+ (NSString*) printUserContext {
    NSString *r;
    
    r  = [NSString stringWithFormat: @"MaxLevel: %i", userContextSingleton.maxLevel];
    r  = [NSString stringWithFormat: @"%@, Level: %i, Lang: %@, userName: %@",
          r,
          userContextSingleton.userSelected.level,
          userContextSingleton.userSelected.langSelected.name,
          userContextSingleton.userSelected.userName];
    return r;
}

/*-(void) addLevel: (Level*) aLevel {
	if (allLevels == nil) {
		allLevels = [[NSMutableArray alloc] init];
	}
	[allLevels addObject: aLevel];
}

-(Level*) getLevelAt: (int) anIndex {
	return [allLevels objectAtIndex: anIndex];
}*/


@end
