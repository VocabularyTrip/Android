//
//  ImageManger.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/19/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManger : NSObject

+ (void) adjustImage: (UIView*) imageView toSize: (int) aSize;
+ (void) adjustImage: (UIView*) imageView width: (int) aSize;
+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize;
+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize;
+ (UIImage *) imageWithName: (NSString *) imageName scaledToSize: (CGSize) newSize;

@end
