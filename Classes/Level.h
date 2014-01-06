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


#define cLimitLevelBronze 3
#define cLimitLevelSilver 6
#define cLimitLevelGold 9

@interface Level : Word <NSURLConnectionDelegate> {
	//UIImage *imageLocked;
	//NSString *imageLockedName;
	//UIImage *imageNotAvailable;
	//NSString *imageNotAvailableName;
	NSString *levelName;
    int size;
}

//@property (nonatomic) UIImage *imageLocked;
//@property (nonatomic) UIImage *imageNotAvailable;
//@property (nonatomic, strong) NSString *imageLockedName;
//@property (nonatomic, strong) NSString *imageNotAvailableName;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic) int size;

+ (void)loadDataFromSql: (int) levelId;
+ (void) connectionFinishSuccesfully: (NSDictionary*) response;
+ (void) connectionFinishWidhError:(NSError *) error;
//- (UIImage*) imageLocked;
//- (UIImage*) imageNotAvailable;
//- (void) purge;

@end
