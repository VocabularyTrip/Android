//
//  AlbumMenu.h
//  VocabularyTrip
//
//  Created by Ariel on 11/6/13.
//
//

#import <UIKit/UIKit.h>
#import "AnimatorHelper.h"

@interface AlbumMenu : UIViewController {
	UIImageView *__unsafe_unretained backgroundView;
	UIButton *__unsafe_unretained backButton;
	//UIButton *__unsafe_unretained album1Button;
	//UIButton *__unsafe_unretained album2Button;
	//UIButton *__unsafe_unretained album3Button;
    
    UIImageView *__unsafe_unretained progress1View;
    UIImageView *__unsafe_unretained progress2View;
    UIImageView *__unsafe_unretained progress3View;
    UIImageView *__unsafe_unretained progress1BarFillView;
    UIImageView *__unsafe_unretained progress2BarFillView;
    UIImageView *__unsafe_unretained progress3BarFillView;
    
    UIImageView *__unsafe_unretained avatarView;
    
    CADisplayLink *theTimer;
    int avatarAnimationSeq;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album1Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album2Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album3Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress1View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress2View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress3View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress1BarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress2BarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress3BarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *avatarView;

- (IBAction) done:(id)sender;
- (IBAction) album1ShowInfo:(id)sender;
- (IBAction) album2ShowInfo:(id)sender;
- (IBAction) album3ShowInfo:(id)sender;
- (void) initializeTimer;
- (void) randomAvatarAnimation;

- (void) updateLevelSlider: (UIImageView *) progressView over: (UIImageView *) progressView progress: (double) progress;


@end






