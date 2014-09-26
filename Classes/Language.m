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
        [self initLanguages];
    return allLanguages;
}

+ (void) initLanguages {
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

- (UIImage*) image {
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