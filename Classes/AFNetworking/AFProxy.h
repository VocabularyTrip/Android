//
//  AFProxy.h
//  VocabularyTrip
//
//  Created by Ariel on 3/15/13.
//
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ConnectionProtocol.h"


@interface AFProxy : NSObject

+ (AFJSONRequestOperation*) prepareRequest: (NSURL *) url delegate: (id) delegate;
+ (AFJSONRequestOperation*) preparePostRequest: (NSURL *) url param: (NSDictionary*) dict delegate: (id) delegate;
+ (AFHTTPRequestOperation*) prepareDownload: (NSURL *) url destination: (NSString*) destinPath delegate: (id) delegate;
//+ (bool) checkConnectivity;

@end
