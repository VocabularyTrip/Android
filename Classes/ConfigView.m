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

@synthesize soundButton;
@synthesize langButton;
@synthesize handHelpView;
@synthesize helpButton;

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) show {
    // Refresh buttons
    Language* l = [UserContext getLanguageSelected];
    [langButton setImage: l.image forState: UIControlStateNormal];
	[self refreshSoundButton];

    [super show];
    
    if (![Vocabulary isDownloadCompleted] && !singletonVocabulary.isDownloading) [self helpDownload1];
    [[parentView albumMenu] close];
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
	soundImageFile = UserContext.soundEnabled == YES ? @"ico_volume.png" : @"sound-of.png";
    //soundImageFile = [ImageManager getIphoneIpadFile: soundImageFile];
	[soundButton setImage: [UIImage imageNamed: soundImageFile] forState: UIControlStateNormal];
	//[self.view.layer removeAllAnimations];
}

-(void) helpDownload1{
    
   	[parentView stopBackgroundSound];
    
    // Make clicking hand visible
    if (flagCancelAllSounds) return;
    helpButton.enabled = NO;
    handHelpView.alpha = 0;
    handHelpView.center = soundButton.center;
    [self.view bringSubviewToFront: handHelpView];
    
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(handHelpView)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpDownload2)];
    [UIImageView setAnimationDuration: .5];
    handHelpView.alpha = 1;
    [UIImageView commitAnimations];
    
}

-(void) helpDownload2 {
    // bring clicking hand onto Download button
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Download_Help_1"];
    
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpDownload3)];
    
    [UIImageView setAnimationDuration: 6];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = handHelpView.frame;
    frame.origin.x = downloadButton.center.x;
    frame.origin.y = downloadButton.center.y;
    handHelpView.frame = frame;
    
    [UIImageView commitAnimations];
}

- (void) helpDownload3 {
    // click down
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Download_Help_2"];
	CGRect frame = handHelpView.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload4)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	handHelpView.frame = frame;
    
	[UIImageView commitAnimations];
}

- (void) helpDownload4 {
    // release click
    if (flagCancelAllSounds) return;
	CGRect frame = handHelpView.frame;
    
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload5)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	handHelpView.frame = frame;
    
	[UIImageView commitAnimations];
}

- (void) helpDownload5 {
    // Wait before restarting this help
    if (flagCancelAllSounds) return;
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload6)];
	[UIImageView setAnimationDuration: 3];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = handHelpView.frame;
	frame.size.width = frame.size.width*.99;
	frame.size.height = frame.size.height*.99;
	handHelpView.frame = frame;
    
	[UIImageView commitAnimations];
}

- (void) helpDownload6 {
    // Wait before restarting this help
    if (flagCancelAllSounds) return;
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpEnd1)];
	[UIImageView setAnimationDuration: .9];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = handHelpView.frame;
	frame.size.width = frame.size.width/.99;
	frame.size.height = frame.size.height/.99;
	handHelpView.frame = frame;
    
	[UIImageView commitAnimations];
}

- (void) helpEnd1 {
    handHelpView.alpha = 0;
}

@end
