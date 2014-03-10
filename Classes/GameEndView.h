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
    UIImageView *__unsafe_unretained progressView;
    UIImageView *__unsafe_unretained progressBarFillView;
    
    id __unsafe_unretained parentView;
  	CAEmitterLayer *mortor; // fireworks animation
    float progressBeforePlay;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView* backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressView;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *progressBarFillView;
@property (nonatomic, unsafe_unretained) float progressBeforePlay;

@property (nonatomic, unsafe_unretained) id parentView;

- (void) show;
- (IBAction) hide;
- (void)addParticlesWithPoint: (CGPoint)point;
- (IBAction) updateLevelSlider;

@end
