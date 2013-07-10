//
//  GenericViewController.h
//  VocabularyTrip
//
//  Created by Ariel on 7/9/13.
//
//

#import <UIKit/UIKit.h>
#import "Sentence.h"
//#import <MediaPlayer/MediaPlayer.h>


@interface GenericViewController : UIViewController {
    // Is used when the back button is pressed to cancel current sound and animation
    int flagCancelAllSounds;
}

- (IBAction) done:(id)sender;
- (void) cancelAllAnimations;

@end
