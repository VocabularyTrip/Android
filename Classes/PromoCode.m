//
//  PromoCode.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 10/5/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "PromoCode.h"
#import "VocabularyTrip2AppDelegate.h"

PromoCode *promoCodeSingleton;

@implementation PromoCode

@synthesize promoCodeId;
@synthesize promoCode;
@synthesize type;
@synthesize expireDate;
@synthesize claimed;
@synthesize uuid;
@synthesize sentTo;
@synthesize delegate;

+(PromoCode*) getSingleton {
	if (promoCodeSingleton == nil)
		promoCodeSingleton = [[PromoCode alloc] init];
	return promoCodeSingleton;
}

// This method is called by facebook post. No promo code required
+ (void) giveAccessForOneDay {
    NSDate *oneDay = [[NSDate alloc] init];
    oneDay = [oneDay dateByAddingTimeInterval: 60*60*24]; // 1 day
    [[NSUserDefaults standardUserDefaults] setObject: oneDay forKey: cPromoCodeExpireDate];
    [[PurchaseManager getSingleton] provideContent:
     [PurchaseManager getProductoFromIdentifier: cPurchaseSet1to4]]; // Provide Content !!!!!
}

+ (void) checkAPromoCodeForUUID {
    if ([UserContext getMaxLevel] >= cSet3OfLevels) return;
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_promo_code.php?rquest=getPromoCodeForUUID", cUrlServer]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [UserContext getUUID], @"uuid",
                          nil];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL: url];

    NSMutableURLRequest *jsonRequest =
    [httpClient requestWithMethod: @"POST" path: [url  absoluteString] parameters: dict];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:
       jsonRequest success:
       ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
           NSDictionary *jsonDictionary = JSON;
           [self checkAPromoCodeForUUIDFinishSuccesfully: jsonDictionary];
       } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
           [self checkAPromoCodeForUUIDFinishWidhError: error];
    }];

    //operation.JSONReadingOptions = NSJSONReadingAllowFragments;
    [operation start];
}

+ (void) checkAPromoCodeForUUIDFinishSuccesfully: (NSDictionary*) response {
    NSDate* date;
    
    if ([response count] == 0) return; // the promoCode doesn't exists
    
    if ([response count] > 0) {
        PromoCode* aPromoCode = [[PromoCode alloc] init];
        for (NSDictionary* value in response) {
            aPromoCode.promoCode = [value objectForKey:@"promo_code"];
        
            aPromoCode.type = [value objectForKey:@"promo_code_type"];
            if ([aPromoCode.type isEqualToString: @"Expire"]) {
                NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
                [dateF setDateFormat: @"yyyy-MM-dd"];
                NSString* dateS = [value objectForKey:@"promo_code_expire_date"];

                if ((NSNull*) dateS == [NSNull null]) {
                    date = [[NSDate alloc] init];
                    date = [date dateByAddingTimeInterval: 60*60*24]; // 1 day
                } else
                    date = [dateF dateFromString: dateS];
                aPromoCode.expireDate = date;
            }
            aPromoCode.uuid = [value objectForKey:@"promo_code_uuid"];
            aPromoCode.claimed = [[value objectForKey: @"promo_code_claimed"] boolValue];

            // Not Expire or ExpireDate is future
            
            if (![aPromoCode.type isEqualToString: @"Expire"] ||
                ((aPromoCode.expireDate != (id)[NSNull null]) &&
                ![self isExpired: date]))
                    [self claimPromoCode: aPromoCode];
            return;
        }
    }
}

+ (void) checkAPromoCodeForUUIDFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    NSLog(@"%@", result);
}

+ (void) answerPromoCodeResult: (NSString*) promoCodeResult {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Promo Code Result"
            message: promoCodeResult
            delegate: self
            cancelButtonTitle: @"OK"
            otherButtonTitles: nil];
        [alert show];
}

+ (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: // OK
            if (promoCodeSingleton.delegate && [UserContext getMaxLevel] >= cSet3OfLevels)
                [promoCodeSingleton.delegate responseToBuyAction];
            break;
        default:
            break;
    }
}

+ (void) registerPromoCode: (NSString*) promoCode {

    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_promo_code.php?rquest=getPromoCodeStatus", cUrlServer]];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          promoCode, @"promo_code",
                          nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL: url];
    
    NSMutableURLRequest *jsonRequest =
    [httpClient requestWithMethod: @"POST" path: [url  absoluteString] parameters: dict];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:
       jsonRequest success:
       ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
           NSDictionary *jsonDictionary = JSON;
           [self registerPromoCodeFinishSuccesfully: jsonDictionary];
       } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
           [self registerPromoCodeFinishWidhError: error];
    }];

    
    [operation start];
}

+ (void) registerPromoCodeFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    [self answerPromoCodeResult: result];
    NSLog(@"%@", result);
}

