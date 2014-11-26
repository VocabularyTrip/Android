//
//  DownloadProtocol.h
//  VocabularyTrip
//
//  Created by User on 2/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DownloadDelegate <NSObject>
@required
    - (void) downloadFinishWidhError: (NSString*) error;
    - (void) downloadFinishSuccesfully;
    - (void) addProgress: (float) aProgress;
@end

@interface DownloadProtocol : NSObject 
{
	id <DownloadDelegate> dDelegate;
}

@property (retain) id dDelegate;

@end

