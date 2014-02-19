//
//  Language.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/10/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "Language.h"
#import "ImageManager.h"
#import "UserContext.h"

NSMutableArray *allLanguages = nil;

@implementation Language

@synthesize key;
@synthesize name;
@synthesize code;
@synthesize qWords;
@synthesize image;

+ (NSMutableArray*) getAllLanguages {
    if (allLanguages == nil)
//        [self requestAllLanguages]; // Load from web service. Check if there are new languages
//    if ([allLanguages count] == 0)
        [self loadLanguagesLocaly]; // Load from local path.
    return allLanguages;
}

+ (Language*) getLanguageAt: (int) key {
    return [[self getAllLanguages] objectAtIndex: key - 1];
}

+ (Language*) getLanguageforLocalization: (NSString*) loc {
    for (int i=0; i < [[self getAllLanguages] count]; i++) {
        Language *l = [allLanguages objectAtIndex: i];
        if ([l.code isEqualToString: loc]) return l;
    }
    return nil;
}

+(void) requestAllLanguages {
    NSURL *url =
    [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_select.php?rquest=allLangs", cUrlServer]];
    
    AFJSONRequestOperation *operation = [AFProxy prepareRequest: url delegate: self];
    [operation start];

}

// Response to allLangs
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    if ([self allImagesDownloaded: [response count]]) return;

    int langSelKey = [[[UserContext getUserSelected] langSelected] key];
    if (langSelKey == 0) langSelKey = 1; // First execution, there are not language selected. LangKey = 1 is English as default
    [[UserContext getUserSelected] setLangSelected: nil];

    [allLanguages removeAllObjects]; // since the request is asynchronous, could be load languages locally
    allLanguages = [[NSMutableArray alloc] init];
    //NSLog(@"Start Loading Languages !!!!!");
    
    for (NSDictionary* value in response) {
        Language *lang = [Language alloc];
        lang.key = [[value objectForKey: @"lang_id"] intValue];
        lang.name = [value objectForKey: @"lang_name"];
        lang.code = [value objectForKey: @"lang_code"];

        [self download: [self iconImageName: lang.name prefix: @""] setAnewLanguage: NO];
        [self download: [self iconImageName: lang.name prefix: @"@2x"] setAnewLanguage: UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad];
        [self download: [self iconImageName: lang.name prefix: @"@ipad"] setAnewLanguage: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad];

        [allLanguages addObject: lang];
    }
    
    [[UserContext getUserSelected] setLangSelected: [allLanguages objectAtIndex: langSelKey - 1]];
    //NSLog(@"Finish Loading Languages !!!!!");
    [self saveLanguagesLocaly];
    
}
    
// Response to allLangs
+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}

+ (bool) allImagesDownloaded: (int) qLangs {
    NSString *path = [self downloadDestinationPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    int qFiles = [[fm contentsOfDirectoryAtPath: path error: &err] count];
    return qLangs*3 == qFiles; // Each lang has IconEnglish.png, @2x.png and @ipad.png
}

+ (NSString*) iconImageName: (NSString*) fileName prefix: (NSString*) prefix {
    NSString *a = [NSString stringWithFormat: @"%@Flag%@.png", fileName, prefix];
    return a;
}

+ (NSString*) iconImageName: (NSString*) fileName {
    //NSString *a = [ImageManager getIphoneIpadFile: [NSString stringWithFormat: @"%@Flag", fileName]];
    NSString *a = [NSString stringWithFormat:@"%@.png", fileName];
    
    return a;
}

+ (BOOL) download: (NSString*) langArchive setAnewLanguage: (bool) setANewLang {
    
    // Set Source & Destination
    NSString *fullUrl =
    [NSString stringWithFormat: @"%@%@", @"http://www.vocabularytrip.com/Languages/", langArchive];
    NSString *destPath = [self checkIfDestinationPathExist];
    destPath = [NSString stringWithFormat: @"%@/%@", destPath, langArchive];
    
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath: destPath isDirectory: &isDir]) {
        // Start Download
        NSURL *url = [NSURL URLWithString: fullUrl];
        
        AFHTTPRequestOperation* operation = [AFProxy prepareDownload: url destination: destPath delegate: nil];
        //[operation waitUntilFinished];
        [operation start];
        
     }
    return YES;
}

