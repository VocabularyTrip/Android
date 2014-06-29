//
//  FacebookManager.m
//  VocabularyTrip
//
//  Created by Ariel on 11/19/13.
//
//

#import "FacebookManager.h"

FacebookManager *fbSingleton;

@implementation FacebookManager

@synthesize listOfFriends;

+ (FacebookManager*) getSingleton {
    if (!fbSingleton)
        fbSingleton = [[FacebookManager alloc] init];
    return fbSingleton;
}


+ (void) initFacebookSession {
    FBSession* session = [[FBSession alloc] init];
    [FBSession setActiveSession: session];
}

+ (void) facebookLogin {
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"email", nil];
    
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:true completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        // Did something go wrong during login? I.e. did the user cancel?
        if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening) {
            // If so, just send them round the loop again
            [[FBSession activeSession] closeAndClearTokenInformation];
            [FBSession setActiveSession:nil];
            [self initFacebookSession];
        } else {
            // Ready and Logged in !!!
        }
    }];
}

+ (void) requestForMe {
    [[FBRequest requestForMe]
     startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
     {
         // Did everything come back okay with no errors?
         if (!error && result)
         {
             // If so we can extract out the player's Facebook ID and first name
             //m_uPlayerFBID = [result.id longLongValue];
             NSString* firstName = [[NSString alloc] initWithString:result.first_name];
             NSLog(@"First Name: %@", firstName);
             
             // Create a texture from the user's profile picture
             //m_pUserTexture = new System::TextureResource();
             //m_pUserTexture->CreateFromFBID(m_uPlayerFBID, 128, 128);
         }
     }];
}

+ (void) loadListOfFriends {
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *fetchedFriendData;
            if (!error && result) {
                fetchedFriendData = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
                [self getSingleton].listOfFriends = fetchedFriendData;
            
                // Just for test
                /*NSDictionary *friendData = [fetchedFriendData objectAtIndex: arc4random() % fetchedFriendData.count];
             
                 NSString *friendId = [friendData objectForKey:@"id"];
                 NSString *friendName = [friendData objectForKey:@"name"];
                 NSLog(@"friend ID: %@, Name: %@", friendId, friendName);*/
            }
        }
    ];
}

+ (void) requestWritePermissions {
    // We need to request write permissions from Facebook
    bool bHaveRequestedPublishPermissions = ([FBSession.activeSession.permissions indexOfObject: @"publish_actions"] == NSNotFound);
    
    if (!bHaveRequestedPublishPermissions)
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects: @"publish_actions", nil];
        
        [[FBSession activeSession] requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            NSLog(@"Reauthorized with publish permissions.");
        }];

        bHaveRequestedPublishPermissions = true;
    }
}

+ (FBWebDialogHandler) getStandardResultHandler {
    return ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                NSLog(@"Request Sent.");
            }
        }
    };
}

/*+ (void) popupMessage: (UIViewController*) aViewController {
    FBShareDialogParams *shareParams = [[FBShareDialogParams alloc] init];
    if ([FBDialogs canPresentShareDialogWithParams: shareParams]) {
        [FBDialogs presentOSIntegratedShareDialogModallyFrom: aViewController
            initialText: @"Test"
            image: [UIImage imageNamed: @""]
            url: nil
            handler: [self getStandardResultHandler]
         ];
    }
}*/

+ (void) inviteAFriend {
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    /*NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
     // 2. Optionally provide a 'to' param to direct the request at
     @"286400088", @"to", // Ali
     nil];*/
    NSLog(@"Invite a Friend");

    [FBWebDialogs presentRequestsDialogModallyWithSession: [FBSession activeSession]
        message: [NSString stringWithFormat:@"Play this game..."]
        title: nil
        parameters: params
        handler: [self getStandardResultHandler]
     ];
}

+ (tfacebookResult) postFeedDialog: (int) playerFBID {

    // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
    // It will attemnt to use the Facebook Native Share dialog
    // If that's not supported we'll fall back to the web based dialog.

    NSString *linkURL = [NSString stringWithFormat:@"https://itunes.apple.com/US/app/id683626437"];
    NSString *pictureURL = @"http://www.vocabularytrip.com/IconsLogo/Icon@2x.png";

    // Prepare the native share dialog parameters
    FBShareDialogParams *shareParams = [[FBShareDialogParams alloc] init];
    shareParams.link = [NSURL URLWithString:linkURL];
    shareParams.name = @"Checkout Kids Learn Vocabulary !";
    shareParams.caption = @"Its great!";
    shareParams.picture = [NSURL URLWithString: pictureURL];
    shareParams.description =
    [NSString stringWithFormat:@"It's the perfecto tool to..."];

    if ([FBDialogs canPresentShareDialogWithParams: shareParams]) {
        [FBDialogs presentShareDialogWithParams: shareParams
            clientState: nil
            handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                NSString *result;
                if (error) {
                    result = @"Error publishing story.";
                } else if (results[@"completionGesture"] && [results[@"completionGesture"] isEqualToString:@"cancel"]) {
                    result = @"User canceled story publishing.";
                } else {
                    result = @"Story published.";
                    [[UserContext getSingleton] addPostInFacebook];
                    [PromoCode giveAccessForOneDay];
                }
                
                [TraceWS register: @"FacebookPostFeed" valueStr: result valueNum: [NSNumber numberWithInt: [[UserContext getSingleton]qPostInFacebook]]];
            }
         ];
        return tFacebookSuccessful;
    } else {
        return tFacebookNotFacebookApp;
        // We not use web dialog because is imposible to guarantee if the user made the post
        // We should give access just invoking
        
        /*
        NSLog(@"Use of FBWebDialogs");
        // Prepare the web dialog parameters
        NSDictionary *params = @{
                             @"name" : shareParams.name,
                             @"caption" : shareParams.caption,
                             @"description" : shareParams.description,
                             @"picture" : pictureURL,
                             @"link" : linkURL
                             };
    
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
              parameters:params
              handler: [self getStandardResultHandler]
        ];*/
    }
}

@end