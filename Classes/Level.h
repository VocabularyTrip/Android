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
#define cLimitLevelBronze 6
#define cLimitLevelSilver 15
#define cLimitLevel 46

#define cLimitLevelStage1 9
#define cLimitLevelStage2 18
#define cLimitLevelStage3 27
#define cLimitLevelStage4 36
#define cLimitLevelStage5 46

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
