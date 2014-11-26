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
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-01-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-02-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-01-01.png"]]
    ];
    
    avatarView.animationDuration = 0.2;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
}

+ (void) avatarGreet: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-03-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-04-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-05-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-06-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-07-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-07-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-08-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-07-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-08-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-07-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-06-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-05-01.png"]]
     ];
    
    avatarView.animationDuration = 1.7;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarFrustrated: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-11-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-12-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-13-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-14-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-14-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-14-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-14-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-13-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-12-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-11-01.png"]],
    ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarDance: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-15-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-15-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-15-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-18-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-17-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-16-01.png"]],
    ];
    
    avatarView.animationDuration = 2;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarOk: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-04-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-05-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-06-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-09-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-10-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-10-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-10-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-09-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-06-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-05-01.png"]],
        [UIImage imageNamed: [NSString stringWithFormat: @"newAvatar%i%@", user.userId, @"-04-01.png"]]
    ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

@end
