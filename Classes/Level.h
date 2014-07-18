//
//  Level.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/13/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "SBJSON.h"
#import "Word.h"

// Repensar estas constantes - no aplican mas
#define cLimitLevelBronze 12
#define cLimitLevelSilver 24
#define cLimitLevel 46

@interface Level : Word <NSURLConnectionDelegate> {
	NSString *levelName;
    int size;
    CGPoint ipodPlaceInMap;
    CGPoint ipadPlaceInMap;
    int levelNumber;
  
}

@property (nonatomic, strong) NSString *levelName;
@property (nonatomic) int size;
@property (nonatomic) CGPoint ipodPlaceInMap;
@property (nonatomic) CGPoint ipadPlaceInMap;
@property (nonatomic) int levelNumber;


- (CGPoint) placeinMap;
+ (void)loadDataFromSql: (int) levelId;
+ (void) connectionFinishSuccesfully: (NSDictionary*) response;
+ (void) connectionFinishWidhError:(NSError *) error;

@end
