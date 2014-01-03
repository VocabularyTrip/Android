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
@synthesize album1Button;
@synthesize album2Button;
@synthesize album3Button;
@synthesize progress1View;
@synthesize progress2View;
@synthesize progress3View;
@synthesize progress1BarFillView;
@synthesize progress2BarFillView;
@synthesize progress3BarFillView;
@synthesize avatarView;

- (IBAction)done: (id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
    
	[vocTripDelegate popMainMenuFromAlbumMenu];
    [theTimer invalidate];
	theTimer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear: (BOOL)animated {
    NSString* coverName = [UserContext getIphone5xIpadFile: @"background_wizard"];   // background_wizard"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
    
    VocabularyTrip2AppDelegate *vcDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];

    [self updateLevelSlider: progress1View over: progress1BarFillView progress: [vcDelegate.albumView.album1 progress]];
    [self updateLevelSlider: progress2View over: progress2BarFillView  progress: [vcDelegate.albumView.album2 progress]];
    [self updateLevelSlider: progress3View over: progress3BarFillView  progress: [vcDelegate.albumView.album3 progress]];
    
    User *user = [UserContext getUserSelected];
    [avatarView setImage: user.image];

}

- (void)viewDidAppear: (BOOL)animated {
    avatarAnimationSeq = 0;
    [self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(randomAvatarAnimation)];
		theTimer.frameInterval = 200;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) randomAvatarAnimation {
    //int i = arc4random() % 6;
    switch (avatarAnimationSeq) {
        case 0:
            [AnimatorHelper avatarGreet: avatarView];
            break;
        case 1:
            [AnimatorHelper avatarBlink: avatarView];
            //[self flutterAnimation];
            break;
        case 2:
            [AnimatorHelper shakeView: album1Button];
            break;
        case 3:
            [AnimatorHelper avatarBlink: avatarView];
            break;
        case 4:
            [AnimatorHelper shakeView: album2Button];
            break;
        case 5:
            [AnimatorHelper avatarBlink: avatarView];
            break;
        case 6:
            [AnimatorHelper shakeView: album3Button];
            break;
        default:
            [AnimatorHelper avatarBlink: avatarView];
            break;
    }
    avatarAnimationSeq++;
    if (avatarAnimationSeq > 7) avatarAnimationSeq = 0;
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
