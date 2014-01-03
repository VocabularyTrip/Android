//
//  ImageManager.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/19/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define cWordImageSizeIphone 111

enum {
    UIDeviceResolution_Unknown           = 0,
    UIDeviceResolution_iPhoneStandard    = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina4    = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina5     = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard      = 4,    // iPad 1,2,mini Standard Display   (1024x768px)
    UIDeviceResolution_iPadRetina        = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

@interface ImageManager : NSObject

+ (void) fitImage: (UIImage*) imageView inView: (UIImageView*) aView;
+ (void) resizeImage: (UIImageView*) imageView toSize: (int) aSize;
+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize;
+ (NSString*) getIphoneIpadFile: (NSString*) imageFile;
+ (NSString*) getIphoneIpadFile: (NSString*) imageFile ext: (NSString*) ext;
+ (NSString*) getIphone5xIpadFile: (NSString*) imageFile;
+ (UIDeviceResolution)resolution;
+ (int) getDeltaWidthIphone5;
+ (int) windowWidth;

@end
