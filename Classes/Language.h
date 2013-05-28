//
//  Language.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/10/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "SBJSON.h"

#define cArrayLanguages @"arrayOfLanguages"
#define cInitFirst10Languages @"1|English-2|Spanish-3|Chinese-4|Farsi-5|French-6|German-7|Italian-8|Korean-9|Malay-10|Vietnamese"

extern NSMutableArray *allLanguages;

@interface Language : NSObject <NSURLConnectionDelegate> {
    int key;
    NSString* name;
    NSString* code;
    int qWords;
	UIImage *image; 
}

@property (nonatomic, assign) int key;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, assign) int qWords;
@property (nonatomic, strong) UIImage *image;

+ (Language*) getLanguageAt: (int) key;
+ (Language*) getLanguageforLocalization: (NSString*) loc;
+ (NSMutableArray*) getAllLanguages;
+ (void) loadLanguagesLocaly;
+ (void) saveLanguagesLocaly;
+ (void) initLanguagesLocaly;
+ (BOOL) download: (NSString*) langArchive setAnewLanguage: (bool) setANewLang;
+ (NSString*) downloadDestinationPath;
+ (NSString*) checkIfDestinationPathExist;
+ (NSString*) iconImageName: (NSString*) fileName;
+ (NSString*) iconImageName: (NSString*) fileName prefix: (NSString*) prefix;
+ (bool) allImagesDownloaded: (int) qLangs;
+ (void) copyImageToDestinationPath: (NSString *) langName ext: (NSString*) ext;


+ (void) requestAllLanguages;
+ (void) connectionFinishSuccesfully: (NSDictionary*) dict;
+ (void) connectionFinishWidhError:(NSError *) error;

- (void) countOfWords;
- (void) connectionFinishSuccesfully: (NSDictionary*) dict;
- (void) connectionFinishWidhError:(NSError *) error;

@end
