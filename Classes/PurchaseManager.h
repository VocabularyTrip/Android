//
//  PurchaseManager.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/28/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PurchaseProtocol.h"
#import "UserContext.h"

#define cPurchaseSet1 @"PurchaseSet1"
#define cPurchaseSet2 @"PurchaseSet2"
#define cPurchaseSet3 @"PurchaseSet3"
#define cPurchaseSet4 @"PurchaseSet4"
#define cPurchaseSet1to4 @"PurchaseSet1to4"
#define cPurchaseSet2to4 @"PurchaseSet2to4"

/*#define cPurchaseBronzeLevel @"BronzeLevel"
#define cPurchaseSilverLevel @"SilverLevel"
#define cPurchaseGoldLevel @"GoldLevel"
#define cPurchaseAllLevels @"BSG"*/

#define cInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification" 

#define cLanguage @"Language"
#define cActiveConfiguration @"Active Configuration"

@interface PurchaseManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate > {
    SKProductsRequest *productsRequest;
	id <PurchaseDelegate> __unsafe_unretained delegate;
    NSMutableArray *products;
}

extern PurchaseManager *purchaseManagerSingleton;

@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic) NSMutableArray *products;

+ (PurchaseManager*) getSingleton;
+ (NSString*) getCompletePurchaseIdentier: (NSString*) inAppPurchase;
//+ (void) buyDictionary;
/*+ (void) buyBronzeLevel;
+ (void) buySilverLevel;
+ (void) buyGoldLevel;*/
+ (void) buyNextSetOfLevel; // Buy Set 1, Set 2, Set 3 depending the context
+ (void) buyAllLevels;
+ (void) buy: (SKProduct*) anSKProduct;
+ (SKProduct*) getProductoFromIdentifier: (NSString*) productIdentifier;
- (void) initializeObserver;
- (void) paymentQueue: (SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) completeTransaction: (SKPaymentTransaction*) transaction;
- (void) faildTransaction: (SKPaymentTransaction*) transaction;
- (void) restoreTransaction: (SKPaymentTransaction*) transaction;
- (void) recordTransaction: (SKPaymentTransaction*) transaction;
- (void) provideContent: (SKProduct*) anSKProduct;
- (void) requestProUpgradeProductData;
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (IBAction) showErrorMessage: (NSString*) aMessage;
- (void) checkPurchasedItems;

    
@end
