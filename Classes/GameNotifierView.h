//
//  GameNotifierView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameSequenceManager.h"


@interface GameNotifierView : UIViewController {

   	UIImageView *__unsafe_unretained backgroundView;
    
    UIButton *__unsafe_unretained wordButton1;
	UIButton *__unsafe_unretained wordButton2;
  	UIButton *__unsafe_unretained wordButtonLabel1;
   	UIButton *__unsafe_unretained wordButtonLabel2;
	UIImageView *__unsafe_unretained wagon1;
	UIImageView *__unsafe_unretained wagon2;
    CGRect originalframeWord1ButtonView;
    CGRect originalframeWord2ButtonView;
    
   	UILabel *__unsafe_unretained gameTypelabel;
   	UILabel *__unsafe_unretained includeWordsLabel;
   	UILabel *__unsafe_unretained includeImagesLabel;
   	UILabel *__unsafe_unretained readAbilityLabel;
   	UILabel *__unsafe_unretained cumulativeLabel;
    
    id __unsafe_unretained parentView;
    
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView* backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *gameTypelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButton1;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButton2;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButtonLabel1;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *wordButtonLabel2;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon1;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *wagon2;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *includeWordsLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *includeImagesLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *readAbilityLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *cumulativeLabel;
@property (nonatomic, unsafe_unretained) id parentView;

- (void) show;
- (IBAction) hide;

@end
