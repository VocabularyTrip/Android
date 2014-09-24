//
//  LevelViewViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import "ConfigView.h"
#include "VocabularyTrip2AppDelegate.h"
//#include "MapView.h"
//#import "Vocabulary.h"

@interface ConfigView ()

@end

@implementation ConfigView

@synthesize openCloseButton;
@synthesize soundButton;
@synthesize langButton;
@synthesize handHelpView;
@synthesize helpButton;
@synthesize downloadButton;
@synthesize cancelDownloadButton;
@synthesize downloadProgressView;

- (MapView*) mapView {
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    return vocTripDelegate.mapView;
}

- (void) show {

    singletonVocabulary.isDownloadView = YES;
    singletonVocabulary.delegate = self;
    downloadButton.alpha = 1;
    [self refreshSearchingModeEnabled: singletonVocabulary.isDownloading];
    
    // Refresh buttons
    Language* l = [UserContext getLanguageSelected];
    [langButton setImage: l.image forState: UIControlStateNormal];
	[self refreshSoundButton];

    [super show];
    
    if (![Vocabulary isDownloadCompleted] && [parentView startWithHelpDownload])
        [self helpDownload1];
    
    [[parentView albumMenu] close];
}

- (void) close {
    handHelpView.alpha = 0;
    [super close];
    singletonVocabulary.isDownloadView = NO;
}

- (IBAction)changeUserShowInfo:(id)sender {

    //[[self parentView] cancelAllAnimations];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeUserView];
}

- (IBAction) changeLang:(id)sender {
    //[[self parentView] cancelAllAnimations];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vcDelegate pushChangeLangView];
}

- (IBAction) mailButtonClicked:(id)sender {
    //[[self parentView] cancelAllAnimations];
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
    //[[self parentView] cancelAllAnimations];
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
			break;
		default:
			break;
	}
}

- (IBAction)soundClicked {
    
	if (UserContext.soundEnabled == YES) {
        [UserContext setSoundEnabled: NO];
        [[self parentView] stopBackgroundSound];
	} else	{
        [UserContext setSoundEnabled: YES];
        [[self parentView] setFlagTimeoutStartMusic: YES];
        [[self parentView] startPlayBackgroundSound];
	}
	[self refreshSoundButton];
}

- (void) refreshSoundButton {
	NSString *soundImageFile;
	soundImageFile = UserContext.soundEnabled == YES ? @"ico_volume.png" : @"ico_volume_off.png";
	[soundButton setImage: [UIImage imageNamed: soundImageFile] forState: UIControlStateNormal];
}


-(IBAction) startLoading {
    singletonVocabulary.delegate = self;
    
    [self refreshSearchingModeEnabled: YES];
    
    [Vocabulary loadDataFromSql];
    NSLog(@"Load Launched...");
    
}

- (void) downloadFinishWidhError: (NSString*) error {
    [self refreshSearchingModeEnabled: NO];
    
    singletonVocabulary.wasErrorAtDownload++;
    singletonVocabulary.isDownloading = NO;
    //errorAtDownload = error;
    if (singletonVocabulary.wasErrorAtDownload == 1) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Download Error"
                              message: error
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void) downloadFinishSuccesfully {
}

- (IBAction) cancelDownload:(id)sender {
    [self refreshSearchingModeEnabled: NO];
}

-(void) refreshSearchingModeEnabled:(BOOL)isDownloading {
    singletonVocabulary.isDownloading = isDownloading;
	
	if (isDownloading) {
        cancelDownloadButton.alpha = 1;
        downloadProgressView.alpha = 1;
        downloadButton.alpha = 0;
        downloadButton.enabled = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
        downloadProgressView.alpha = 0;
        cancelDownloadButton.alpha = 0;
        downloadButton.enabled = YES;
        downloadButton.alpha = [Vocabulary isDownloadCompleted] ? 0 : 1;
	}
}

- (void) addProgress: (float) aProgress {
    downloadProgressView.progress = aProgress;
    if (aProgress >= 1) {
        [self refreshSearchingModeEnabled: NO];
    }
}

-(void) helpDownload1 {
    
   	//[parentView cancelAllAnimations];
    [parentView preventPlayingHelp: cPreventPlayingHelpTouchNothing];
    
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
    [Sentence playSpeaker: @"Download_Help_1" delegate: self selector: @selector(helpDownload3)];
    
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpDownload4)];
    
    [UIImageView setAnimationDuration: 4];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = handHelpView.frame;
    frame.origin.x = downloadProgressView.center.x;
    frame.origin.y = downloadProgressView.center.y - handHelpView.frame.size.height / 3;
    handHelpView.frame = frame;
    [UIImageView commitAnimations];
}

- (void) helpDownload3 {
    // click down
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Download_Help_2"];
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
    [parentView allowPlayingHelpEnded];
}


@end
