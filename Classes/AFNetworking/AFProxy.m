//
//  AFProxy.m
//  VocabularyTrip
//
//  Created by Ariel on 3/15/13.
//
//

#import "AFProxy.h"
#import "Reachability.h"

@implementation AFProxy

+ (AFJSONRequestOperation*) prepareRequest: (NSURL *) url delegate: (id) delegate {
    
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL: url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:
    jsonRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *jsonDictionary = JSON;
        if (delegate) [delegate connectionFinishSuccesfully: jsonDictionary];
    }
    failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
        if (delegate) [delegate connectionFinishWidhError: error];
    }];
    
    return operation;
}

+ (AFJSONRequestOperation*) preparePostRequest: (NSURL *) url param: (NSDictionary*) dict delegate: (id) delegate {
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL: url];
    
    [httpClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusReachableViaWWAN ||
            status == AFNetworkReachabilityStatusReachableViaWiFi )
            NSLog(@"connection");
        else {
            //NSLog(@"fail");
            if (delegate) [delegate connectionFinishWidhError: nil];
        }
    }];
    
    NSMutableURLRequest *jsonRequest =
    [httpClient requestWithMethod: @"POST" path: [url  absoluteString] parameters: dict];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:
       jsonRequest success:
       ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
           NSDictionary *jsonDictionary = JSON;
           if (delegate) [delegate connectionFinishSuccesfully: jsonDictionary];
       } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
           if (delegate) [delegate connectionFinishWidhError: error];
       }];
    
    return operation;
}

+ (AFHTTPRequestOperation*) prepareDownload: (NSURL *) url destination: (NSString*) destinPath delegate: (id) delegate {

    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest: request];

    downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath: destinPath append:NO];

    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (delegate) [delegate connectionFinishSuccesfully: nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (delegate) [delegate connectionFinishWidhError: error url: url];
    }];

    return downloadOperation;

}


@end
