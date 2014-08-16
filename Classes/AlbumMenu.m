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

@synthesize openCloseButton;
@synthesize album1Button;
@synthesize album2Button;
@synthesize album3Button;
@synthesize progress1View;
@synthesize progress2View;
@synthesize progress3View;
@synthesize progress1BarFillView;
@synthesize progress2BarFillView;
@synthesize progress3BarFillView;

- (void) show {

    VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];

    [self updateLevelSlider: progress1View over: progress1BarFillView progress: [vcDelegate.albumView.album1 progress]];
    [self updateLevelSlider: progress2View over: progress2BarFillView  progress: [vcDelegate.albumView.album2 progress]];
    [self updateLevelSlider: progress3View over: progress3BarFillView  progress: [vcDelegate.albumView.album3 progress]];
    
    [super show];
    [[self.parentView configView] close];
}

- (void) viewWillAppear:(BOOL)animated {
    // Is implemented in GenericDownloadViewController and the behaviour is related to download.
    // Album doesn't has download behaviour
    // GenericDownloadViewController should be a helper and not a super class
}

- (void) updateLevelSlider: (UIImageView *) progressView over: (UIImageView *) progressBarFillView progress: (double) progress {
    
    CGRect frameFill = progressBarFillView.frame;
    int deltaWidth = frameFill.size.width;
    int deltaX = frameFill.origin.x;
    
    CGRect frame = progressView.frame;
	frame.size.width = deltaWidth * (1-progress);
    frame.origin.x = deltaX + (deltaWidth * progress);
    progressView.frame = frame;
}

- (IBAction) album1ShowInfo:(id)sender {
    [parentView cancelAllAnimations];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum1];
	[vcDelegate pushAlbumView];
}

- (IBAction) album2ShowInfo:(id)sender {
    [parentView cancelAllAnimations];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum2];
	[vcDelegate pushAlbumView];
}

- (IBAction) album3ShowInfo:(id)sender {
    [parentView cancelAllAnimations];
	VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    [vcDelegate.albumView selectAlbum3];
	[vcDelegate pushAlbumView];
}

@end
