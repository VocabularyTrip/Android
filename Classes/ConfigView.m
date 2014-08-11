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

@synthesize openCloseButton;
@synthesize soundButton;
@synthesize langButton;
@synthesize handHelpView;
@synthesize helpButton;

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) show {
    [super viewWillAppear: YES];
    // Refresh buttons
    Language* l = [UserContext getLanguageSelected];
    [langButton setImage: l.image forState: UIControlStateNormal];
	[self refreshSoundButton];

    [super show];
    
    if (![Vocabulary isDownloadCompleted] && [parentView startWithHelpDownload])
        // &&
        //!singletonVocabulary.isDownloading &&
        //![UserContext getHelpMapViewStep1] &&
        //![UserContext getHelpMapViewStep2] &&
        //![UserContext getHelpMapViewStep3])
        
        [self helpDownload1];
    
    [[parentView albumMenu] close];
}

- (void) close {
    handHelpView.alpha = 0;
    [super close];
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
		
		[mailCont setSubject:@"Hello Kids Learn Vocabulary !"];
		[mailCont setToRecipients:[NSArray arrayWithObject: cMailInfo]];
		[mailCont setMessageBody:@"" isHTML:NO];
		
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
			[[parentView mapScrollView] reloadAllLevels];
            [parentView moveUser];
            [self close];
            [parentView initializeHelpTimer];
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
        [[self parentView] setFlagTimeoutStartMusic: YES];
        [[self parentView] startPlayBackgroundSound];
	}
	[self refreshSoundButton];
}

- (void) refreshSoundButton {
	NSString *soundImageFile;
	soundImageFile = UserContext.soundEnabled == YES ? @"ico_volume.png" : @"ico_volume_off.png";
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
    angle=0;
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
    frame.origin.x = downloadProgressView.center.x;
    frame.origin.y = downloadProgressView.center.y;
    handHelpView.frame = frame;
    NSLog(@"%f, %f", frame.origin.x, frame.origin.y);
    [UIImageView commitAnimations];
}

- (void) helpDownload3 {
    // click down
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Download_Help_2" delegate: self selector: @selector(helpDownload4)];
}

- (void) helpDownload4 {

        // hover over lock button
    if (flagCancelAllSounds) return;
    CGRect frame = handHelpView.frame;
    
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>2.5*M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpDownload5)];
    }
    else {
        [UIImageView setAnimationDidStopSelector: @selector(helpDownload4)];
    }
    [UIImageView setAnimationDuration: .025];
    [UIImageView setAnimationBeginsFromCurrentState: YES];

    frame.origin.x = downloadProgressView.center.x + downloadProgressView.frame.size.width/2*sin(angle);
        //    frame.origin.y = downloadProgressView.center.y + downloadProgressView.frame.size.height/2*sin(angle);

    handHelpView.frame = frame;
    
    angle += M_PI/100;
    [UIImageView commitAnimations];

    [Sentence playSpeaker: @"Download_Help_3"];
    
}

- (void) helpDownload5 {
    handHelpView.alpha = 0;
}


@end
