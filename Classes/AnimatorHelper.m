    //
    //  AvatarAnimator.m
    //  VocabularyTrip
    //
    //  Created by Ariel on 11/11/13.
    //
    //

    // Cambie el nombre a todas las imagenes de animaciones para poder exportar todos los artworks de illustrator directamente
    // nombre viejo     -> nombre nuevo
    //      blinking
    // blink1 -> 01
    // blink2 -> 02
    //      saludo
    // -0 -> 03
    // arm1 -> 04
    // arm2 -> 05
    // arm3 -> 06
    // arm4b -> 07
    // arm5b -> 08
    //      ok
    // arm4a -> 09
    // arm5a -> 10
    //      frustrado
    // frustrado_# -> #+10 (por ejemplo frustrado-1 paso a ser 11)
    //      bailando
    // bailando_# -> #+14 (bailand-1 paso a ser -15)

#import "AnimatorHelper.h"
#import "User.h"
#import "UserContext.h"

SEL selectorAnimator = nil;

@implementation AnimatorHelper

+ (void) avatarBlink: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2-0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-01.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-02.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-01.png"]]
                                   ];
    
    avatarView.animationDuration = 0.2;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
}

+ (void) avatarGreet: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2-0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-03.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-04.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-05.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-06.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-07.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-07.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-08.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-07.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-08.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-07.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-06.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-05.png"]]
                                   ];
    
    avatarView.animationDuration = 1.7;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarFrustrated: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2-0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-11.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-12.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-13.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-14.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-14.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-14.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-14.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-13.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-12.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-11.png"]],
                                   ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarDance: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2-0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-15.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-19.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-15.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-19.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-15.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-19.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-18.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-17.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-16.png"]],
                                   ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) avatarOk: (UIImageView*) avatarView {
    User *user = [UserContext getUserSelected];
    
    avatarView.animationImages = @[
                                   //[UIImage imageNamed: @"avatar2-0.png"],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-04.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-05.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-06.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-10.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-11.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-11.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-11.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-10.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-06.png"]],
                                   [UIImage imageNamed: [NSString stringWithFormat: @"avatar%i%@", user.userId, @"-05.png"]]
                                   ];
    
    avatarView.animationDuration = 1;
    avatarView.animationRepeatCount = 1;
    [avatarView startAnimating];
    
}

+ (void) shakeView: (UIView*) itemView delegate: (id) delegate {
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    CGFloat t = 3.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"shake" context: (__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.06];
    [UIView setAnimationDelegate: delegate];
    [UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

+ (void) clickingView: (UIView*) itemView delegate: (id) delegate {
    [self clickingView: itemView delegate: delegate selector: nil];
}

+ (void) clickingView: (UIView*) itemView delegate: (id) delegate selector: (SEL) selectorParam {
    CGRect frame = itemView.frame;
    
    NSMutableDictionary *animationParameters = [[NSMutableDictionary alloc] init];
    [animationParameters setObject: delegate forKey: @"delegate"];
    [animationParameters setObject: itemView forKey: @"itemView"];
    selectorAnimator = !selectorParam ? @selector(releaseClickingView:finished:context:) : selectorParam;
    
	[UIImageView beginAnimations: @"clickingAnimation" context: CFBridgingRetain(animationParameters)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationDidStopSelector: @selector(releaseClickingView:finished:context:)];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	itemView.frame = frame;
    
	[UIImageView commitAnimations];
}

+ (void) releaseClickingView:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    NSMutableDictionary *parameters = (__bridge NSMutableDictionary*) context;
    
    UIImageView *itemView = (UIImageView*) [parameters objectForKey: @"itemView"];
    id delegate = (id) [parameters objectForKey: @"delegate"];
    
	CGRect frame = itemView.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: CFBridgingRetain(parameters)];
	[UIImageView setAnimationDelegate: delegate];
	[UIImageView setAnimationDuration: .5];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    if (selectorAnimator) [UIImageView setAnimationDidStopSelector: selectorAnimator];
    
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	itemView.frame = frame;
    
	[UIImageView commitAnimations];
    
    selectorAnimator = nil;
}

+ (void)shakeView:(UIView*)itemView {
    [self shakeView: itemView delegate: self];
}

+ (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

+ (void) scale: (UIView*) itemView from: (CGPoint) p1 to: (CGPoint) p2 {
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
        //CGAffineTransform st1  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -100);
        //CGAffineTransform st2  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
        //itemView.transform = st1;  // starting point
    itemView.layer.anchorPoint = CGPointMake(0, 0);
    itemView.transform = CGAffineTransformMakeScale(p1.x, p1.y);
    
    [UIView beginAnimations: @"scale" context: (__bridge void *)(itemView)];
    [UIView setAnimationDuration: 3];
        //[UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    [UIView setAnimationDelegate: self];
    
    itemView.transform = CGAffineTransformMakeScale(p2.x, p2.y);
    
    [UIView commitAnimations];
}

+ (void) rotateView: (UIView*) itemView {
    
    [UIView beginAnimations:@"rotate" context: (__bridge void *)(itemView)];
    [UIView setAnimationDuration: 1];
    itemView.layer.transform =
    CATransform3DScale(CATransform3DMakeRotation(M_PI, 0, 0, 1), -1, 1, 1);
    
    [UIView commitAnimations];
}

@end
