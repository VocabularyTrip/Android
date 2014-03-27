//
//  UserContext.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/21/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "UserContext.h"
#import "Sentence.h"
#import "Album.h"
#import "VocabularyTrip2AppDelegate.h"


UserContext *userContextSingleton;

@implementation UserContext 

@synthesize maxLevel;	
@synthesize soundEnabled;
@synthesize allLevels;
@synthesize users;
@synthesize userSelected;
@synthesize aNewLanguage;

@synthesize levelGameMode;

+(UserContext*) getSingleton {
	if (userContextSingleton == nil)
		userContextSingleton = [[UserContext alloc] init];
	return userContextSingleton;
}

+(User*) getUserSelected {
    UserContext *c = [UserContext getSingleton];
    return c.userSelected;
}

+(void) addUser: (User*) aUser {
    [[UserContext getSingleton].users addObject: aUser ];
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

+ (int) levelGameMode {
	return [[UserContext getSingleton] levelGameMode];
}

+ (void) setLevelGameMode: (int) newVal {
	[[UserContext getSingleton] setLevelGameMode: newVal];
}

+(int) getLevelNumber {
    User *user = [self getUserSelected];
	return user.level;
}

+(void) addLevel: (Level*) aLevel {
	return [[UserContext getSingleton] addLevel: aLevel];
}

+(int) getMaxLevel {
	return [[UserContext getSingleton] maxLevel];
}

+(Level*) getLevelAt: (int) anIndex {
	return [[UserContext getSingleton] getLevelAt: anIndex];
}

+(Level*) getLevel {
	return [[UserContext getSingleton] getLevelAt: [self getLevelNumber]];
}

+(void) setaNewLanguage: (NSString*) aLang {
    [UserContext getSingleton].aNewLanguage = aLang;
}

+(NSString*) getaNewLanguage {
    return [UserContext getSingleton].aNewLanguage;
}

+(int)  getMoney1 {
    User *user = [self getUserSelected];
	return user.money1;
}

+(int)  getMoney2 {
    User *user = [self getUserSelected];
	return user.money2;
}

+(int)  getMoney3 {
    User *user = [self getUserSelected];
	return user.money3;

}

+(NSString*)  getMoney1AsText {
    User *user = [self getUserSelected];
	return user.getMoney1AsText;
}

+(NSString*)  getMoney2AsText {
    User *user = [self getUserSelected];
	return user.getMoney2AsText;
}

+(NSString*)  getMoney3AsText {
    User *user = [self getUserSelected];
	return user.getMoney3AsText;
}

+(void) addMoney1: (float) aMoney {
    User *user = [self getUserSelected];
	return [user addMoney1: aMoney];
}

+(void) addMoney2: (float) aMoney {
    User *user = [self getUserSelected];
	return [user addMoney2: aMoney];
}

+(void) addMoney3: (float) aMoney {
    User *user = [self getUserSelected];
	return [user addMoney3: aMoney];
}

+(bool) nextLevel {
    User *user = [self getUserSelected];
    [GameSequenceManager resetSequence];
	return [user nextLevel];
}

+(void) resetLevelAndMoney {
    User *user = [self getUserSelected];
    if (!user) return;
	return [user resetLevelAndMoney];
}

+ (NSString*) getPreferredLanguage {
    return 	[[NSLocale preferredLanguages] objectAtIndex: 0];
}

+ (int) osVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}

+ (bool) existUserData {
    if (![self getUserSelected]) return false;
    bool money = 
    (UserContext.getMoney1 != 0) || 
    (UserContext.getMoney2 != 0) || 
    (UserContext.getMoney3 != 0);
    
  	Album* albumTemp = [Album alloc];
	bool figurines = [albumTemp checkAnyBought: cAlbum1];
    
	albumTemp = [Album alloc];
	figurines = figurines || [albumTemp checkAnyBought: cAlbum2];

    return money || figurines;
}

+ (NSString*) getUUID {
  NSString* uniqueIdentifier = nil;
  if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
      // iOS 6+
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  } else {
      // before iOS 6, so just generate an identifier and store it
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    uniqueIdentifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
  }
  return uniqueIdentifier;
    //    NSString* uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    return  uuid;
}

