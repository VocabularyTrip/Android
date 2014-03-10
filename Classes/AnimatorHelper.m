//
//  AvatarAnimator.m
//  VocabularyTrip
//
//  Created by Ariel on 11/11/13.
//
//

#import "AnimatorHelper.h"
#import "User.h"
#import "UserContext.h"

@implementation AnimatorHelper

+ (void) avatarBlink: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    avatarView.animationImages = @[
       //[UIImage imageNamed: @"avatar2_0.png"],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_blink1.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_blink2.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_blink1.png"]]
    ];
    
    avatarView.animationDuration = 0.2;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
}

+ (void) avatarGreet: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
      //[UIImage imageNamed: @"avatar2_0.png"],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm1.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm2.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm3.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4b.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm3.png"]],
      [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm2.png"]]
    ];
    
    avatarView.animationDuration = 1.7;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarOk: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2_0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm1.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm2.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm3.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4a.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5a.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5a.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm5a.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm4a.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm3.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"_arm2.png"]]
                                   ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void)shakeView:(UIView*)itemView {
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    CGFloat t = 3.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"shake" context: (__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.06];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

+ (void) scale: (UIView*) itemView from: (CGPoint) p1 to: (CGPoint) p2 {
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //CGAffineTransform st1  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -100);
    //CGAffineTransform st2  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    //itemView.transform = st1;  // starting point
    itemView.layer.anchorPoint = CGPointMake(0, 0);
    itemView.transform = CGAffineTransformMakeScale(p1.x, p1.y); // end here & auto-reverse
    
    [UIView beginAnimations: @"move" context: (__bridge void *)(itemView)];
    [UIView setAnimationDuration: 4];
    //[UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    [UIView setAnimationDelegate: self];
    
    itemView.transform = CGAffineTransformMakeScale(p2.x, p2.y); // end here & auto-reverse
    
    [UIView commitAnimations];
}

+ (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

@end
