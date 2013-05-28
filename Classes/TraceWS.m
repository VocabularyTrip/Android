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
                          [[UIDevice currentDevice] uniqueIdentifier], @"uuid",
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

@end
