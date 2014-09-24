//
//  LevelViewViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import "ImageManager.h"
#import "SliderViewController.h"


@interface ConfigView : SliderViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
  	UIButton *__unsafe_unretained openCloseButton;
  	UIButton *__unsafe_unretained soundButton;
    UIButton *__unsafe_unretained langButton;
    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained handHelpView;
    
    UIButton *__unsafe_unretained downloadButton;
    UIButton *__unsafe_unretained cancelDownloadButton;
    UIProgressView *__unsafe_unretained downloadProgressView;
    float angle;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *openCloseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *soundButton;;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *langButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *handHelpView;

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cancelDownloadButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIProgressView *downloadProgressView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *downloadButton;

- (IBAction) mailButtonClicked: (id) sender;
- (IBAction) buyClicked;
- (IBAction) resetButtonClicked;
- (IBAction) changeUserShowInfo: (id) sender;
- (IBAction) changeLang: (id) sender;
- (IBAction) soundClicked;

- (IBAction) cancelDownload:(id)sender;
- (IBAction) startLoading;

- (void) refreshSearchingModeEnabled:(BOOL)isDownloading;
- (void) addProgress: (float) aProgress;
- (void) downloadFinishWidhError: (NSString*) error;
- (void) downloadFinishSuccesfully;

- (void) refreshSoundButton;
- (void) helpDownload1;

@end






