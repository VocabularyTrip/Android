//
//  Language.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/10/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define cDictionrySize 63
#define cInitFirstLanguages @"1|English-2|Spanish-3|Chinese-4|Farsi-5|French-6|German-7|Italian-8|Korean-9|Malay-10|Vietnamese-11|Arabic-12|Egyptian"

extern NSMutableArray *allLanguages;

@interface Language : NSObject <NSURLConnectionDelegate> {
    int key;
    NSString* name;
    NSString* code;
    int qWords;
	UIImage *image;
    int langOrder;
}

@property (nonatomic, assign) int key;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, assign) int qWords;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) int langOrder;

+ (NSMutableArray*) getAllLanguages;
+ (void) initLanguages;
+ (Language*) getLanguageAt: (int) key;
+ (Language*) getLanguageforLocalization: (NSString*) loc;
+ (Language*) getLanguageforKey: (int) key;

@end
