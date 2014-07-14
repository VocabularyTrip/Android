//
//  AlbumMenu.h
//  VocabularyTrip
//
//  Created by Ariel on 11/6/13.
//
//

#import <UIKit/UIKit.h>
#import "AnimatorHelper.h"
#import "SliderViewController.h"

@interface AlbumMenu : SliderViewController {
    UIImageView *__unsafe_unretained progress1View;
    UIImageView *__unsafe_unretained progress2View;
    UIImageView *__unsafe_unretained progress3View;
    UIImageView *__unsafe_unretained progress1BarFillView;
    UIImageView *__unsafe_unretained progress2BarFillView;
    UIImageView *__unsafe_unretained progress3BarFillView;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album1Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album2Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *album3Button;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress1View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress2View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress3View;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress1BarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress2BarFillView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progress3BarFillView;

- (IBAction) show;
- (IBAction) album1ShowInfo:(id)sender;
- (IBAction) album2ShowInfo:(id)sender;
- (IBAction) album3ShowInfo:(id)sender;

- (void) updateLevelSlider: (UIImageView *) progressView over: (UIImageView *) progressView progress: (double) progress;


@end






