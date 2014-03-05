//
//  LevelViewViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import "ConfigView.h"
#include "VocabularyTrip2AppDelegate.h"
#include "MapView.h"

@interface ConfigView ()

@end

@implementation ConfigView

@synthesize backgroundView;
@synthesize parentView;

- (void) viewDidLoad {
    //self.view.layer.shouldRasterize = YES;
    //self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (CGRect) frameOpened {

    CGPoint offset = [parentView mapScrollView].contentOffset;
    CGRect configButtonFrame = [parentView configButton].frame;
    return CGRectMake(

               configButtonFrame.origin.x + configButtonFrame.size.width
                      - backgroundView.frame.size.width + offset.x,
               configButtonFrame.origin.y + configButtonFrame.size.height,
               backgroundView.frame.size.width,
               backgroundView.frame.size.height);
}

- (CGRect) frameClosed {
    CGRect frame = [self frameOpened];
    frame.origin.y = frame.origin.y - backgroundView.frame.size.height;
    return frame;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // This empty method is intended to overwrite the MapScrollView method.
    // the idea is not scrolling when Level is visible
}

- (void) setParentMode: (bool) value {
    MapScrollView *scroll = [parentView mapScrollView];
    //scroll.scrollEnabled = value;
    [scroll setEnabledInteraction: value];
    //value = YES ? scroll.alpha = 1 : scroll.alpha = 0;
}

- (void) show {
    
    //[[parentView mapScrollView] setUserInteractionEnabled: NO];
    //[self.view setUserInteractionEnabled: YES];
    
    [self setParentMode: NO];
    self.view.frame = [self frameClosed];
    
    [UIView beginAnimations: @"move" context: (__bridge void *)(self.view)];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];

    self.view.frame = [self frameOpened];
    
    [UIView commitAnimations];
}

- (bool) frameIsClosed {
    CGRect frameClosed = [self frameClosed];
    return (self.view.frame.origin.y == frameClosed.origin.y);
}

- (IBAction) close {
    
    //[[parentView mapScrollView] setUserInteractionEnabled: YES];
    if ([self frameIsClosed]) return;
    
    [self setParentMode: YES];
    self.view.frame = [self frameOpened];
    
    [UIView beginAnimations: @"move" context: (__bridge void *)(self.view)];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];
    
    self.view.frame = [self frameClosed];
    
    [UIView commitAnimations];
}

- (IBAction) mailButtonClicked:(id)sender {
  	//[self stopBackgroundSound];
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@""];
		[mailCont setToRecipients:[NSArray arrayWithObject: cMailInfo]];
		[mailCont setMessageBody:@"" isHTML:NO];
		
		[self presentModalViewController: mailCont animated:YES];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cant Send Mail"
                                                        message:@"All of your emails accounts are disabled or removed"
                                                       delegate:self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles:nil];
		[alert show];
	}
}

- (IBAction) buyClicked {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate pushPurchaseView];
}

- (IBAction) resetButtonClicked {
    
	UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"WORNING!"
                          message: @"By reseting, all coins, levels and sticker information about this user will be lost. Are you sure you want to reset?"
                          delegate: self
                          cancelButtonTitle: @"No"
                          otherButtonTitles: @"Yes", nil];
	[alert show];
}

@end
