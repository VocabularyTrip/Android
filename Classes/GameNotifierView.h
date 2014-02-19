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

   	UILabel *__unsafe_unretained gameTypelabel;
   	UILabel *__unsafe_unretained includeWordsLabel;
   	UILabel *__unsafe_unretained includeImagesLabel;
   	UILabel *__unsafe_unretained readAbilityLabel;
   	UILabel *__unsafe_unretained cumulativeLabel;
    
    id __unsafe_unretained parentView;
    
}

@property (nonatomic, unsafe_unretained) IBOutlet UILabel *gameTypelabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *includeWordsLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *includeImagesLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *readAbilityLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *cumulativeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet id parentView;

- (void) show;
- (IBAction) hide;

@end
