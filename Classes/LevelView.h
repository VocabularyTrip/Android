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
	Word *word; // current selected word to show and say
    
    UIImageView *__unsafe_unretained backgroundView;
    UIImageView *__unsafe_unretained imageView;
	UILabel *__unsafe_unretained wordNamelabel;
	UILabel *__unsafe_unretained nativeWordNamelabel;
	UIButton *__unsafe_unretained pauseButton;
    UIButton *__unsafe_unretained repeatButton;
	CADisplayLink *theTimer;
    CGRect originalframeImageView;
    int gameStatus;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *wordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *nativeWordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *pauseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *repeatButton;

- (void) cancelAnimation;
- (void) showAndSayDictionary;
- (void) initializeTimer;
- (void) showAndSayWord;
- (void) showAndSayNextWord;
- (void) helpLevel;
- (void) showLevel: (Level*) aLevel at: (CGPoint) offset;

- (IBAction) close;
- (IBAction) pauseClicked;
- (IBAction) repeatClicked;
    
@end
