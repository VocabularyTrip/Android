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

+(PurchaseManager*) getSingleton {
	if (purchaseManagerSingleton == nil)
		purchaseManagerSingleton = [[PurchaseManager alloc] init];
	return purchaseManagerSingleton;
}

// **************************************
// ******** Purchase Framework **********

+ (void) buyDictionary {
	switch ([UserContext getMaxLevel]) {
		case 0 ... 2:
			[self buyBronzeLevel];
			break;
		case 3 ... 5:
			[self buySilverLevel];			
			break;
		case 6 ... 8:
			[self buyGoldLevel];			
			break;
		default:
			break;
	}
}

+ (void) buyBronzeLevel {
	[self buy: cPurchaseBronzeLevel];
}

+ (void) buySilverLevel {
	[self buy: cPurchaseSilverLevel];
}

+ (void) buyGoldLevel {
	[self buy: cPurchaseGoldLevel];
}

+ (void) buyAllLevels {
	[self buy: cPurchaseAllLevels];
}

+ (NSString*) getCompletePurchaseIdentier: (NSString*) inAppPurchase {
	//NSString *l = [[NSBundle mainBundle] objectForInfoDictionaryKey: cLanguage];
	return [NSString stringWithFormat: @"KLVocabulary_%@", inAppPurchase];
}

+ (void) buy: (NSString*) inAppPurchase {
    [TraceWS register: @"User request buy" valueStr: inAppPurchase valueNum: [NSNumber numberWithInt: 0]];    
    
	NSString *activeConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey: cActiveConfiguration];
	
	NSString *p = [self getCompletePurchaseIdentier: inAppPurchase];
	
	if ([activeConfig isEqualToString: @"Debug"]) {
		[[PurchaseManager getSingleton] provideContent: p];
		return;
	}
	
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier: p];
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
            //[PurchaseManager getCompletePurchaseIdentier: cPurchaseBronzeLevel],
            //[PurchaseManager getCompletePurchaseIdentier: cPurchaseSilverLevel],
            //[PurchaseManager getCompletePurchaseIdentier: cPurchaseGoldLevel],
                                 [PurchaseManager getCompletePurchaseIdentier: cPurchaseAllLevels],                                 
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
  	NSLog(@"Complete Transaction");  
	[self recordTransaction: transaction];
	[self provideContent: transaction.payment.productIdentifier];
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
	[self provideContent: transaction.originalTransaction.payment.productIdentifier];
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
        NSString *productID = transaction.payment.productIdentifier;
        [self provideContent: productID];
        //[purchasedItemIDs addObject:productID];
    }
    
    if (delegate) [delegate responseToBuyAction];
    
}

-(void) provideContent: (NSString*) productIdentifier {
// ******** change 400 words - Pending
// Reflotar las compras por segmento
    UserContext *user = [UserContext getSingleton];
	if ([productIdentifier rangeOfString: cPurchaseAllLevels].location != NSNotFound)
		[user setMaxLevel: cLastLevel];
	else if ([productIdentifier rangeOfString: cPurchaseBronzeLevel].location != NSNotFound) {
        if ([user maxLevel] < cBronzeLevel) [user setMaxLevel: cBronzeLevel];
	} else if ([productIdentifier rangeOfString: cPurchaseSilverLevel].location != NSNotFound) {
		if ([user maxLevel] < cSilverLevel)  [user setMaxLevel: cSilverLevel];
	} else if ([productIdentifier rangeOfString: cPurchaseGoldLevel].location != NSNotFound)
		[user setMaxLevel: cLastLevel];
    
	
    if (delegate) [delegate responseToBuyAction];
	//if ([UserContext nextLevel]) 	
	//	[Sentence playSpeaker: @"AppDelegate-ResponseToBuyAction-NextLevel"];

    /*if ([UserContext getSingleton].userSelected) {
        VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
        [vcDelegate startLoadingVocabulary];
    }*/
}



@end
