//
//  UserLangResumeView.h
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 11/12/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>	
#import "DownloadProtocol.h"

@interface UserLangResumeView : UIViewController <UIAlertViewDelegate, DownloadDelegate> {

    // User
    UIImageView *__unsafe_unretained userView;
    UILabel *__unsafe_unretained nameLabel;

    // Progress
    int qWordsLoaded;
    //int wasErrorAtDownload;
    NSString *__unsafe_unretained errorAtDownload;
    
    // User Info Resume
    UIImageView *__unsafe_unretained flagView;    
    UILabel *__unsafe_unretained langSelectedLabel;
    UIButton *__unsafe_unretained cancelDownloadButton;
    UIButton *__unsafe_unretained confirmUserLangButton;
    UILabel *__unsafe_unretained moneyBronzeLabel;
    UILabel *__unsafe_unretained moneySilverLabel;
    UILabel *__unsafe_unretained moneyGoldLabel;    
    UIImageView *__unsafe_unretained progressView;
    UIImageView *__unsafe_unretained progressBarFillView;
    UIProgressView *__unsafe_unretained downloadProgressView;
    UIImageView *__unsafe_unretained backgroundView;
    UIImageView *__unsafe_unretained userInfoView;
    UIButton *__unsafe_unretained backButton;
    UIButton *__unsafe_unretained helpButton;
    UIButton *__unsafe_unretained buyButton;
    UIImageView *__unsafe_unretained hand;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *flagView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *userView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *nameLabel;

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cancelDownloadButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *confirmUserLangButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneyBronzeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneySilverLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *moneyGoldLabel;    
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *langSelectedLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIProgressView *downloadProgressView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressBarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *buyButton;

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *userInfoView;

- (IBAction)done:(id)sender;
- (IBAction) cancelDownload:(id)sender;
- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) startLoading;
- (IBAction) buyButtonClicked;
- (IBAction) resetButtonClicked;
- (IBAction) showMoney;

- (void) setSearchingModeEnabled:(BOOL)isDownloading;
- (void) addProgress;
//- (void) setProgress: (float) progress;
- (void) refreshToolbar;
- (void) downloadFinishWidhError: (NSString*) error;
- (void) downloadFinishSuccesfully;

- (IBAction) helpClicked;
- (void) helpAnimation1;
- (void) helpAnimation2;
- (void) helpAnimation3;
- (void) helpAnimation4;
- (void) helpAnimation5;
- (void) helpAnimation6;
- (void) helpAnimation7;
- (void) helpAnimation8;
//- (void) startTestAnimation;
    
@end
