//
//  GameEndView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameSequenceManager.h"
#import "AnimatorHelper.h"

@interface GameEndView : UIViewController {

   	UIImageView *__unsafe_unretained backgroundView;
    id __unsafe_unretained parentView;
    
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView* backgroundView;
@property (nonatomic, unsafe_unretained) id parentView;

- (void) show;
- (IBAction) hide;

@end
