				//
//  User.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/29/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "User.h"
#import "UserContext.h"
#import "ImageManager.h"

@implementation User

@synthesize level;
@synthesize langSelected;
@synthesize userId;
@synthesize userName;
@synthesize image;

-(void) saveLevel: (int) value {
    Language *l = [self langSelected];
    NSString *realKey = [NSString stringWithFormat: @"%i-%i-%@", userId, l.key, cLevelKey];
	[[NSUserDefaults standardUserDefaults] setInteger: value forKey: realKey];
}

-(int) getLevel {
    Language *l = [self langSelected];
    NSString *realKey = [NSString stringWithFormat: @"%i-%i-%@", userId, l.key, cLevelKey];
    return [[NSUserDefaults standardUserDefaults] integerForKey: realKey];
}

-(void) saveInt: (int) value forKey: (NSString*) key {
    NSString *realKey = [NSString stringWithFormat: @"%i-%@", userId, key];
	[[NSUserDefaults standardUserDefaults] setInteger: value forKey: realKey];
}

-(int) getIntForKey: (NSString*) key {
    NSString *realKey = [NSString stringWithFormat: @"%i-%@", userId, key];    
    return [[NSUserDefaults standardUserDefaults] integerForKey: realKey];
}

-(void) resetLevel {
	level = 0;
    [self saveLevel: level];
}

-(NSString*) userName {
    if (!userName) {
        NSString *keyName = [NSString stringWithFormat: @"user%iName", userId];
        userName = [[NSUserDefaults standardUserDefaults] stringForKey: keyName];
        if (!userName) userName = @"My Name";        
    }
    return [userName copy];
}

-(void) setUserName: (NSString*) aName {
    userName = aName;
    NSString *keyName = [NSString stringWithFormat: @"user%iName", userId];    
    [[NSUserDefaults standardUserDefaults] setValue: aName forKey: keyName];
}

-(int) level {
	if (level == 0) {
		level = [self getLevel];
		// if (level == 0) level = 1;
	}
	return level;
}

-(void) setLevel: (int) aLevel {
	level = aLevel;
    [self saveLevel: level];
}

// Is used to force change the level. When the game mode change, the level has to change.
-(void) reloadLevel {
    [self setLevel: [self getLevel]];
}

-(bool) nextLevel {
	if (level < [UserContext getMaxLevel]) {
		level++;
        [self saveLevel: level];
		return YES;
	} else {
		return NO;
	}
}

-(Language*) langSelected {   
	if (!langSelected) {
		int langId = [self getIntForKey: cLangSelected];
        if (langId == 0) {
            NSString *loc = [UserContext getPreferredLanguage];
            Language *newVal = [Language getLanguageforLocalization: loc];
            if (newVal == nil) newVal = [Language getLanguageAt: 0];
            [self setLangSelected: newVal];
            langSelected = newVal;
        } else
            langSelected = [Language getLanguageforKey: langId];
	}
	return langSelected;
}

- (void) setLangSelected:(Language *) newVal {
	langSelected = newVal;
    [self saveInt: langSelected.key forKey: cLangSelected];
    level = [self getLevel]; // Reload since level depends on Language.
    //[Vocabulary reloadAllWeigths];
}

-(UIImage*) image {
    if (image == nil) {
        NSString *imageName = [NSString stringWithFormat: @"newAvatar%i-03-01", userId];
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@.png", [[NSBundle mainBundle] resourcePath], imageName];
        image = [UIImage alloc];
        image = [image initWithContentsOfFile: file];
    }
    return image;
}

@end
