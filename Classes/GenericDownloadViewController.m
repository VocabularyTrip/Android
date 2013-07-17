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


-(IBAction) startLoading {
    //if (![Vocabulary isDownloadCompleted]) {
    if (!singletonVocabulary)
        singletonVocabulary = [Vocabulary alloc];
    singletonVocabulary.delegate = self;

    [self setSearchingModeEnabled: YES];
    
    
    [Vocabulary loadDataFromSql];
    NSLog(@"Load Launched...");
    
    self.backButton.enabled = NO;
    //}
}

- (void) downloadFinishWidhError: (NSString*) error {
    [self setSearchingModeEnabled: NO];
    
    singletonVocabulary.wasErrorAtDownload++;
    singletonVocabulary.isDownloading = NO;
    errorAtDownload = error;
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
    [self setSearchingModeEnabled: NO];
}

-(void)setSearchingModeEnabled:(BOOL)isDownloading
{
    singletonVocabulary.isDownloading = isDownloading;
	//when network action, toggle network indicator and activity indicator
	if (isDownloading) {
        qWordsLoaded = 0;
        singletonVocabulary.wasErrorAtDownload = 0;
        errorAtDownload = @"";
        
        cancelDownloadButton.alpha = 1;
        downloadProgressView.alpha = 1;
        confirmUserLangButton.alpha = 0;
        self.backButton.enabled = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
        self.backButton.enabled = YES;
        if (cancelDownloadButton.alpha != 0) {
            cancelDownloadButton.alpha = 0;
            downloadProgressView.alpha = 0;
            confirmUserLangButton.alpha = [Vocabulary isDownloadCompleted] ? 0 : 1;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
	}
}

- (void) addProgress {
    Language *lang = [UserContext getLanguageSelected];
    qWordsLoaded++;
    float progress =  (float) qWordsLoaded / (float) lang.qWords;
    
    downloadProgressView.progress = progress;
    
    if (progress >= 1) {
        [self setSearchingModeEnabled: NO];
        NSString *message = @"Download finished successfully";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download completed"
                                                        message: message delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    downloadProgressView.alpha = 0;
    // We are not shoure if the request countOfWords did finish.
    confirmUserLangButton.alpha = 1;
    if (![Vocabulary isDownloadCompleted]) {
        confirmUserLangButton.alpha = 1;
        cancelDownloadButton.alpha = 0;
    } else {
        confirmUserLangButton.alpha = 0;
        cancelDownloadButton.alpha = 0;
    }
}

@end
