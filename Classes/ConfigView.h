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
#import "SliderViewController.h"


@interface ConfigView : SliderViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
  	UIButton *__unsafe_unretained soundButton;
    UIButton *__unsafe_unretained langButton;
    UIButton *__unsafe_unretained helpButton;
    UIImageView *__unsafe_unretained handHelpView;
}

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


//- (void) setParentMode: (bool) value;
- (void) refreshSoundButton;
- (void) helpDownload1;

@end