+ (NSString*) downloadDestinationPath {
    return [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/Languages"];
}

+ (NSString*) checkIfDestinationPathExist {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    
    NSString *destPath = [self downloadDestinationPath];
    if (![fm fileExistsAtPath: destPath isDirectory: &isDir]) {
        NSError *err = nil;
        [fm createDirectoryAtPath: destPath withIntermediateDirectories: YES attributes: nil error: &err];
        //NSString *result = err.localizedDescription;
    }
    return destPath;
}

+ (void) initLanguagesLocaly {
    [[NSUserDefaults standardUserDefaults] setValue: cInitFirstLanguages forKey: cArrayLanguages];
    
    NSArray *tempLangs = [cInitFirstLanguages componentsSeparatedByString: @"-"];
    NSArray *tempOneLang;
    NSString *langName;
    for (int i=0; i < tempLangs.count; i++) {
        tempOneLang = [[tempLangs objectAtIndex: i] componentsSeparatedByString: @"|"];
        langName = [tempOneLang objectAtIndex: 1];
        [self copyImageToDestinationPath: langName ext: @".png"];
        [self copyImageToDestinationPath: langName ext: @"@2x.png"];
        [self copyImageToDestinationPath: langName ext: @"@ipad.png"];        
    }    
}    
 
+(void) copyImageToDestinationPath: (NSString *) langName ext: (NSString*) ext {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSString *destPath = [[NSString alloc] initWithFormat:@"%@/%@%@%@",
                          [self checkIfDestinationPathExist], langName, @"Flag", ext];	
    NSString *originPath = [[NSString alloc] initWithFormat:@"%@/%@%@%@", 
                            [[NSBundle mainBundle] resourcePath], langName, @"Flag", ext];	
    [fm copyItemAtPath: originPath toPath: destPath error: &error];
}

+ (void) saveLanguagesLocaly {
    NSMutableArray *tempLangs = [[NSMutableArray alloc] init];
    for (int i=0; i < allLanguages.count; i++) {
        Language *lang = [allLanguages objectAtIndex: i];
        NSString *temp = [NSString stringWithFormat: @"%i%@%@", lang.key, @"|", lang.name];
        [tempLangs addObject: temp];
    }
    [[NSUserDefaults standardUserDefaults] setValue: [tempLangs componentsJoinedByString: @"-"] forKey: cArrayLanguages];
}

+ (void) loadLanguagesLocaly {
	NSString *langs = cInitFirstLanguages;
    //[[NSUserDefaults standardUserDefaults] stringForKey: cArrayLanguages];
    NSArray *tempLangs = [langs componentsSeparatedByString: @"-"];
    NSArray *tempOneLang;
    allLanguages = [[NSMutableArray alloc] init];
    
    for (int i=0; i < tempLangs.count; i++) {
        tempOneLang = [[tempLangs objectAtIndex: i] componentsSeparatedByString: @"|"];
        Language *lang = [Language alloc];
        lang.key = [[tempOneLang objectAtIndex: 0] intValue];
        lang.name = [tempOneLang objectAtIndex: 1];
        [allLanguages addObject: lang];
    }
}

-(UIImage*) image {
	if (image == nil) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", [Language downloadDestinationPath], [Language iconImageName: name]];
        image = [UIImage alloc];
        if (![image initWithContentsOfFile: file]) {
            // Reload from assets
            image = [UIImage alloc];            
            file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],
                    //[UserContext getIphoneIpadFile: name]];              
                    [Language iconImageName: name]];	
            image = [image initWithContentsOfFile: file];
            image = [ImageManager imageWithImage: image scaledToSize: [ImageManager getFlagSize]];
        }
    }
	return image;
}

- (void) countOfWords {
    NSURL *url =
    [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_select.php?rquest=countOfWordsforLang", cUrlServer]];
    
    Language *lang = [UserContext getLanguageSelected];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt: lang.key], @"lang", nil];
    
    
    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    [operation start];
}

- (void) connectionFinishSuccesfully: (NSDictionary*) dict {
    qWords = [[dict objectForKey: @"qWords"] intValue];
}

- (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}

- (int) qWords {
/*    if (qWords == 0) {
        [self countOfWords];
        // ******** change 400 words - Pending
        // Se usa para validar si esta completo. No sirve lo leido
        return qWords; // count of words is asyncronic
    }

    return qWords;*/
    return 350;
}

@end