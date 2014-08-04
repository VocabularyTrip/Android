//
//  PurchaseManager.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/28/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "PurchaseManager.h"
#import "TraceWS.h"
#import "VocabularyTrip2AppDelegate.h"

PurchaseManager *purchaseManagerSingleton;

@implementation PurchaseManager

@synthesize delegate;
@synthesize products;

+ (PurchaseManager*) getSingleton {
	if (purchaseManagerSingleton == nil)
		purchaseManagerSingleton = [[PurchaseManager alloc] init];
	return purchaseManagerSingleton;
}

// **************************************
// ******** Purchase Framework **********

+ (SKProduct*) getProductoFromIdentifier: (NSString*) productIdentifier {
    NSMutableArray *allProducts = [self getSingleton].products;
    SKProduct *p;
    for (int i=0; i< [allProducts count]; i++) {
        p = [allProducts objectAtIndex: i];
        if ([p.productIdentifier rangeOfString: productIdentifier].location != NSNotFound)
            return p;
    }
    return nil;
}

+ (NSString*) getPriceAsText: (SKProduct*) p {
    if (!p) return  @"---";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale: p.priceLocale];
    return [formatter stringFromNumber: p.price];
}

/* + (NSString*) priceAsString: (NSNumber*) price {
   NSString * cPurchase = [self getCompletePurchaseIdentier: purchase];
    for (SKProduct *oneProduct in [PurchaseManager getSingleton].products) {
        NSLog(@"Product: %@, %@, %@, %@", oneProduct.productIdentifier, oneProduct.description, oneProduct.localizedDescription, oneProduct.localizedTitle);

        if ([oneProduct.productIdentifier isEqualToString: cPurchase]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setLocale: oneProduct.priceLocale];
            return [formatter stringFromNumber: oneProduct.price];
        }
    }
    return @"";
    
}*/

+ (NSString*) getPurchaseOneSet {
    if ([UserContext getMaxLevel] < cSet1OfLevels) {
        return cPurchaseSet1;
    } else if ([UserContext getMaxLevel] < cSet2OfLevels) {
        return cPurchaseSet2;
    } else if ([UserContext getMaxLevel] < cSet3OfLevels) {
        return cPurchaseSet3;
    } else if ([UserContext getMaxLevel] < cSet4OfLevels)
        return cPurchaseSet4;
    return @"Error"; // Error
}

+ (NSString*) getPurchaseAllSet {
    if ([UserContext getMaxLevel] < cSet1OfLevels) {
        return cPurchaseSet1to4;
    } else if ([UserContext getMaxLevel] < cSet2OfLevels)
        return cPurchaseSet2to4;
    return @"Error"; // Error
}

+ (void) buyNextSetOfLevel {
    /*
     #define cSet1OfLevels 12
     #define cSet2OfLevels 24
     #define cSet3OfLevels 36
     #define cSet4OfLevels 50*/
    //NSLog(@"MaxLevel: %i", [UserContext getMaxLevel]);
    
    [self buy: [self getProductoFromIdentifier: [self getPurchaseOneSet]]];
}

+ (void) buyAllLevels {
    
    [self buy: [self getProductoFromIdentifier: [self getPurchaseAllSet]]];
    
/*	switch ([UserContext getMaxLevel]) {
		case 0 ... 120:
           [self buy: [self getProductoFromIdentifier: cPurchaseSet1to4]];
			break;
		default:
           [self buy: [self getProductoFromIdentifier: cPurchaseSet2to4]];
			break;
    }*/
}

+ (NSString*) getCompletePurchaseIdentier: (NSString*) inAppPurchase {
	//NSString *l = [[NSBundle mainBundle] objectForInfoDictionaryKey: cLanguage];
	return [NSString stringWithFormat: @"KLVocabulary_%@", inAppPurchase];
}

   
+ (void) buy: (SKProduct*) anSKProduct {
    [TraceWS register: @"User request buy" valueStr: anSKProduct.productIdentifier valueNum: [NSNumber numberWithInt: 0]];
    
	NSString *activeConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey: cActiveConfiguration];
	
	//NSString *p = [self getCompletePurchaseIdentier: inAppPurchase];
	
	if ([activeConfig isEqualToString: @"Debug"]) {
		[[PurchaseManager getSingleton] provideContent: anSKProduct];
		return;
	}
	
	if ([SKPaymentQueue canMakePayments])
	{
		//SKPayment *payment = [SKPayment paymentWithProductIdentifier: p];
		SKPayment *payment = [SKPayment paymentWithProduct: anSKProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle: @"Purchase" 
							  message: @"Not available. Parental control activated" 
							  delegate: self 
							  cancelButtonTitle: @"OK" 
							  otherButtonTitles: nil];	
		[alert show];
	}
}

