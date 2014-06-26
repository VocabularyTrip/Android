//
//  LevelViewViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ImageManager.h"
#import "GenericDownloadViewController.h"


@interface ConfigView : GenericDownloadViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    
    UIImageView *__unsafe_unretained backgroundView;
    id __unsafe_unretained parentView;
  	UIButton *__unsafe_unretained soundButton;
    UIButton *__unsafe_unretained langButton;
    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained handHelpView;
   
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) id parentView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *soundButton;;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *langButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *handHelpView;

- (IBAction) mailButtonClicked: (id) sender;
- (IBAction) buyClicked;
- (IBAction) resetButtonClicked;
- (IBAction) changeUserShowInfo: (id) sender;
- (IBAction) changeLang: (id) sender;
- (IBAction) soundClicked;
- (IBAction) closeOpenClicked;
- (void) close;
- (void) show;

- (CGRect) frameOpened;
- (CGRect) frameClosed;
- (bool) frameIsClosed;
//- (void) setParentMode: (bool) value;
- (void) refreshSoundButton;
- (void) helpDownload1;

@end






