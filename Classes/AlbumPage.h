//
//  AlbumPage.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 12/14/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figurine.h"

@interface AlbumPage : NSObject {
	NSMutableArray *figurines; 
}

@property (nonatomic) NSMutableArray *figurines;

-(id) init;
-(void) addFigurine: (Figurine *) fig;

@end
