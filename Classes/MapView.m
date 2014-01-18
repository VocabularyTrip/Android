//
//  MapView.m
//  VocabularyTrip
//
//  Created by Ariel on 1/13/14.
//
//

#import "MapView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation MapView

@synthesize  mapScrollView;
@synthesize helpButton;

- (void) viewDidLoad {
    [self initMap];
    [self drawAllLeveles];

    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) viewWillAppear:(BOOL)animated {
    int offset=240;
    Level *level = [UserContext getLevelAt: [UserContext getLevel]];
    int newX = level.placeInMap.x > offset ? level.placeInMap.x-offset : 0;
    CGPoint newPlace = CGPointMake(newX, 0);
    [mapScrollView setContentOffset: newPlace animated: YES];
}
    
- (void) initMap {
    // Configurar el ancho del mapa
    [mapScrollView setContentSize: CGSizeMake(1200, 320)];
}

- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromLevel];
}


- (IBAction) resetButtonClicked {
    
	UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"WORNING!"
                          message: @"By reseting, all coins, levels and sticker information about this user will be lost. Are you sure you want to reset?"
                          delegate: self
                          cancelButtonTitle: @"No"
                          otherButtonTitles: @"Yes", nil];
	[alert show];
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) aButtonIndex {
	switch (aButtonIndex) {
		case 0:
			break;
		case 1:
			[[UserContext getSingleton] resetGame];
			[self reloadAllLevels];
			break;
		default:
			break;
	}
}

- (void) reloadAllLevels {
    for (int i=1; i<mapScrollView.subviews.count; i++) {
        UIView *aView = [mapScrollView.subviews objectAtIndex:i];
    //for (UIView* aView in mapScrollView.subviews)
        [aView removeFromSuperview];
    }
    [self drawAllLeveles];
}

- (void) drawAllLeveles {
    int imageSize = 60;
    Level *level;
    for (int i=0; i< [[UserContext getSingleton] countOfLevels]; i++) {
        level = [UserContext getLevelAt: i];
        [self addImage: level.image pos: level.placeInMap size: imageSize];
     
        CGPoint newPlace = CGPointMake(level.placeInMap.x+imageSize*0.7, level.placeInMap.y+imageSize*0.7);
        if (i >= [UserContext getMaxLevel] && i != 0)
            [self addImage: [UIImage imageNamed:@"BuyButton.png"] pos: newPlace size: imageSize*0.4];
        else if (i >= [UserContext getLevel] && i != 0)
            [self addImage: [UIImage imageNamed:@"token-bronze.png"] pos: newPlace size: imageSize*0.4];
    }
}

-(void) addImage: (UIImage*) image pos: (CGPoint) pos size: (int) size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    CGRect frame = imageView.frame;
    frame.origin = pos;
    frame.size.width = size;
    frame.size.height = size;
    imageView.frame = frame;
    [ImageManager fitImage: image inImageView: imageView];
    
    [mapScrollView addSubview: imageView];
    [mapScrollView bringSubviewToFront: imageView];
}

- (void) helpAnimation1 {
}

- (void) helpDownload1 {
}

@end
