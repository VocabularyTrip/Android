//
//  MailingManager.m
//  VocabularyTrip
//
//  Created by User on 2/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MailingManager.h"
#import "UserContext.h"

@implementation MailingManager

+(void) sendMail: (NSString*) message to: (NSString*) mailTo {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/mailing.php?rquest=sendMail", cUrlServer]];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          message, @"password", mailTo, @"mailTo", nil];

    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    [operation start];
}

// Response to getWordsforLevelAndLang
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    //for (NSDictionary* value in response) {
    //}
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}

@end
