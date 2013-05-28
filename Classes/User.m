				//
//  User.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/29/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "User.h"
#import "UserContext.h"

@implementation User

@synthesize level;
@synthesize money1;
@synthesize money2;
@synthesize money3;
@synthesize langSelected;
@synthesize userId;
@synthesize userName;
@synthesize image;
@synthesize imageBig;

+(void)loadDataFromXML {
	
	NSString* path = [[NSBundle mainBundle] pathForResource: @"Users" ofType: @"xml"];
	NSData* data = [NSData dataWithContentsOfFile: path];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
	[UserContext getSingleton].users = [[NSMutableArray alloc] initWithCapacity: 1];
    
	[parser setDelegate:self];
	[parser parse];
}	

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	if ([elementName isEqualToString:@"user"]) {
		User *user = [[User alloc] init];
        user.userId = [[attributeDict objectForKey: @"userId"] intValue];
        //user.userName = [attributeDict objectForKey:@"name"];
        [UserContext addUser: user];
	
	}
}

+ (void)parserDidEndDocument:(NSXMLParser *)parser {
}

+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Users. Error Parsing at line: %i, column: %i", parser.lineNumber, parser.columnNumber);	
}

-(id) init { 
    if (self=[super init]) {    
        money1 = -1;
        money2 = -1;
        money3 = -1;	
    }
	return self;
}

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

-(void) resetLevelAndMoney {
	level = 0;
	money1 = 0;
	money2 = 0;
	money3 = 0;	
    [self saveInt: money1 forKey: cMoney1Key];
    [self saveInt: money2 forKey: cMoney2Key];
    [self saveInt: money3 forKey: cMoney3Key];
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
		if (level == 0) {
			level = 1;
		}
	}
	return level;
}

-(void) setLevel: (int) aLevel {
	level = aLevel;
    [self saveLevel: level];
}

-(bool) nextLevel {
	if (level <[UserContext getMaxLevel]) {
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
            if (newVal == nil) newVal = [Language getLanguageAt: 1];   
            [self setLangSelected: newVal];
            langSelected = newVal;
        } else
            langSelected = [Language getLanguageAt: langId];
	}
	return langSelected;
}

- (void) setLangSelected:(Language *) newVal {
	langSelected = newVal;
    [self saveInt: langSelected.key forKey: cLangSelected];
    level = [self getLevel]; // Reload since level depends on Language.
    [Vocabulary reloadAllWeigths]; 
}

-(int) money1 {
	if (money1 == -1) {
		money1 = [self getIntForKey: cMoney1Key];
		if (money1 == -1) {
			money1 = 0;
		}
	}
	return money1;
}

-(void) setMoney1: (int) money {
	money1 = money;
    [self saveInt: money forKey: cMoney1Key];
}

-(int) money2 {
	if (money2 == -1) {
		money2 = [self getIntForKey: cMoney2Key];
		if (money2 == -1) {
			money2 = 0;
		}
	}
	return money2;
}

-(void) setMoney2: (int) money {
	money2 = money;
    [self saveInt: money forKey: cMoney2Key];
}

-(int) money3 {
	if (money3 == -1) {
		money3 = [self getIntForKey: cMoney3Key];
		if (money3 == -1) {
			money3 = 0;
		}
	}
	return money3;
}

-(void) setMoney3: (int) money {
	money3 = money;
    [self saveInt: money forKey: cMoney3Key];
}

-(void) addMoney1: (float) aMoney {
	money1 = money1 + aMoney;
    [self saveInt: money1 forKey: cMoney1Key];
}

-(void) addMoney2: (float) aMoney {
	money2 = money2 + aMoney;
    [self saveInt: money2 forKey: cMoney2Key];    
}

-(void) addMoney3: (float) aMoney {
	money3 = money3 + aMoney;
    [self saveInt: money3 forKey: cMoney3Key];    
}

-(NSString*) getMoneyAsText: (NSDecimalNumber*) money {
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterCurrencyStyle;
	f.maximumFractionDigits = 2;
	NSString *r = [f stringFromNumber: money];
	f = nil;
	return r;
}

-(NSString*) getMoneyIntAsText: (int) money {
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterCurrencyStyle;
	f.maximumFractionDigits = 0;
	NSString *r = [f stringFromNumber: [NSNumber numberWithInt: money]];
	f = nil;
	return r;
}


-(NSString*) getMoney1AsText {
	return [self getMoneyIntAsText: [self money1]];
}

-(NSString*) getMoney2AsText {
	return [self getMoneyIntAsText: [self money2]];
}

-(NSString*) getMoney3AsText {
	return [self getMoneyIntAsText: [self money3]];
}

-(UIImage*) image {
    if (image == nil) {
        NSString *imageName = [NSString stringWithFormat: @"avatar%i", userId];
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [UserContext getIphoneIpadFile: imageName]];		
        image = [UIImage alloc];
        image = [image initWithContentsOfFile: file];
    }
    return image;
}

-(UIImage*) imageBig {
    if (imageBig == nil) {
        NSString *imageName = [NSString stringWithFormat: @"avatar%iBig", userId];
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [UserContext getIphoneIpadFile: imageName]];
        imageBig = [UIImage alloc];
        imageBig = [imageBig initWithContentsOfFile: file];
    }
    return imageBig;
}

-(void) purge {
	image = nil;
	imageBig = nil;
    
}


@end
