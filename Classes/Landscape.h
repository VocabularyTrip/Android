//
//  Landscape.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageManager.h"

@interface Landscape : NSObject {
	UIImage *image;
	UIImage *sky;
	NSString* imageName;
	NSString* skyName;	
}

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *sky;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* skyName;

-(void) purge;
	
@end
