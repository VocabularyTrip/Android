//
//  PromoCode.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 10/5/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "PurchaseManager.h"
#import "PurchaseProtocol.h"

typedef enum  {
    PromoCodeUnknowError,
    PromoCodeDoseNotExists,
    PromoCodeAlreadyInUse,
    PromoCodeSuccessfully,
    PromoCodeRegistered
} PromoCodeResult;

#define cPromoCode @"promoCode"
#define cPromoCodeStatus @"promoCodeStatus"
#define cPromoCodeExpireDate @"promoCodeExpireDate"
#define cPromoCodeStatusActive @"Promo Code Active !"
#define cPromoCodeStatusFinished @"Promo Code Finished"

@interface PromoCode : NSObject <UIAlertViewDelegate> {
    int promoCodeId;
    NSString* __unsafe_unretained promoCode;
    NSString* __unsafe_unretained type;
    NSDate* __unsafe_unretained expireDate;
    BOOL claimed;
    NSString* __unsafe_unretained uuid;
    NSString* __unsafe_unretained sentTo;
	id <PurchaseDelegate> __unsafe_unretained delegate;    
}

extern PromoCode *promoCodeSingleton;

+(PromoCode*) getSingleton;

@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, assign) int promoCodeId;
@property (nonatomic, unsafe_unretained) NSString* promoCode;
@property (nonatomic, unsafe_unretained) NSString* type;
@property (nonatomic, unsafe_unretained) NSDate* expireDate;
@property (nonatomic, assign) BOOL claimed;
@property (nonatomic, unsafe_unretained) NSString* uuid;
@property (nonatomic, unsafe_unretained) NSString* sentTo;

+ (void) checkAPromoCodeForUUID;
+ (void) checkAPromoCodeForUUIDFinishSuccesfully: (NSDictionary*) response;
+ (void) checkAPromoCodeForUUIDFinishWidhError:(NSError *) error;
    
+ (void) registerPromoCode: (NSString*) promoCode;
+ (void) registerPromoCodeFinishSuccesfully: (NSDictionary*) response;
+ (void) registerPromoCodeFinishWidhError:(NSError *) error;
    
+ (void) claimPromoCode: (PromoCode*) aPromoCode;
+ (void) claimPromoCodeFinishSuccesfully: (NSDictionary*) response;
+ (void) claimPromoCodeFinishWidhError:(NSError *) error;
    
+ (void) answerPromoCodeResult: (NSString*) promoCodeResult;
+ (void) checkPromoCodeDueDate;

+ (NSDate*) dateOnly: (NSDate*) date;
+ (bool) isExpired: (NSDate*) date;

@end
