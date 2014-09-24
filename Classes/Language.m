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
@synthesize langOrder;

+ (NSMutableArray*) getAllLanguages {
    if (allLanguages == nil)
        [self loadLanguagesLocaly];
    return allLanguages;
}

+ (Language*) getLanguageAt: (int) i {
    return [[self getAllLanguages] objectAtIndex: i];
}

+ (Language*) getLanguageforLocalization: (NSString*) loc {
    for (int i=0; i < [[self getAllLanguages] count]; i++) {
        Language *l = [allLanguages objectAtIndex: i];
        if ([l.code isEqualToString: loc]) return l;
    }
    return nil;
}

+ (Language*) getLanguageforKey: (int) key {
    for (int i=0; i < [[self getAllLanguages] count]; i++) {
        Language *l = [allLanguages objectAtIndex: i];
        if (l.key == key) return l;
    }
    return nil;
}


/*+ (BOOL) download: (NSString*) langArchive setAnewLanguage: (bool) setANewLang {
    
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
}*/

/*+ (void) saveLanguagesLocaly {
    NSMutableArray *tempLangs = [[NSMutableArray alloc] init];
    for (int i=0; i < allLanguages.count; i++) {
        Language *lang = [allLanguages objectAtIndex: i];
        NSString *temp = [NSString stringWithFormat: @"%i%@%@", lang.key, @"|", lang.name];
        [tempLangs addObject: temp];
    }
    [[NSUserDefaults standardUserDefaults] setValue: [tempLangs componentsJoinedByString: @"-"] forKey: cArrayLanguages];
}*/

+ (void) loadLanguagesLocaly {
	NSString *langs = cInitFirstLanguages;
    NSArray *tempLangs = [langs componentsSeparatedByString: @"-"];
    NSArray *tempOneLang;
    allLanguages = [[NSMutableArray alloc] init];
    
    for (int i=0; i < tempLangs.count; i++) {
        tempOneLang = [[tempLangs objectAtIndex: i] componentsSeparatedByString: @"|"];
        Language *lang = [Language alloc];
        lang.key = [[tempOneLang objectAtIndex: 0] intValue];
        lang.name = [tempOneLang objectAtIndex: 1];
        lang.langOrder = i;
        [allLanguages addObject: lang];
    }
}

-(UIImage*) image {
	if (image == nil) {
        image = [UIImage imageNamed: name];
        image = [ImageManager imageWithImage: image scaledToSize: [ImageManager getFlagSize]];
    }
	return image;
}

- (int) qWords {
    return cDictionrySize;
}

@end