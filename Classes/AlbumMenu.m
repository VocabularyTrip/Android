//
//  AlbumMenu.m
//  VocabularyTrip
//
//  Created by Ariel on 11/6/13.
//
//

#import "AlbumMenu.h"
#import "VocabularyTrip2AppDelegate.h"

@interface AlbumMenu ()

@end

@implementation AlbumMenu

@synthesize backButton;
@synthesize backgroundView;

- (IBAction)done: (id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    
	[vocTripDelegate popMainMenuFromAlbumMenu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear: (BOOL)animated {
    NSString* coverName = [UserContext getIphone5xIpadFile: @"menu_bg"];   // background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
}

- (IBAction)album1ShowInfo:(id)sender {
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum1];
	[vcDelegate pushAlbumView];
}

- (IBAction)album2ShowInfo:(id)sender {
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum2];
	[vcDelegate pushAlbumView];
}

- (IBAction)album3ShowInfo:(id)sender {
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum3];
	[vcDelegate pushAlbumView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
