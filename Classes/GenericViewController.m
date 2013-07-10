//
//  GenericViewController.m
//  VocabularyTrip
//
//  Created by Ariel on 7/9/13.
//
//

#import "GenericViewController.h"

@interface GenericViewController ()

@end

@implementation GenericViewController

- (IBAction)done:(id)sender {
    // Cancel all animations and Sounds:
    [self cancelAllAnimations];
}

- (void) cancelAllAnimations {
    flagCancelAllSounds = 1;
    [Sentence stopCurrentAudio];
    
	// Cancel actual animation
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView commitAnimations];
	
	[self.view.layer removeAllAnimations];
}

- (void)viewDidAppear: (BOOL)animated {
    [super viewDidAppear: animated];
    flagCancelAllSounds = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
