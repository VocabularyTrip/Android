//
//  User.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/29/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"
#import "Vocabulary.h"

#define cMoney1Key @"keyMoney1"
#define cMoney2Key @"keyMoney2"
#define cMoney3Key @"keyMoney3"
#define cLevelKey @"keyLevel"
#define cLangSelected @"LangSelected"
#define cGameSequenceKey @"gameSequenceKey"

@interface User : NSObject <NSXMLParserDelegate> {
    int userId;
    int level;
    int money1;
    int money2;
    int money3;
    int gameSequenceNumber;
    Language* __unsafe_unretained langSelected;
    NSString *userName;
    UIImage *image;
    bool readAbility; // true indicate that the user wants to play with words name. Enable all GameSequence where readAbility is true
}

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int money1;
@property (nonatomic, assign) int money2;
@property (nonatomic, assign) int money3;
@property (nonatomic, assign) int gameSequenceNumber;
@property (nonatomic, unsafe_unretained) Language* langSelected;
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic) bool readAbility;

+ (void)loadDataFromXML;
+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;

- (void) saveInt: (int) value forKey: (NSString*) key;
- (int) getIntForKey: (NSString*) key;
- (void) addMoney1: (float) aMoney;
- (void) addMoney2: (float) aMoney;
- (void) addMoney3: (float) aMoney;
- (NSString*) getMoneyAsText: (NSDecimalNumber*) money;
- (NSString*) getMoneyIntAsText: (int) money;
- (NSString*) getMoney1AsText;
- (NSString*) getMoney2AsText;
- (NSString*) getMoney3AsText;
- (void) reloadGameSequenceNumer;
- (void) saveLevel: (int) value;
- (int) getLevel;
- (void) reloadLevel; // Is used to force change the level. When the game mode change, the level has to change.
- (void) resetLevelAndMoney;
- (bool) nextLevel;
- (void) nextSequence;
- (void) nextSequence: (NSString*) gameType;
- (void) resetSequence;
- (void) purge;

@end
