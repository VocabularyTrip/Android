//
//  SliderViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 7/11/14.
//
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

@synthesize backgroundView;
@synthesize parentView;

- (CGRect) frameOpened {

    
    int flapWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? cFlapWidthIpad : cFlapWidthIpod;
    
    int frameX = [ImageManager windowWidthXIB] - backgroundView.frame.size.width + flapWidth;
    int frameY = [ImageManager windowHeightXIB] - backgroundView.frame.size.height;
    
    return CGRectMake(
                      frameX,
                      frameY,
                      backgroundView.frame.size.width,
                      backgroundView.frame.size.height);
}

- (CGRect) frameClosed {
    CGRect frame = [self frameOpened];
    
    int flapWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? cFlapWidthIpad : cFlapWidthIpod;
    frame.origin.x = [ImageManager windowWidthXIB] - flapWidth * 2;
    // frame.origin.x + round(backgroundView.frame.size.width * 0.80);
    return frame;
}

- (IBAction) closeOpenClicked {
    if ([self frameIsClosed])
        [self show];
    else
        [self close];
}

- (void) show {
    
    self.view.frame = [self frameClosed];
    [UIView beginAnimations: @"moveShow" context: (__bridge void *)(self.view)];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = [self frameOpened];
    [UIView commitAnimations];
    
    [self viewWillAppear: YES];
    flagCancelAllSounds = 0;
}

- (bool) frameIsClosed {
    CGRect frameClosed = [self frameClosed];
    return (self.view.frame.origin.x == frameClosed.origin.x);
}

- (void) close {
    if ([self frameIsClosed]) return;
    [super done: nil];
    
    self.view.frame = [self frameOpened];
    [UIView beginAnimations: @"moveClose" context: nil];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = [self frameClosed];
    [UIView commitAnimations];
}

@end
