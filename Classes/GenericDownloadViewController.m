//
//  GenericDownloadViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 7/4/13.
//
//

#import "GenericDownloadViewController.h"

@interface GenericDownloadViewController ()

@end

@implementation GenericDownloadViewController

@synthesize confirmUserLangButton;
@synthesize cancelDownloadButton;
@synthesize downloadProgressView;

- (IBAction)done:(id)sender {
    [super done: sender];
    singletonVocabulary.isDownloadView = NO;
}

-(IBAction) startLoading {
    //if (![Vocabulary isDownloadCompleted]) {
    singletonVocabulary.delegate = self;

    [self refreshSearchingModeEnabled: YES];
    
    [Vocabulary loadDataFromSql];
    NSLog(@"Load Launched...");
    
    //self.backButton.enabled = NO;
    //}
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
	//when network action, toggle network indicator and activity indicator
	if (isDownloading) {
        cancelDownloadButton.alpha = 0; // Test eliminate cancel
        downloadProgressView.alpha = 1;
        confirmUserLangButton.alpha = 1; // Test eliminate cancel
        confirmUserLangButton.enabled = NO; // Test eliminate cancel
        //self.backButton.enabled = NO; // Test eliminate cancel
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
        //self.backButton.enabled = YES;
        downloadProgressView.alpha = 0;
        confirmUserLangButton.enabled = YES;
        confirmUserLangButton.alpha = [Vocabulary isDownloadCompleted] ? 0 : 1;
        /*if (cancelDownloadButton.alpha != 0) {
            cancelDownloadButton.alpha = 0;
            downloadProgressView.alpha = 0;
            confirmUserLangButton.alpha = [Vocabulary isDownloadCompleted] ? 0 : 1;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }*/
	}
}

- (void) addProgress: (float) aProgress {
    
    downloadProgressView.progress = aProgress;
    
    if (aProgress >= 1) {
        [self refreshSearchingModeEnabled: NO];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    singletonVocabulary.isDownloadView = YES;
    singletonVocabulary.delegate = self;

    confirmUserLangButton.alpha = 1;
    //cancelDownloadButton.alpha = 0;
    
    /*if (![Vocabulary isDownloadCompleted]) {
        confirmUserLangButton.alpha = 1;
    } else {
        confirmUserLangButton.alpha = 0;
    }*/
    
    [self refreshSearchingModeEnabled: singletonVocabulary.isDownloading];
}

@end
