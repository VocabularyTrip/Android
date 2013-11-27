//
//  FacebookManager.h
//  VocabularyTrip
//
//  Created by Ariel on 11/19/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define APP_HANDLED_URL @"APP_HANDLED_URL"

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
+ (void) postFeedDialog: (int) m_uPlayerFBID;

@end
