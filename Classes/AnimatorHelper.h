//
//  AnimatorHelper
//  VocabularyTrip
//
//  Created by Ariel on 11/11/13.
//
//

#import <Foundation/Foundation.h>

@interface AnimatorHelper : NSObject

+ (void) avatarBlink: (UIImageView*) avatar;
+ (void) shakeView: (UIView*)itemView;
+ (void) avatarGreet: (UIImageView*) avatarView;
+ (void) avatarOk: (UIImageView*) avatarView;
+ (void) testI:(UIView*) itemView;

@end