- (void) initializeObserver {
	[[SKPaymentQueue defaultQueue] addTransactionObserver: self];
	if ([SKPaymentQueue canMakePayments])
		[self requestProUpgradeProductData];
}

- (void)requestProUpgradeProductData
{
	//NSString *l = [[NSBundle mainBundle] objectForInfoDictionaryKey: cLanguage];
	
    NSSet *productIdentifiers = [NSSet setWithObjects: 
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet1],
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet2],
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet3],
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet4],
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet1to4],
            [PurchaseManager getCompletePurchaseIdentier: cPurchaseSet2to4],
			nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    products = [response.products copy];
    for (SKProduct *oneProduct in products)
        if (oneProduct)
        {
            NSLog(@"Product title: %@" , oneProduct.localizedTitle);
            NSLog(@"Product description: %@" , oneProduct.localizedDescription);
            NSLog(@"Product price: %@" , oneProduct.price);
            NSLog(@"Product id: %@" , oneProduct.productIdentifier);
            NSLog(@" ");
        }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: cInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
} 

- (void)request:(SKProductsRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"SKProductRequest error: %@", error.description);
}

- (void)paymentQueue: (SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased:
				// take action to purchase the feature
				[self completeTransaction: transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self faildTransaction: transaction];
				break;
			case SKPaymentTransactionStateRestored:
				// take action to restore the app as if it was purchased
				[self restoreTransaction: transaction];
			default:
				break;
		}
	}
}

-(void) completeTransaction: (SKPaymentTransaction*) transaction {
  	//NSLog(@"Complete Transaction");
	[self recordTransaction: transaction];
	[self provideContent: [PurchaseManager getProductoFromIdentifier:
                           transaction.payment.productIdentifier]];
	// Remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) faildTransaction: (SKPaymentTransaction*) transaction {
	if (transaction.error.code != SKErrorPaymentCancelled) {
		NSString* a = [transaction.error description];
        [self showErrorMessage: a];
		// Optionally, display an error here.
	}
	// take action to display some error message
    
	// Remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	if (delegate) [delegate responseToCancelAction];	
}


- (IBAction) showErrorMessage: (NSString*) aMessage {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle: @"Error" 
						  message: aMessage
						  delegate: self 
						  cancelButtonTitle: @"OK"
						  otherButtonTitles: nil];	
	[alert show];
}


-(void) restoreTransaction: (SKPaymentTransaction*) transaction {
	[self recordTransaction: transaction];
	[self provideContent: [PurchaseManager getProductoFromIdentifier:
                           transaction.payment.productIdentifier]];
	// Remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) recordTransaction: (SKPaymentTransaction*) transaction {
}


-(void) checkPurchasedItems
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


-(void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //purchasedItemIDs = [[NSMutableArray alloc] init];
    
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        //NSString *productID = transaction.payment.productIdentifier;
        [self provideContent: [PurchaseManager getProductoFromIdentifier:
                               transaction.payment.productIdentifier]];
        //[purchasedItemIDs addObject:productID];
    }
    
    if (delegate) [delegate responseToBuyAction];
    
}

-(void) provideContent: (SKProduct*) anSKProduct {
    
    UserContext *user = [UserContext getSingleton];
	if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet1to4].location != NSNotFound) {
        [user setMaxLevel: [Vocabulary countOfLevels]];
    } else if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet2to4].location != NSNotFound) {
		[user setMaxLevel: [Vocabulary countOfLevels]];
	} else if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet1].location != NSNotFound) {
        if ([user maxLevel] < cSet1OfLevels) [user setMaxLevel: cSet1OfLevels];
	} else if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet2].location != NSNotFound) {
		if ([user maxLevel] < cSet2OfLevels)  [user setMaxLevel: cSet2OfLevels];
	} else if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet3].location != NSNotFound) {
		if ([user maxLevel] < cSet3OfLevels)  [user setMaxLevel: cSet3OfLevels];
	} else if ([anSKProduct.productIdentifier rangeOfString: cPurchaseSet4].location != NSNotFound)
		if ([user maxLevel] < cSet4OfLevels)  [user setMaxLevel: cSet4OfLevels];
    
    if (delegate) [delegate responseToBuyAction];
	
    //if ([UserContext nextLevel])
	//	[Sentence playSpeaker: @"AppDelegate-ResponseToBuyAction-NextLevel"];

    /*if ([UserContext getSingleton].userSelected) {
        VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
        [vcDelegate startLoadingVocabulary];
    }*/
}



@end