+ (void) registerPromoCodeFinishSuccesfully: (NSDictionary*) response {
    
    if ([response count] == 0) {
        [self answerPromoCodeResult: @"Promo Code does NOT exist. Please make sure you entered it correctly"];
        return; // PromoCodeDoseNotExists; // the promoCode doesn't exists
    }
    
    for (NSDictionary* value in response) {
        PromoCode* aPromoCode = [[PromoCode alloc] init];
        aPromoCode.promoCode = [value objectForKey:@"promo_code"];
        
        NSString *promoCodeExpireDateStr = [value objectForKey:@"promo_code_expire_date"];

        if (promoCodeExpireDateStr != (id)[NSNull null]) {
            NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
            [dateF setDateFormat: @"yyyy-MM-dd"];
            NSDate* date = [dateF dateFromString: promoCodeExpireDateStr];
            aPromoCode.expireDate = date;
        }
        aPromoCode.claimed = [[value objectForKey: @"promo_code_claimed"] boolValue];
        [self claimPromoCode: aPromoCode];
    }
}

+ (void) claimPromoCode: (PromoCode*) aPromoCode {
    
    if (aPromoCode.expireDate != (id)[NSNull null] && aPromoCode.expireDate != nil) {
        //if ([aPromoCode.expireDate compare: [NSDate date]] == NSOrderedDescending) {
        if (![self isExpired: aPromoCode.expireDate]) {
            [[NSUserDefaults standardUserDefaults] 
             setObject: aPromoCode.expireDate forKey: cPromoCodeExpireDate];
        } else {
           [self answerPromoCodeResult: @"Registering an expired promo code"];
            return;
        }
    }
    
    // ClaimPromoCode could be called from two origins:
    //      1. User insert a promo code and request. In this case uuid is null.
    //      2. The promo code was inserted by VocabularyTrip v2 and the uuid is not null
    //      In the second case is not important if was claimed (the authentication falls in uuid)
    //      Other use case, is the application was uninstalled and installed again.
    //      In this case if the uuid is the same is allowed to register.
    
    if (![aPromoCode.uuid isEqualToString: [UserContext getUUID]]
        && aPromoCode.claimed) {
        [self answerPromoCodeResult: @"This Promo Code is already in use"];
        return; // PromoCodeAlreadyInUse; // The promoCode was Claimed
    }

    // The promoCode exists and is available
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/db_promo_code.php?rquest=claimPromoCodeAvailable", cUrlServer]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          aPromoCode.promoCode, @"promoCode",
                          [UserContext getUUID], @"uuid",
                          nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL: url];
    
    NSMutableURLRequest *jsonRequest =
    [httpClient requestWithMethod: @"POST" path: [url  absoluteString] parameters: dict];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:
       jsonRequest success:  ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       NSDictionary *jsonDictionary = JSON;
       [self claimPromoCodeFinishSuccesfully: jsonDictionary];
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
       [self claimPromoCodeFinishWidhError: error];
    }];
    
    [operation start];
}

+ (void) claimPromoCodeFinishWidhError:(NSError *) error {
    NSString *result = error.localizedDescription;
    [self answerPromoCodeResult: result];
    NSLog(@"%@", result);
}

+ (void) claimPromoCodeFinishSuccesfully: (NSDictionary*) response {
    NSString *result = [response objectForKey: @"status"];
    if ([result isEqualToString: @"Success"]) {
        [[NSUserDefaults standardUserDefaults] setObject: cPromoCodeStatusActive forKey: cPromoCodeStatus];
        [[NSUserDefaults standardUserDefaults] setObject: [response objectForKey: @"promoCode"] forKey: cPromoCode];
        
        [[PurchaseManager getSingleton] provideContent: [PurchaseManager getProductoFromIdentifier: cPurchaseSet1to4]]; // Provide Content !!!!!
        //if (promoCodeSingleton.delegate) [promoCodeSingleton.delegate responseToBuyAction];
        [self answerPromoCodeResult: @"Promo Code Registered Successfully"];        
    }
}

+(NSDate*) dateOnly: (NSDate*) date {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate: date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

+(bool) isExpired: (NSDate*) date {
    date = [self dateOnly: date];
    NSDate *today = [self dateOnly: [NSDate date]];
    return !([date compare: today] == NSOrderedDescending);
}

+(void) checkPromoCodeDueDate {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSDate *date = [pref objectForKey: cPromoCodeExpireDate];
    if (date) {
        date = [self dateOnly: date];
        
        NSString *message;
        if (date && [self isExpired: date]) {
            [[UserContext getSingleton] setMaxLevel: 0];
            [pref removeObjectForKey: cPromoCodeExpireDate];
            [pref synchronize];
            message = cPromoCodeStatusFinished;
            
            VocabularyTrip2AppDelegate *vcDelegate;
            vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
            [vcDelegate pushPurchaseView];
            
        } else {
            NSDate *today = [self dateOnly: [NSDate date]];
            int days = [date timeIntervalSinceDate: today] / 86400;
            NSString *dayDesc = days == 1 ? @"day" : @"days";
            message = [NSString stringWithFormat: @"You have access to full content for %i %@", days, dayDesc];
        }
        [pref setObject: message forKey: cPromoCodeStatus];
        
        /*UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: cNotifyToPromoCodeLimited
                              message: message
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
        [alert show];*/
    }
}

@end
