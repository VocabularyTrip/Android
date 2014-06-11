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

@synthesize downloadButton;
@synthesize cancelDownloadButton;
@synthesize downloadProgressView;

- (IBAction)done:(id)sender {
    [super done: sender];
    singletonVocabulary.isDownloadView = NO;
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

- (void) viewWillAppear:(BOOL)animated {
    singletonVocabulary.isDownloadView = YES;
    singletonVocabulary.delegate = self;
    //NSLog(@"IsDownloading: %i", singletonVocabulary.isDownloading);
    downloadButton.alpha = 1;
    [self refreshSearchingModeEnabled: singletonVocabulary.isDownloading];
}

@end
