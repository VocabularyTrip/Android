//
//  FacebookManager.h
//  VocabularyTrip
//
//  Created by Ariel on 11/19/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PromoCode.h"
#import "TraceWS.h"

#define APP_HANDLED_URL @"APP_HANDLED_URL"

enum {
    tFacebookSuccessful = 0, // d
    tFacebookError    = 1,    //
    tFacebookAborted    = 2,    //
    tFacebookNotFacebookApp     = 3 // Facebook App is not present in the device.
}; typedef NSUInteger tfacebookResult;


@interface FacebookManager : NSObject {
    NSArray* listOfFriends;
}

extern FacebookManager *fbSingleton;

@property (nonatomic) NSArray* listOfFriends;

+ (FacebookManager*) getSingleton;
+ (void) initFacebookSession;
+ (void) facebookLogin;
+ (void) requestForMe;
+ (void) loadListOfFriends;
+ (void) requestWritePermissions;
+ (FBWebDialogHandler) getStandardResultHandler;
+ (void) inviteAFriend; //
+ (tfacebookResult) postFeedDialog: (int) playerFBID;

@end
