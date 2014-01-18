//
//  MapView.h
//  VocabularyTrip
//
//  Created by Ariel on 1/13/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "Vocabulary.h"
#import "ImageManager.h"
#include "UserContext.h"

@interface MapView : UIViewController <UIAlertViewDelegate> {
  	UIScrollView *__unsafe_unretained mapScrollView;
    UIButton *__unsafe_unretained helpButton;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIScrollView *mapScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;

- (void) initMap;
- (void) drawAllLeveles;
- (void) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size;
- (void) helpAnimation1;
- (void) helpDownload1;
- (void) reloadAllLevels;

@end