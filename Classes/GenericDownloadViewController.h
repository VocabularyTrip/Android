//
//  GenericDownloadViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "DownloadProtocol.h"
#import "UserContext.h"

@interface GenericDownloadViewController : UIViewController <UIAlertViewDelegate, DownloadDelegate> {
    // Progress
    int qWordsLoaded;
    NSString *__unsafe_unretained errorAtDownload;

    UIButton *__unsafe_unretained confirmUserLangButton;
    UIButton *__unsafe_unretained cancelDownloadButton;
    UIProgressView *__unsafe_unretained downloadProgressView;

}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton; // Implemented in subclass
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cancelDownloadButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIProgressView *downloadProgressView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *confirmUserLangButton;

- (IBAction) cancelDownload:(id)sender;
- (IBAction) startLoading;

- (void) setSearchingModeEnabled:(BOOL)isDownloading;
- (void) addProgress;
- (void) downloadFinishWidhError: (NSString*) error;
- (void) downloadFinishSuccesfully;

@end
