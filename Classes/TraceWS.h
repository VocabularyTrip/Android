//
//  TraceWS.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/27/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"

@interface TraceWS : NSObject <NSURLConnectionDelegate>

+(void) register: (NSString*) key valueStr: (NSString*) valueStr valueNum: (NSNumber*) valueNum; 
   
@end
