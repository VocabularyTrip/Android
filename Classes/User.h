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

#define cLevelKey @"keyLevel"
#define cLangSelected @"LangSelected"

@interface User : NSObject <NSXMLParserDelegate> {
    int userId;
    int level;
    Language* __unsafe_unretained langSelected;
    NSString *userName;
    UIImage *image;
}

@property (nonatomic, assign) int level;
@property (nonatomic, unsafe_unretained) Language* langSelected;
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) UIImage* image;

- (void) saveInt: (int) value forKey: (NSString*) key;
- (int) getIntForKey: (NSString*) key;
- (void) saveLevel: (int) value;
- (int) getLevel;
- (void) reloadLevel; // Is used to force change the level. When the game mode change, the level has to change.
- (void) resetLevel;
- (bool) nextLevel;

@end
