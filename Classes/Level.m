//
//  Level.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/13/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Level.h"
#import "UserContext.h"


@implementation Level

@synthesize imageLocked;
@synthesize imageNotAvailable;
@synthesize imageLockedName;
@synthesize imageNotAvailableName;
@synthesize levelName;

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
    
    for (NSDictionary* value in response) {
        if (singletonVocabulary.wasErrorAtDownload == 0) {
            [Word download: [value objectForKey: @"word_name"]];
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

/*+ (void)requestFailed: (NSError *) error
{
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}*/

-(UIImage*) imageLocked {
	if (imageLocked == nil) {
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [UserContext getIphoneIpadFile: imageLockedName]];		
        imageLocked = [UIImage alloc];
        imageLocked = [imageLocked initWithContentsOfFile: file];
    }
	return imageLocked;
}

-(UIImage*) imageNotAvailable {
	if (imageNotAvailable == nil) {
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [UserContext getIphoneIpadFile: imageNotAvailableName]];		
        imageNotAvailable = [UIImage alloc];
        imageNotAvailable = [imageNotAvailable initWithContentsOfFile: file];
    }
	return imageNotAvailable;
}

-(void) purge {
	imageLocked = nil;
	imageNotAvailable = nil;
}


@end
