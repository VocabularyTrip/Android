//
//  SliderViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 7/11/14.
//
//

#import "GenericDownloadViewController.h"

@interface SliderViewController : GenericDownloadViewController {
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
