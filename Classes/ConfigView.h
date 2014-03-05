//
//  LevelViewViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import <UIKit/UIKit.h>
#import "ImageManager.h"

@interface ConfigView : UIViewController {
    
    UIImageView *__unsafe_unretained backgroundView;
    id __unsafe_unretained parentView;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) id parentView;

- (void) show;
- (IBAction) mailButtonClicked: (id) sender;
- (IBAction) buyClicked;
- (IBAction) resetButtonClicked;
- (IBAction) close;
- (void) closeAnimationStoped;
- (CGRect) frameOpened;
- (CGRect) frameClosed;
- (bool) frameIsClosed;
- (void) setParentMode: (bool) value;

@end






