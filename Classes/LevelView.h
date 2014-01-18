//
//  LevelViewViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 1/14/14.
//
//

#import <UIKit/UIKit.h>
#include "Vocabulary.h"
#import "ImageManager.h"
#import "Level.h"

@interface LevelView : UIViewController {
	
    Level* level;
    
    UIImageView *__unsafe_unretained imageView;
	UILabel *__unsafe_unretained wordNamelabel;
	UILabel *__unsafe_unretained nativeWordNamelabel;
	UIButton *__unsafe_unretained pauseButton;
	CADisplayLink *theTimer;
    CGRect originalframeImageView;
    int gameStatus;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *wordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *nativeWordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *pauseButton;

- (void) cancelAnimation;
- (void) showAndSayDictionary;
- (void) initializeTimer;
- (void) showAndSayWord;
- (void) helpLevel;
- (void) showLevel: (Level*) aLevel at: (CGPoint) offset;
- (IBAction) close;
- (IBAction)pauseClicked;

@end
