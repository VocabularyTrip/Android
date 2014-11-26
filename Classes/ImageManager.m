//
//  ImageManager.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/19/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (void) fitImage: (UIImage*) imageView inView: (UIView*) aView  {

	CGRect frame = aView.frame;
    
    if (imageView.size.width == 0) return;
    if (imageView.size.height == 0) return;
    
    if (imageView.size.height < imageView.size.width) {
        frame.size.height = imageView.size.height * aView.frame.size.width / imageView.size.width;
        frame.size.width = aView.frame.size.width;
        frame.origin.y = frame.origin.y + (aView.frame.size.height - frame.size.height) / 2;
    } else {
        frame.size.width = imageView.size.width * aView.frame.size.height / imageView.size.height;
        frame.size.height = aView.frame.size.height;
        frame.origin.x = frame.origin.x + (aView.frame.size.width - frame.size.width) / 2;
    }
    aView.frame = frame;
}

+ (void) fitImage: (UIImage*) imageView inImageView: (UIImageView*) aView  {
    [self fitImage: imageView inView: aView];
    [aView setImage: imageView];
}

+ (void) fitImage: (UIImage*) imageView inButton: (UIButton*) aButton  {
    [self fitImage: imageView inView: aButton];
    [aButton setImage: imageView forState: UIControlStateNormal];
}

+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (int) windowHeightXIB {
    // This size correspond to XIB design and return the same number on iphone 5, iphone 4
    // windowWidth return the real size and is diferent on iphone 5, iphone 5
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (int) windowWidthXIB {
    // This size correspond to XIB design and return the same number on iphone 5, iphone 4
    // windowWidth return the real size and is diferent on iphone 5, iphone 5
    return [[UIScreen mainScreen] bounds].size.height;
}

// ******************************************************************* //
// ********************* IMAGE SIZE DEFINITION *********************** //

+ (int) getMapViewLevelSize {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 160 : 62;
}

+ (CGSize) getFlagSize {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(300,300) : CGSizeMake(150,150);
}

+ (CGSize) getMapViewSize {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
    CGSizeMake(3497,2635) : CGSizeMake(1140, 858);
}

+ (CGSize) changeUserUserSize: (UIImage*)  u {
    int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 350 : 175;
    int newWitdh = height * u.size.width / u.size.height;
    CGSize newSize = CGSizeMake(newWitdh, height);
    return newSize;
}

// ********************* IMAGE SIZE DEFINITION *********************** //
// ******************************************************************* //

@end