-(id) init { 
    if (self=[super init]) {    
        soundEnabled = -1;
    }
	return self;
}

- (NSMutableArray*) users {
    //if (!users) users = [User loadDataFromXML];
    return users;
}

-(int) soundEnabled {   
	if (soundEnabled == -1) {
		soundEnabled = [[NSUserDefaults standardUserDefaults] integerForKey: cSoundKey];
	}
	return soundEnabled;
}

- (void) setUserSelected: (User *) aUser {
    userSelected = aUser;
    NSLog(@"UserId %i", userSelected.userId);
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

-(void) addThreeLevels {
	maxLevel += 3;
	[[NSUserDefaults standardUserDefaults] setInteger: maxLevel forKey: cMaxLevelKey];
}

-(void) initGame {
    [self resetGame];
    [Language initLanguagesLocaly];

   	[[NSUserDefaults standardUserDefaults] setInteger: cDefaultLang forKey: cLangSelected];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey: cNoAskMeAgain];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: cCountExecutions];

	[UserContext setHelpTraining: YES];
	[UserContext setHelpTest: YES];
	[UserContext setHelpAlbum: YES];
	[UserContext setHelpLevel: YES];
    [UserContext setHelpSelectLang: YES];
    [UserContext setHelpSelectUser: YES];
	UserContext.soundEnabled = YES;
	[[UserContext getSingleton] setMaxLevel: 0];
}

-(void) resetGame {	
	[UserContext resetLevelAndMoney];
	[Vocabulary resetAllWeigths];	
	Album* albumTemp = [Album alloc];
	[albumTemp resetAlbum: cAlbum1];
    
	albumTemp = [Album alloc];
	[albumTemp resetAlbum: cAlbum2];
    
    albumTemp = [Album alloc];
	[albumTemp resetAlbum: cAlbum3];

}

+(void) reloadContext {
    // Money is lazy initialization

    // Weights
    [Vocabulary reloadAllWeigths]; 

    // Figurines
    VocabularyTrip2AppDelegate *vcDelegate;
    vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView reloadFigurines];
}

+(bool) getHelpTraining {
	return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpTraining];
}

+(void) setHelpTraining: (bool) help {
	[[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpTraining];
}

+(bool) getHelpTest {
	return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpTest];
}

+(void) setHelpTest: (bool) help {
	[[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpTest];
}

+(bool) getHelpLevel {
	return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpLevel];
}

+(void) setHelpLevel: (bool) help {
	[[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpLevel];
}

+(bool) getHelpAlbum {
	return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpAlbum];
}

+(void) setHelpAlbum: (bool) help {
	[[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpAlbum];
}

+(bool) getHelpSelectUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpSelectUser];
}

+(void) setHelpSelectUser: (bool) help {
    [[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpSelectUser];
}

+(bool) getHelpSelectLang {
    return [[NSUserDefaults standardUserDefaults] boolForKey: cHelpSelectLang];
}

+(void) setHelpSelectLang: (bool) help {
    [[NSUserDefaults standardUserDefaults] setBool: help forKey: cHelpSelectLang];
}

+(bool) setUserPassword: (NSString*) password {
	[[NSUserDefaults standardUserDefaults] setObject: password forKey: cUserPassword];
    return YES;
}

+(NSString*) getUserPassword {
	return [[NSUserDefaults standardUserDefaults] objectForKey: cUserPassword];
}

+(bool) getIsLocked {
	return [[NSUserDefaults standardUserDefaults] boolForKey: cIsLocked];
}

+(void) setIsLocked: (bool) value {
	[[NSUserDefaults standardUserDefaults] setBool: value forKey: cIsLocked];
}

-(void) addLevel: (Level*) aLevel {
	if (allLevels == nil) {
		allLevels = [[NSMutableArray alloc] init];
	}
	[allLevels addObject: aLevel];
}

-(Level*) getLevelAt: (int) anIndex {
	return [allLevels objectAtIndex: anIndex];
    /*NSPredicate* predicate = [NSPredicate predicateWithFormat: @"order = %i", anIndex];
    NSArray* r = [allLevels filteredArrayUsingPredicate: predicate];
    if ([r count] > 0) return [r firstObject];
    return nil;*/
}


@end
