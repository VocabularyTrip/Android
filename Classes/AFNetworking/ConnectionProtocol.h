//
//  ConnectionProtocol.h
//  VocabularyTrip
//
//  Created by User on 2/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@protocol ConnectionDelegate <NSObject>

// Alternative with url to log it and know the request related
- (void) connectionFinishWidhError: (NSError*) error url: (NSURL *) url;

@required
   - (void) connectionFinishWidhError: (NSError*) error;
   - (void) connectionFinishSuccesfully: (NSDictionary*) dict;
@end



@interface ConnectionProtocol : NSObject
{
	id <ConnectionDelegate> delegate;
}

@property (retain) id delegate;

@end

