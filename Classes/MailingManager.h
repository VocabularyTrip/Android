//
//  MailingManager.h
//  VocabularyTrip
//
//  Created by User on 2/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"

@interface MailingManager : NSObject <NSURLConnectionDelegate>

+(void) sendMail: (NSString*) message to: (NSString*) mailT;
+ (void) connectionFinishSuccesfully: (NSDictionary*) response;
+ (void) requestFailed: (NSError *) error;

@end
