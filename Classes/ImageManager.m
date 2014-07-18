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
    //NSLog(@"Height: %f, Width: %f", imageView.size.height, imageView.size.width);
	CGRect frame = aView.frame;
    
    if (imageView.size.width == 0) return;
    if (imageView.size.height == 0) return;
    
    if (imageView.size.height < imageView.size.width) {
        frame.size.height = imageView.size.height * aView.frame.size.width / imageView.size.width;
        frame.size.width = aView.frame.size.width;
        frame.origin.y = frame.origin.y + (aView.frame.size.height - frame.size.height);
    } else {
        frame.size.width = imageView.size.width * aView.frame.size.height / imageView.size.height;
        frame.size.height = aView.frame.size.height;
        frame.origin.x = frame.origin.x + (aView.frame.size.width - frame.size.width) / 2;
        //NSLog(@"Word.x: %f, Width Original: %f, width: %f", frame.origin.x, aView.frame.size.width, frame.size.width);
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

/*+ (void) resizeImage: (UIImageView*) imageView toSize: (int) aSize  {
    if (aSize == 0) return;
    
	CGRect frame = imageView.frame;
    if (frame.size.height < frame.size.width) {
        frame.size.height = frame.size.height * aSize / frame.size.width;
        frame.size.width = aSize;
    } else {
        frame.size.width = frame.size.width * aSize / frame.size.height;
        frame.size.height = aSize;
    }
    imageView.frame = frame;
}*/

+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString*) getIphoneIpadFile: (NSString*) imageFile {
	return [self getIphoneIpadFile: imageFile ext: @"@ipad"];
}

+ (NSString*) getIphoneIpadFile: (NSString*) imageFile ext: (NSString*) ext {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		imageFile = [NSString stringWithFormat: @"%@%@", imageFile, ext];
	imageFile = [NSString stringWithFormat: @"%@.png", imageFile];
    return imageFile;
}

+ (NSString*) getIphone5xIpadFile: (NSString*) imageFile {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		imageFile = [NSString stringWithFormat: @"%@%@.png", imageFile, @"@ipad"];
    } else if ([self resolution] == UIDeviceResolution_iPhoneRetina5) {
        imageFile = [NSString stringWithFormat: @"%@%@.png", imageFile, @"@iphone5"];
    } else {
        imageFile = [NSString stringWithFormat: @"%@.png", imageFile];
    }
    return imageFile;
}

+ (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
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

+ (int) windowWidth {
    // This size correspond real size and is diferent on iphone 5, iphone 5
    // windowWidthXIB return the same size as XIB design. Return the same number on iphone 5, iphone 4

    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    return pixelHeight;

}

+ (int) getDeltaWidthIphone5 {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if ([self resolution] == UIDeviceResolution_iPhoneRetina5)
        return (pixelHeight - 1024)/2;
    else
        return 0;
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

+ (int) albumMagnifierDeltaPos {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 30 : 15;
}

+ (int) albumMagnifierSize {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 60;
}

+ (CGSize) changeUserUserSize {
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
    CGSizeMake(250, 350) : CGSizeMake(125, 175);
}

+ (CGRect) smokeViewInitRect {
    return CGRectMake(
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 86 : 45 + [ImageManager getDeltaWidthIphone5],
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 480 : 175,
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40 : 20,
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40 : 20);
}

+ (int) levelViewDeltaXYCorner {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 60;
}

// ********************* IMAGE SIZE DEFINITION *********************** //
// ******************************************************************* //

@end
