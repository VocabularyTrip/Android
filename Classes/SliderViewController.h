//
//  SliderViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 7/11/14.
//
//

#import "GenericViewController.h"

#define cFlapWidthIpad 30
#define cFlapWidthIpod 16
#define cMarginHeightIpad 10
#define cMarginHeightIpod 5

@interface SliderViewController : GenericViewController {
    id __unsafe_unretained parentView;
    UIImageView *__unsafe_unretained backgroundView;
}

@property (nonatomic, unsafe_unretained) id parentView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) closeOpenClicked;
- (void) close;
- (void) show;
- (CGRect) frameOpened;
- (CGRect) frameClosed;
- (bool) frameIsClosed;

@end
