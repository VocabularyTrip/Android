//
//  PurchaseProtocol.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 1/20/12.
//  Copyright 2012 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol PurchaseProtocol
@protocol PurchaseDelegate <NSObject>
@required
- (void) responseToCancelAction;
- (void) responseToBuyAction;
@end

@interface ClassWithProtocol : NSObject 
{
	id <PurchaseDelegate> delegate;
}

@property (retain) id delegate;


@end
