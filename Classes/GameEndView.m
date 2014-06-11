//
//  SelectGameMode.m
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import "GameEndView.h"
#import "GenericTrain.h"

@implementation GameEndView

@synthesize backgroundView;
@synthesize progressView;
@synthesize progressBarFillView;
@synthesize parentView;
@synthesize progressBeforePlay;

- (void) viewDidLoad {
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    
    // fireworks animations
/*    CALayer *rootLayer = [CALayer layer];
    rootLayer.bounds = self.view.bounds; //CGRectMake(0, 0, 640, 480);
    //rootLayer.backgroundColor = [UIColor blackColor].CGColor;
    mortor = [CAEmitterLayer layer];
    [rootLayer addSublayer:mortor];
    [self.view.layer addSublayer:rootLayer];*/

}

- (void) show {
    int deltaX = ([ImageManager windowWidthXIB] - backgroundView.frame.size.width) / 2;
    int deltaY = ([ImageManager windowHeightXIB] - backgroundView.frame.size.height) / 2;
    
    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(
                                     deltaX, deltaY,
                                     backgroundView.frame.size.width,
                                     backgroundView.frame.size.height);
        self.view.alpha = 1;
    }];
    
    //[self addParticlesWithPoint: CGPointMake(150, 150)];
    [self addParticlesWithPoint: CGPointMake(250, 450)];
    //[self addParticlesWithPoint: CGPointMake(250, 150)];
    
    //[self updateLevelSlider];
}

- (IBAction) updateLevelSlider {
    
    double newProgress = [Vocabulary progressIndividualLevel];
    //progressBeforePlay = arc4random() % 2;
    //[Vocabulary progressIndividualLevel];
//    = progressBeforePlay;

    CGRect frame = progressBarFillView.frame;
    frame.origin.x = frame.origin.x - frame.size.width * newProgress;
    progressView.frame = frame;

    //NSLog(@"progressView %f, %f", newProgress, progressBeforePlay);
    
    //NSLog(@"progressView %f, %f, %f, %f", progressView.frame.origin.x, progressView.frame.origin.y, progressView.frame.size.width, progressView.frame.size.height);

    CGPoint p1 = CGPointMake(progressBeforePlay, 1);
    CGPoint p2 = CGPointMake(newProgress, 1);
    [AnimatorHelper scale: progressView from: p1 to: p2];
 
}

- (IBAction) hide {
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 0, 0);
        self.view.alpha = 0;
    }];
  	[parentView done: nil];			// Return to main menu
}


- (void)addParticlesWithPoint: (CGPoint) point {
    
    CGPoint originalPoint = CGPointMake(CGRectGetMaxX(self.view.bounds),
                                        CGRectGetMaxY(self.view.bounds));
    
    CGPoint newOriginPoint = CGPointMake(originalPoint.x - originalPoint.x/2,
                                         originalPoint.y - originalPoint.y/2);
    
    CGPoint position = CGPointMake(newOriginPoint.x + point.x,
                                   newOriginPoint.y + point.y);
    
    UIImage *image = [UIImage imageNamed:@"tspark.png"];
    
	
	mortor.emitterPosition = position;
	mortor.renderMode = kCAEmitterLayerBackToFront;
	
	//Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [CAEmitterCell emitterCell];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 40;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
	rocket.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
	
	//Name the cell so that it can be animated later using keypath
	[rocket setName:@"rocket"];
	
	//Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = (id)image.CGImage;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
	
	//The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = (id)image.CGImage;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
	
	//Name the cell so that it can be animated later using keypath
	[firework setName:@"firework"];
	
	//preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
	//Name the cell so that it can be animated later using keypath
	[preSpark setName:@"preSpark"];
	
	//The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = (id)image.CGImage;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
	
	preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
	rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
	mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];
	
	//NSLog(@"lifetime: %f, rendermode: %@", mortor.lifetime, mortor.renderMode);
    
    //Force the view to update
	[self.view setNeedsDisplay];
}

@end
