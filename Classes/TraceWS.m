//
//  TraceWS.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/27/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "TraceWS.h"
#import "UserContext.h"

@implementation TraceWS

+(void) register: (NSString*) key valueStr: (NSString*) valueStr valueNum: (NSNumber*) valueNum {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_trace.php?rquest=trace", cUrlServer]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          key, @"key",
                          valueStr, @"valueStr",
                          valueNum, @"valueNum",
                          [self getUUID], @"uuid",
                          nil];
    
    AFJSONRequestOperation *operation = [AFProxy preparePostRequest: url param: dict delegate: self];
    [operation start];
}

+ (void) connectionFinishSuccesfully: (NSDictionary*) dict {
}

+ (void) connectionFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}

+ (NSString*) getUUID {
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) { // iOS 6+
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {  // before iOS 6, so just generate an identifier and store it
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        uniqueIdentifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
    }
    return uniqueIdentifier;
}

@end
