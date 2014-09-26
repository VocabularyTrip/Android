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

#define cStatusGameIsPaused 1
#define cStatusGameIsOn 2

@interface LevelView : UIViewController {
	
    Level* level; // Selected level in mapView
	Word *word; // current selected word to show and say
    
    UIImageView *__unsafe_unretained backgroundView;
    UIImageView *__unsafe_unretained imageView;
	UILabel *__unsafe_unretained wordNamelabel;
	UILabel *__unsafe_unretained nativeWordNamelabel;
	UIButton *__unsafe_unretained pauseButton;
    UIButton *__unsafe_unretained repeatButton;
	UILabel *__unsafe_unretained levelNamelabel;
    
	CADisplayLink *theTimer;
    CGRect originalframeImageView;
    int gameStatus;
    
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *wordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *levelNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *nativeWordNamelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *pauseButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *repeatButton;
@property (nonatomic) Level* level;

- (IBAction) done:(id)sender;
- (void) cancelAnimation;
- (void) showAndSayDictionary;
- (void) initializeTimer;
- (void) showAndSayWord;
- (void) showAndSayNextWord;
- (void) helpLevel;
- (IBAction) pauseClicked;
- (IBAction) repeatClicked;
    
@end
