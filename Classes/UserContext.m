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

+(int) getLevel {
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
	return [user nextLevel];
}

+(void) resetLevelAndMoney {
    User *user = [self getUserSelected];
    if (!user) return;
	return [user resetLevelAndMoney];
}

+(NSString*) getIphoneIpadFile: (NSString*) imageFile {
	return [self getIphoneIpadFile: imageFile ext: @"@ipad"];
}

+(NSString*) getIphoneIpadFile: (NSString*) imageFile ext: (NSString*) ext {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		imageFile = [NSString stringWithFormat: @"%@%@", imageFile, ext];
	imageFile = [NSString stringWithFormat: @"%@.png", imageFile];
    return imageFile;
}

+(NSString*) getIphone5xIpadFile: (NSString*) imageFile {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		imageFile = [NSString stringWithFormat: @"%@%@.png", imageFile, @"@ipad"];
    } else if ([self resolution] == UIDeviceResolution_iPhoneRetina5) {
        imageFile = [NSString stringWithFormat: @"%@%@.png", imageFile, @"@iphone5"];
    } else {
        imageFile = [NSString stringWithFormat: @"%@.png", imageFile];
    }
    return imageFile;
}

+ (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

+ (int) windowWidth {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    //CGFloat pixelwidth = (CGRectGetWidth(mainScreen.bounds) * scale);
    //NSLog(@"H: %f, W: %f", pixelHeight, pixelwidth);
    return pixelHeight;
    /*	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     return 1024;
     else
     return 480;*/
}

+ (int) getDeltaWidthIphone5 {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if ([self resolution] == UIDeviceResolution_iPhoneRetina5)
        return (pixelHeight - 1024)/2;
    else
        return 0;
}

+ (NSString*) getPreferredLanguage {
    return 	[[NSLocale preferredLanguages] objectAtIndex: 0];
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

-(int) countOfLevels {
	return [allLevels count];
}

-(Level*) getLevelAt: (int) anIndex {
	return [allLevels objectAtIndex: anIndex];
}


@end
