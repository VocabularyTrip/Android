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
#import "Vocabulary.h"

@interface ConfigView ()

@end

@implementation ConfigView

@synthesize backgroundView;
@synthesize parentView;
@synthesize soundButton;
@synthesize langButton;

- (void) viewDidLoad {
    //self.view.layer.shouldRasterize = YES;
    //self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (CGRect) frameOpened {

    [super viewWillAppear: NO];
    //CGPoint offset = [parentView mapScrollView].contentOffset;
    //CGRect configButtonFrame = [parentView configButton].frame;
    
    int configButtonFrameX;

    //if ([ImageManager resolution] == UIDeviceResolution_iPhoneRetina5) {
    //    configButtonFrameX = configButtonFrame.size.width - backgroundView.frame.size.width + offset.x;
    //} else {
        configButtonFrameX = [ImageManager windowWidthXIB] - backgroundView.frame.size.width;
    //}
    
    //NSLog(@"ConfigButtomFrameX: %f, ConfigButtomFrameWidth: %f, backgroundViewWidth: %f, offset: %f, result: %f", configButtonFrame.origin.x, configButtonFrame.size.width, backgroundView.frame.size.width, offset.x,configButtonFrame.origin.x + configButtonFrame.size.width - backgroundView.frame.size.width + offset.x);
    
    return CGRectMake(
               configButtonFrameX,
               0, // configButtonFrame.origin.y + configButtonFrame.size.height,
               backgroundView.frame.size.width,
               backgroundView.frame.size.height);


}

- (CGRect) frameClosed {
    CGRect frame = [self frameOpened];
    //frame.origin.y = frame.origin.y - backgroundView.frame.size.height;
    frame.origin.x = frame.origin.x  + backgroundView.frame.size.width;
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
}

- (void) show {
    
    //[[parentView mapScrollView] setUserInteractionEnabled: NO];
    //[self.view setUserInteractionEnabled: YES];
    
    Language* l = [UserContext getLanguageSelected];
    [langButton setImage: l.image forState: UIControlStateNormal];

    //[self setParentMode: NO];
    self.view.frame = [self frameClosed];
	[self refreshSoundButton];
    
    [UIView beginAnimations: @"move" context: (__bridge void *)(self.view)];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate: self];

    self.view.frame = [self frameOpened];
    
    [UIView commitAnimations];
    
    //langButton.enabled = !singletonVocabulary.isDownloading;

}

- (bool) frameIsClosed {
    CGRect frameClosed = [self frameClosed];
    return (self.view.frame.origin.x == frameClosed.origin.x);
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

- (IBAction)changeUserShowInfo:(id)sender {
	//[parentView stopBackgroundSound];
    [[self parentView] stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeUserView];
}

- (IBAction) changeLang:(id)sender {
    [[self parentView] stopBackgroundSound];
	//[parentView stopBackgroundSound];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeLangView];
}

- (IBAction) mailButtonClicked:(id)sender {
  	//[self stopBackgroundSound];
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@"Awesome app: Kids Learn Vocabulary !"];
		[mailCont setToRecipients:[NSArray arrayWithObject: cMailInfo]];
		[mailCont setMessageBody:@"I'm using this app and I found ..." isHTML:NO];
		
		[parentView presentModalViewController: mailCont animated:YES];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cant Send Mail"
                                                        message:@"All of your emails accounts are disabled or removed"
                                                       delegate:self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles:nil];
		[alert show];
	}
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [parentView dismissModalViewControllerAnimated:YES];
	if (result==MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed"
                                                        message:@"Your mail has failed to sent"
                                                       delegate:self
                                              cancelButtonTitle: @"Dismiss"
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

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) aButtonIndex {
	switch (aButtonIndex) {
		case 0:
			break;
		case 1:
			[[UserContext getSingleton] resetGame];
			[parentView reloadAllLevels];
            [parentView moveUser];
			break;
		default:
			break;
	}
}

- (IBAction)soundClicked {
	if (UserContext.soundEnabled == YES) {
		UserContext.soundEnabled = NO;
        [[self parentView] stopBackgroundSound];
	} else	{
		UserContext.soundEnabled = YES;
	}
	[self refreshSoundButton];
}

- (void) refreshSoundButton {
	NSString *soundImageFile;
	soundImageFile = UserContext.soundEnabled == YES ? @"sound-on" : @"sound-of";
    soundImageFile = [ImageManager getIphoneIpadFile: soundImageFile];
	[soundButton setImage: [UIImage imageNamed: soundImageFile] forState: UIControlStateNormal];
	//[self.view.layer removeAllAnimations];
}

@end
