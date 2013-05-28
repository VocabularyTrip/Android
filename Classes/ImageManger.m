//
//  ImageManger.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/19/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "ImageManger.h"

@implementation ImageManger


+(void) adjustImage: (UIView*) imageView toSize: (int) aSize {
	CGRect frame = imageView.frame;
	int originalWidth = frame.size.width;
	frame.size.width = aSize;
	frame.size.height = frame.size.height * aSize / originalWidth;
    imageView.frame = frame;    
}

+(void) adjustImage: (UIView*) imageView width: (int) aSize {
	CGRect frame = imageView.frame;
	frame.size.width = aSize;
    imageView.frame = frame;    
}

@end
