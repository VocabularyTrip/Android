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
+ (void) shakeView: (UIView*) itemView delegate: (id) delegate;
+ (void) avatarGreet: (UIImageView*) avatarView;
+ (void) avatarOk: (UIImageView*) avatarView;
+ (void) scale: (UIView*) itemView from: (CGPoint) p1 to: (CGPoint) p2;
+ (void) rotateView: (UIView*) itemView;
+ (void) clickingView: (UIView*) itemView delegate: (id) delegate context: (NSNumber*) i;
+ (void) clickingView: (UIView*) itemView delegate: (id) delegate;
+ (void) releaseClickingView:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context;

@end
