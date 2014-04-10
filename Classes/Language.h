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
#define cInitFirstLanguages @"1|English-2|Chinese-3|Spanish-4|French-5|Farsi-6|German-8|Italian-9|Arabic-10|Egyptian-15|Malay-16|Vietnamese-17|Korean"

//#define cInitFirstLanguages @"1|English-2|Chinese-3|Spanish-4|French-5|Farsi-6|German-7|Portuguese-8|Italian-9|Arabic-10|Egyptian-11|Hebrew-12|Hindi-13|Japanese-14|Russian-15|Malay-16|Vietnamese-17|Korean"

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

+ (Language*) getLanguageAt: (int) key;
+ (Language*) getLanguageforLocalization: (NSString*) loc;
+ (Language*) getLanguageforKey: (int) key;
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
