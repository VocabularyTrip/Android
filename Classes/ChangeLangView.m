//
//  ChangeLangView.m
//  VocabularyTrip
//
//  Created by Ariel Jadzinsky on 7/3/12.
//  Copyright (c) 2012 __VocabularyTrip__. All rights reserved.
//

#import "ChangeLangView.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation ChangeLangView

@synthesize backButton;
@synthesize nextButton;
@synthesize langsView;
@synthesize langLabel;
@synthesize backgroundView;

- (IBAction) prevButtonPressed:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate.navController popViewControllerAnimated: YES];
    //[super done: sender];
}

- (IBAction) nextButtonPressed:(id)sender {
    
    VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vocTripDelegate popMapView];
    
    [vocTripDelegate checkAndStartDownload];
    [Vocabulary resetSoundWords];
}

- (void) initLangs {
    langsView.viewDelegate = self;

	for (int i=0; i < [[Language getAllLanguages] count]; i++) {
        Language* l = [[Language getAllLanguages] objectAtIndex: i];
		[(AFOpenFlowView *)self.langsView setImage: l.image forIndex:i];
	}
	[(AFOpenFlowView *)self.langsView setNumberOfImages: [[Language getAllLanguages] count]];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {

    Language* l = [[Language getAllLanguages] objectAtIndex: index];
    langLabel.text = l.name;

    User *user = [[UserContext getSingleton] userSelected];
    user.langSelected = l;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLangs];
    [langsView setSelectedCover: 0];
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSString* coverName = @"background_wizard"; //[ImageManager getIphone5xIpadFile: @"background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
 
    Language* langSelected = [UserContext getLanguageSelected];
    langLabel.text = langSelected.name;

    if (langSelected.key >= 6)
        [langsView setSelectedCover: 6];
    
    [langsView setSelectedCover: langSelected.langOrder];
    [langsView centerOnSelectedCover: YES];
    
    [super viewWillAppear: animated];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end















