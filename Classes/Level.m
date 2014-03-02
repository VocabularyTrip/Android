//
//  Level.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/13/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Level.h"
#import "ImageManager.h"
#import "UserContext.h"

@implementation Level

//@synthesize imageLocked;
//@synthesize imageNotAvailable;
//@synthesize imageLockedName;
//@synthesize imageNotAvailableName;
@synthesize levelName;
@synthesize size;
@synthesize ipodPlaceInMap;
@synthesize ipadPlaceInMap;
@synthesize levelNumber;


- (CGPoint) placeinMap {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? ipadPlaceInMap : ipodPlaceInMap;
}

+ (void)loadDataFromSql: (int) levelId {
    
    NSURL *url =
    [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_select.php?rquest=getWordsforLevelAndLang", cUrlServer]];
    
    Language *lang = [UserContext getLanguageSelected];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt: levelId], @"level",
                          [NSNumber numberWithInt: lang.key], @"lang",
                          nil];
    
    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    
    [operation start];
}

// Response to getWordsforLevelAndLang
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    Word *aWord = [Word alloc];
    
    for (NSDictionary* value in response) {
        if (singletonVocabulary.wasErrorAtDownload == 0) {
            [Word download: [value objectForKey: @"file_name"]];
            aWord.name = [value objectForKey: @"word_name"];
            aWord.allTranslatedNames = nil;
            [aWord addTranslation: [value objectForKey: @"translation"] forKey: [value objectForKey: @"lang_name"]];
            
        } else {
            NSLog(@"Word %@ aborted", [value objectForKey: @"word_name"]);
        }
    }
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
    singletonVocabulary.isDownloading = NO;
    if (singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate downloadFinishWidhError: result];
}

@end
