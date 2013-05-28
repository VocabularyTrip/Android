//
//  AlbumPage.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 12/14/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "AlbumPage.h"


@implementation AlbumPage

@synthesize figurines;

-(id) init {
    if (self=[super init]) 
        figurines = [[NSMutableArray alloc] init];
	return self;
}

-(NSMutableArray*) figurines {
	return figurines;
}

-(void) addFigurine:(Figurine *) fig {
    [figurines addObject: fig];
}

-(void) dealloc {
	
	if (figurines) {
		[figurines removeAllObjects];
		figurines = nil;
	}
}

@end
