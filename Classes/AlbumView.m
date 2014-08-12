//
//  Album.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/9/11.
//  Copyright 2011 VocabularyTrip. All rights reserved.
//

#import "AlbumView.h"
#import "Sentence.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation AlbumView

@synthesize backgroundView;
@synthesize prevButton;
@synthesize nextButton;
@synthesize pageLabel;
@synthesize figurinesInPage;
@synthesize album1;
@synthesize album2;
@synthesize album3;

@synthesize backButton;
@synthesize soundButton;
@synthesize money1View;
@synthesize money1Label;	
@synthesize money2View;
@synthesize money2Label;	
@synthesize money3View;
@synthesize money3Label;	
@synthesize hand;
@synthesize helpButton;


- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[self removeCurrentPage];	
	[theTimer invalidate];
	theTimer = nil;
	[vocTripDelegate popMainMenuFromAlbum];
}

- (void) selectAlbum1 {
	currentAlbum = self.album1;
}

- (void) selectAlbum2 {
	currentAlbum = self.album2;
}

- (void) selectAlbum3 {
	currentAlbum = self.album3;
}

-(Album*) album1 {
	if (album1 == nil) {
		album1 = [Album alloc];
		album1.xmlName = cAlbum1;
		[album1 loadDataFromXML: cAlbum1];
	}
	
	return album1;
}

-(Album*) album2 {
	if (album2 == nil) {
		album2 = [Album alloc];
		album2.xmlName = cAlbum2;
		[album2 loadDataFromXML: cAlbum2];
	}
	
	return album2;
}

-(Album*) album3 {
	if (album3 == nil) {
		album3 = [Album alloc];
		album3.xmlName = cAlbum3;
		[album3 loadDataFromXML: cAlbum3];
	}
	
	return album3;
}

- (void) initialize {
    if (!figurinesInPage) {
        figurinesInPage = [[NSMutableArray alloc] init];
    }
    [self initMusicPlayer];
}

- (void) reloadFigurines {
    [album1 reloadFigurines];
    [album2 reloadFigurines];    
    [album3 reloadFigurines];
}

- (void) viewDidLoad {
	emptyFigColor = [UIColor redColor];
	emptyFigFont = [UIFont boldSystemFontOfSize: 24];	
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
	currentAlbum.actualPage = -2;
	
	[self hideToolbar];
	[self removeCurrentPage];
	[self drawCover];
}

- (void) viewDidAppear:(BOOL)animated {
    [UserContext setHelpMapViewStep2: NO];
    //if ([UserContext getHelpAlbum]) return;
	if ([currentAlbum.xmlName isEqualToString: cAlbum1])
		[Sentence playSpeaker: @"AlbumView-ViewDidAppear-Album1Start"];	// Princess World
	else if ([currentAlbum.xmlName isEqualToString: cAlbum2])
		[Sentence playSpeaker: @"AlbumView-ViewDidAppear-Album2Start"];	// Monster World
    else
		[Sentence playSpeaker: @"AlbumView-ViewDidAppear-Album3Start"];	// Animals World
}

-(void) initMusicPlayer {
	
	// Page turn Sound
	//NSURL* soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PageTurn" ofType:@"wav"]];
	//AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundUrl, &pageTurnSoundId);
	
	//soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TillWithBell" ofType:@"wav"]];
	//AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundUrl, &tillSoundId);

    pageTurnSoundId = [Sentence getAudioPlayer: @"PageTurn"];
    tillSoundId = [Sentence getAudioPlayer: @"TillWithBell"];
    
}

- (IBAction)soundClicked { 
	if (UserContext.soundEnabled == YES) { 
		UserContext.soundEnabled = NO;
	} else	{
		UserContext.soundEnabled = YES;
	}
	[self refreshSoundButton];
}

- (IBAction) prevButtonClicked:(id)sender {
    if (helpButton.enabled == NO) return;
    
	[self removeCurrentPage];
	currentAlbum.actualPage--;
	[self drawCurrentPage];
	//AudioServicesPlaySystemSound(pageTurnSoundId);
    [pageTurnSoundId play];
    
	[UIView beginAnimations: @"Turn Page Left" context: nil]; 
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: self.view cache: YES];

	[UIView commitAnimations];
}

- (IBAction) nextButtonClicked:(id)sender {
    if (helpButton.enabled == NO) return;
    
	[self removeCurrentPage];
	currentAlbum.actualPage++;
	[self drawCurrentPage];
	//AudioServicesPlaySystemSound(pageTurnSoundId);
	[pageTurnSoundId play];
    
	[UIView beginAnimations: @"Turn Page Right" context: nil]; 
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: self.view cache: YES];
	[UIView commitAnimations];
}

- (void) removeCurrentPage {
	for (int i=0; i < [figurinesInPage count]; i++) {
		UIView *imageView = [figurinesInPage objectAtIndex: i];
		[imageView removeFromSuperview];
	}
	if (figurinesInPage) [figurinesInPage removeAllObjects];
	
}

- (void) drawCurrentPage {
	AlbumPage *page = [currentAlbum.pages objectAtIndex: currentAlbum.actualPage];
	for (int i=0; i < [page.figurines count]; i++) {
		Figurine *fig = [page.figurines objectAtIndex: i];
		if (fig.wasBought == YES) {
			UIImageView *imageView = [[UIImageView alloc] initWithImage: fig.image];
			[self adjustImage: imageView to: fig];
			[figurinesInPage addObject: imageView];					
		} else {
			UIButtonEmptyFigurine* imageView = [self getEmptyFig: fig index: i];
			[self adjustImage: imageView to: fig];
			[figurinesInPage addObject: imageView];				
		}

	}
	
    nextButton.alpha = currentAlbum.actualPage == [currentAlbum.pages count] - 1 ? 0 : 1;	
    prevButton.alpha = currentAlbum.actualPage == 0 ? 0 : 1;	
    pageLabel.alpha = 1;	
	pageLabel.text = [NSString stringWithFormat:@"Page %i / %lu", currentAlbum.actualPage + 1, (unsigned long)[currentAlbum.pages count]];
}

- (void) refreshEmptyFigs {
	UIView *imageView;
	for (int i=0; i < [figurinesInPage count]; i++) {
		imageView = [figurinesInPage objectAtIndex: i];
		if ([imageView isKindOfClass: [UIButtonEmptyFigurine class]]) {
			[self setAffordable: (UIButtonEmptyFigurine*) imageView];
		}
	}
}

- (void) adjustImage: (UIView*) imageView to: (Figurine*) fig {
    
    // Delta Iphone 5
	CGRect frame = [self adjustFrame: imageView  toSize: fig.size];
	frame.origin.x = fig.x - frame.size.width / 2 + [ImageManager getDeltaWidthIphone5];
	frame.origin.y = fig.y - frame.size.height / 2;
	imageView.frame = frame;
	[self.view addSubview: imageView];
	[self.view bringSubviewToFront: imageView];
}


- (void) drawCover {
	NSString* coverName;
	if ([currentAlbum.xmlName isEqualToString: cAlbum1])
		coverName =  @"cover-princess";
	else if ([currentAlbum.xmlName isEqualToString: cAlbum2])
		coverName =  @"cover-monster";
    else
		coverName =  @"cover-animal";
    
    coverName = [ImageManager getIphone5xIpadFile: coverName];
	[backgroundView setImage: [UIImage imageNamed: coverName]];
	[self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(initializePageAndThenSoundLoop)];
		theTimer.frameInterval = 260;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

-(void) hideToolbar {
	nextButton.alpha = 0;
	prevButton.alpha = 0;
	[self setToolbarAlpha: 0];
	pageLabel.alpha = 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (helpButton.enabled == NO) return;
    
	if (currentAlbum.actualPage < 0) { // Cover
		// Once the cover is touched, we jump to the firts page
		[self initializePageAndThenSoundLoop];
	} else {
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchLocation = [touch locationInView: touch.view];
		[ToolbarController saySentence: touchLocation
			frame1View: money1View.frame
			frame1Label: money1Label.frame
			frame2View: money2View.frame
			frame2Label: money2Label.frame
			frame3View: money3View.frame
			frame3Label: money3Label.frame];
	}
}

-(void) initializePageAndThenSoundLoop {

	if (currentAlbum.actualPage == -2) {
		currentAlbum.actualPage = -1;
		return; // wait 2 second to the next loop.
	} else if (currentAlbum.actualPage == -1) {
        [self initializePage];
        theTimer.frameInterval = 600;
    } else if (![UserContext getHelpAlbum]) {
        if ([currentAlbum.xmlName isEqualToString: cAlbum1])
            [Sentence playSpeaker: @"AlbumView-Loop-Album1"];	// Princess World
        else if ([currentAlbum.xmlName isEqualToString: cAlbum2])
            [Sentence playSpeaker: @"AlbumView-Loop-Album2"];	// Monster World
        else
            [Sentence playSpeaker: @"AlbumView-Loop-Album3"];	// Animals World
    }
    
}

- (void) initializePage {
    [self setToolbarAlpha: 1];
    
	NSString* backgroundName;
	if ([currentAlbum.xmlName isEqualToString: cAlbum1])
		backgroundName =  @"empty-page-princesses";
	else if ([currentAlbum.xmlName isEqualToString: cAlbum2])
		backgroundName =  @"empty-page-monsters";
    else
		backgroundName =  @"empty-page-animals";
	
    backgroundName = [ImageManager getIphone5xIpadFile: backgroundName];
    
	[backgroundView setImage: [UIImage imageNamed: backgroundName]];
	[self refreshSoundButton];
	[self refreshLabels];
	
	if ([UserContext getHelpAlbum]) {
		currentAlbum.actualPage++;
	    hand.alpha = 1;
		[self drawHelpPage];
	} else {
		[self nextButtonClicked: nil];
	}
}

-(void) setToolbarAlpha: (int) aValue {
	backButton.alpha = aValue;
	money1View.alpha = aValue;
	money1Label.alpha = aValue;	
	money2View.alpha = aValue;
	money2Label.alpha = aValue;	
	money3View.alpha = aValue;
	money3Label.alpha = aValue;	
	soundButton.alpha = aValue;
	helpButton.alpha = aValue;
}

- (void) refreshSoundButton {
	NSString *soundImageFile;
	soundImageFile = UserContext.soundEnabled == YES ? @"ico_volume" : @"ico_volume_off";
    soundImageFile = [ImageManager getIphoneIpadFile: soundImageFile];
	[soundButton setImage: [UIImage imageNamed: soundImageFile] forState: UIControlStateNormal];	
	[self.view.layer removeAllAnimations];
}

- (void) refreshLabels {
	money1Label.text = [UserContext getMoney1AsText];
	money2Label.text = [UserContext getMoney2AsText];
	money3Label.text = [UserContext getMoney3AsText];	
}

- (void) showMagnifier: (UIButtonEmptyFigurine*) emptyF at: (CGPoint) touchLocation {

    if (emptyF.fig.image) {
        [previewView setImage: emptyF.fig.image];	

        UIImageView *tempImageView = [[UIImageView alloc] initWithImage: emptyF.fig.image];
        CGRect frame = [self adjustFrame: tempImageView toSize: [ImageManager albumMagnifierSize]];
        tempImageView = nil;
	
        frame.origin.x = touchLocation.x + [ImageManager albumMagnifierDeltaPos];
        frame.origin.y = touchLocation.y + [ImageManager albumMagnifierDeltaPos];
        previewView.frame = frame;	

        previewView.alpha = 1; 
        [self.view bringSubviewToFront: previewView];
    }
}

- (UIButtonEmptyFigurine*) getEmptyFig: (Figurine*) fig index: (int) anIndex {
	UIButtonEmptyFigurine *imageView = [UIButtonEmptyFigurine buttonWithType: UIButtonTypeCustom];

	imageView.fig = fig;
	imageView.index = anIndex;

	NSString *aTitle = [[NSString alloc] initWithFormat:@" $ %i", fig.cost] ;
	[imageView setTitle: aTitle forState: UIControlStateNormal];
	[imageView setTitleColor: emptyFigColor forState: UIControlStateNormal];
	imageView.titleLabel.font = emptyFigFont;
    
    UIImage* tokenSized = [ImageManager imageWithImage: [fig tokenView] scaledToSize: (CGSize) {fig.size/4, fig.size/4}];
        
	[imageView setImage: tokenSized forState: UIControlStateNormal];
	[imageView addTarget: self action: @selector(onEmptyFigClickRepeat:) forControlEvents: UIControlEventTouchDownRepeat];
	[imageView addTarget: self action: @selector(onEmptyFigClick:) forControlEvents: UIControlEventTouchDown];
	[imageView addTarget: self action: @selector(onEmptyFigClickUp:) forControlEvents: UIControlEventTouchUpInside];
	[self setAffordable: (UIButtonEmptyFigurine*) imageView];
	// Set width and height like his hidden figurine
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage: fig.image];
	CGRect frame = [self adjustFrame: tempImageView toSize: fig.size];
	imageView.frame = frame;
	tempImageView = nil;
	
	return imageView;
}	

-(void) setAffordable: (UIButtonEmptyFigurine*) buttonEmptyFig {
	[self setAffordable: buttonEmptyFig to: buttonEmptyFig.fig.canTheUserBuyIt];
}

-(void) setAffordable: (UIButtonEmptyFigurine*) buttonEmptyFig to: (bool) aValue {
	buttonEmptyFig.alpha = aValue ? 1 : 0.7;
	UIImage *imageEmpty = aValue ? [UIImage imageNamed: @"figu-empty.png"] : [UIImage imageNamed: @"figu-empty-no.png"];
	[buttonEmptyFig setBackgroundImage: imageEmpty forState: UIControlStateNormal];
}


-(CGRect) adjustFrame: (UIView*) imageView toSize: (int) aSize {
	CGRect frame = imageView.frame;
	int originalWidth = frame.size.width;
	frame.size.width = aSize;
	frame.size.height = frame.size.height * aSize / originalWidth;
	return frame;
}

// ****** Draw the figurine (if was bought) or the empty fig
// *********************************************************

// *********************************************************
// ****** Buy a Figurine

- (void) onEmptyFigClick: (id) sender {
    if (helpButton.enabled == NO) return;
    
	UIButtonEmptyFigurine *buttonEmptyfig = (UIButtonEmptyFigurine*) sender;
	CGPoint touchLocation = buttonEmptyfig.frame.origin;
	[self showMagnifier: buttonEmptyfig at: touchLocation];
}

- (void) onEmptyFigClickUp: (id) sender {
	previewView.alpha = 0;
}

- (void) onEmptyFigClickRepeat: (id) sender {
    if (helpButton.enabled == NO) return;
    
	UIButtonEmptyFigurine *buttonEmptyfig = (UIButtonEmptyFigurine*) sender;
	if ([buttonEmptyfig.fig canTheUserBuyIt]) {
		[self buyNewFigurine: buttonEmptyfig];
	} else {
		[buttonEmptyfig.fig explainWhyCannotBuyIt];
	}
	previewView.alpha = 0;
}

- (void) buyNewFigurine: (UIButtonEmptyFigurine *) buttonEmptyfig {
//	AudioServicesPlaySystemSound(tillSoundId);
	[tillSoundId play];
    
	buttonEmptyfig.fig.wasBought = YES;
	// Remove the EmtpyFig image
	UIView *oldView = [figurinesInPage objectAtIndex: buttonEmptyfig.index];
	[oldView removeFromSuperview];

	// Add the figurine image
	UIImageView *newView = [[UIImageView alloc] initWithImage: buttonEmptyfig.fig.image];
	[self adjustImage: newView to: buttonEmptyfig.fig];

	[figurinesInPage replaceObjectAtIndex: buttonEmptyfig.index withObject: newView];		
	
	// Start animation
	newView.alpha = 0;
	[UIView beginAnimations: @"Buy New Fig" context: nil]; 
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[buttonEmptyfig.fig buyIt];
	[self refreshLabels];
	newView.alpha = 1;
	[UIView commitAnimations];
	
	[self refreshEmptyFigs];
}

// ****** Buy a Figurine
// *********************************************************

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"didReceiveMemoryWarning in AlbumView");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	//AudioServicesDisposeSystemSoundID(tillSoundId);
	//AudioServicesDisposeSystemSoundID(pageTurnSoundId);
}


// *********************************************************
// ****** Help Animation

- (IBAction) helpClicked {
	[self helpAnimation1];
}

- (void) helpAnimation1 {
    // Make clicking hand visible
	helpButton.enabled = NO;
    backButton.enabled = NO;
	[self.view bringSubviewToFront: hand];
	
    [UIImageView beginAnimations: @"helpAnimation" context: Nil]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation1b)];//@selector(helpAnimation2)];
    [UIImageView setAnimationDuration: .5];
    hand.alpha = 1;
	[self.view bringSubviewToFront: hand];
    [UIImageView commitAnimations];    
}

- (void) helpAnimation1b {
    // Move hande to "next" button
    CGRect frame = hand.frame;
			
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)([NSNumber numberWithInt:2])]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(drawHelpPage)];
    [UIImageView setAnimationDuration: 2];
    frame.origin.x = nextButton.frame.origin.x + nextButton.frame.size.width/2;
    frame.origin.y = nextButton.frame.origin.y + nextButton.frame.size.height/2;
    hand.frame = frame;
    
	[UIImageView commitAnimations];    
}

- (void) drawHelpPage {
	[self removeCurrentPage];
	helpButton.enabled = NO;
    backButton.enabled = NO;
	AlbumPage *page = [currentAlbum.pages objectAtIndex: currentAlbum.actualPage];
	for (int i=0; i < [page.figurines count]; i++) {
		Figurine *fig = [page.figurines objectAtIndex: i];
		if (i == 0) { // First image is always Bought 
			UIImageView *imageView = [[UIImageView alloc] initWithImage: fig.image];
			[self adjustImage: imageView to: fig];
			[figurinesInPage addObject: imageView];					
		} else if (i == 1) { // Second image is not affordable
			UIButtonEmptyFigurine* imageView = [self getEmptyFig: fig index: i];
			[self adjustImage: imageView to: fig];
			[figurinesInPage addObject: imageView];				
			[self setAffordable: imageView to: NO];
		} else {
			UIButtonEmptyFigurine* imageView = [self getEmptyFig: fig index: i];
			[self adjustImage: imageView to: fig];
			[figurinesInPage addObject: imageView];				
			[self setAffordable: imageView to: YES];
		}
	}
	
	[self.view bringSubviewToFront: hand];
    nextButton.alpha = 1;
    prevButton.alpha = 1;
	pageLabel.text = @"Help Page";
	
	//AudioServicesPlaySystemSound(pageTurnSoundId);
	[pageTurnSoundId play];
    
	[UIView beginAnimations: @"Turn Page Right" context: nil]; 
	[UIView setAnimationDuration: 1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: self.view cache: YES];
	[UIView commitAnimations];
	
	[self helpAnimation2];	
}

- (void) helpAnimation2 {
    // Move hand over to the empty fig    
	CGRect frame = hand.frame;
	
	UIView *imageView;
	UIButtonEmptyFigurine *emptyFig;
	imageView = [figurinesInPage objectAtIndex: 1];
	if ([imageView isKindOfClass: [UIButtonEmptyFigurine class]]) 
		emptyFig = (UIButtonEmptyFigurine*) imageView;
	if (!emptyFig) return; // End help animation, since no emptyFig available
    
    [UIImageView beginAnimations: @"helpAnimation" context:Nil]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)]; 
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.origin.x = imageView.frame.origin.x + imageView.frame.size.width/2;
    frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height/2;	
	hand.frame = frame;
	
    [UIImageView commitAnimations];
}


- (void) helpAnimation3 {
    // Scale down to simulate clicking
	[Sentence playSpeaker: @"AlbumView-help1"];	
    
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)([NSNumber numberWithInt:0])]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation4:finished:context:)]; 
    [UIImageView setAnimationDuration: .15];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = hand.frame;
    frame.size.width = frame.size.width * .9;
    frame.size.height = frame.size.height * .9;
	hand.frame = frame;
    
    [UIImageView commitAnimations];
}

- (void) helpAnimation4:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    if ([figurinesInPage count] == 0) return;
	UIButtonEmptyFigurine* emptyFig = (UIButtonEmptyFigurine*) [figurinesInPage objectAtIndex: 1];


	emptyFig.selected = YES;	
	CGPoint touchLocation = emptyFig.frame.origin;
	[self showMagnifier: emptyFig at: touchLocation];
    previewView.alpha = 0; 
	
	// Show Preview 
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)(emptyFig)];
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation5:finished:context:)]; 
    [UIImageView setAnimationDuration: 4];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
	
    previewView.alpha = 1; 
    [UIImageView commitAnimations];
	
}

- (void) helpAnimation5: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context {
    previewView.alpha = 0; 	
	
    // Scale up to simulate unclicking

    [UIImageView beginAnimations: @"helpAnimation" context: Nil]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)]; 
    [UIImageView setAnimationDuration: .15];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    CGRect frame = hand.frame;
    frame.size.width = frame.size.width / .9;
    frame.size.height = frame.size.height / .9;
	hand.frame = frame;
    
    [UIImageView commitAnimations];
}

- (void) helpAnimation6 {
    //Move hand to buyable sticker
    CGRect frame = hand.frame;
	[Sentence playSpeaker: @"AlbumView-help2"];		
	UIView *imageView;
	//UIButtonEmptyFigurine *emptyFig;
    if ([figurinesInPage count] == 0) return;
	imageView = [figurinesInPage objectAtIndex: 2];
	//if ([imageView isKindOfClass: [UIButtonEmptyFigurine class]]) 
	//	emptyFig = (UIButtonEmptyFigurine*) imageView;
	//if (!emptyFig) return; // End help animation, since no emptyFig available
    
    [UIImageView beginAnimations: @"helpAnimation" context: (__bridge void *)([NSNumber numberWithInt:7])]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimationClick:finished:context:)]; 
    [UIImageView setAnimationDuration: 1.5];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.origin.x = imageView.frame.origin.x + imageView.frame.size.width/2;
    frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height/2;	
	hand.frame = frame;
    
    
    [UIImageView commitAnimations];
}

- (void) helpAnimation7:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {

    // click again
    [self helpAnimationClick: @"theAnimation" finished:FALSE context:(__bridge void *)([NSNumber numberWithInt:8])];
}

- (void) helpAnimation8:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    if ([figurinesInPage count] == 0) return;

	UIButtonEmptyFigurine* buttonEmptyfig = (UIButtonEmptyFigurine*) [figurinesInPage objectAtIndex: 2];
	//AudioServicesPlaySystemSound(tillSoundId);
	[tillSoundId play];
    
	//buttonEmptyfig.fig.wasBought = YES;
	// Remove the EmtpyFig image
	UIView *oldView = [figurinesInPage objectAtIndex: buttonEmptyfig.index];
	[oldView removeFromSuperview];
	
	// Add the figurine image
	UIImageView *newView = [[UIImageView alloc] initWithImage: buttonEmptyfig.fig.image];
	[self adjustImage: newView to: buttonEmptyfig.fig];
	
	[figurinesInPage replaceObjectAtIndex: buttonEmptyfig.index withObject: newView];		
	
	// Start animation
	newView.alpha = 0;
	[UIView beginAnimations: @"Buy New Fig" context: nil]; 
	[UIView setAnimationDuration: 1];
	[UIView setAnimationDelegate: self]; 
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector: @selector(helpAnimation9:finished:context:)]; 
	
	newView.alpha = 1;
	[UIView commitAnimations];

}

- (void) helpAnimation9:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    //Move hand to "prev" button
    CGRect frame = hand.frame;
   	[self.view bringSubviewToFront: hand];

    [UIImageView beginAnimations: @"helpAnimation" context:Nil]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation10:finished:context:)]; 
    [UIImageView setAnimationDuration: 1.5];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
	frame.origin.x = prevButton.frame.origin.x + prevButton.frame.size.width/2;
    frame.origin.y = prevButton.frame.origin.y + prevButton.frame.size.height/2;	
	hand.frame = frame;
	
    [UIImageView commitAnimations];
}

- (void) helpAnimation10:(NSString *)theAnimation finished:(BOOL)flag context:(void *)context {
    CGRect frame = hand.frame;
    
    [UIImageView beginAnimations: @"helpAnimation" context:Nil]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationDuration: .15];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation11)]; 
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    frame.size.width = frame.size.width*.9;
    frame.size.height = frame.size.height*.9;
	hand.frame = frame;
    
    [UIImageView commitAnimations];    
}

- (void) helpAnimation11 {
	[self removeCurrentPage];
	[self drawCurrentPage];

	//AudioServicesPlaySystemSound(pageTurnSoundId);
    [pageTurnSoundId play];
    
    hand.alpha = 0;
    CGRect frame = hand.frame;
    frame.origin.x = 100;
    frame.origin.y = 50;
    hand.frame = frame;
    helpButton.enabled = YES;
    backButton.enabled = YES;
	[UIView beginAnimations: @"Turn Page Left" context: nil]; 
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: self.view cache: YES];
	
	[UIView commitAnimations];
	
	[UserContext setHelpAlbum: NO];
}

- (void) helpAnimationClick: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context {
    // Double Click:    Scale Down 2nd time
     
    CGRect frame = hand.frame;
    
    [UIImageView beginAnimations: @"helpAnimation" context:context]; 
    [UIImageView setAnimationDelegate: self]; 
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimationRelease:finished:context:)]; 
    [UIImageView setAnimationDuration: .15];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    frame.size.width = frame.size.width*.9;
    frame.size.height = frame.size.height*.9;
	hand.frame = frame;
    
    [UIImageView commitAnimations];
}

- (void) helpAnimationRelease: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context {
    // Double Click:    Scale Up 2nd time
    int t = [((__bridge NSNumber*) context) intValue];
	
    CGRect frame = hand.frame;
    
    [UIImageView beginAnimations: @"helpAnimation" context: Nil]; 
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationDuration: .15];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    
    frame.size.width = frame.size.width/.9;
    frame.size.height = frame.size.height/.9;
	hand.frame = frame;
	
    switch (t) {
        case 2:
            [UIImageView setAnimationDidStopSelector: @selector(helpAnimation2:finished:context:)]; 
            break;
        case 7:
            [UIImageView setAnimationDidStopSelector: @selector(helpAnimation7:finished:context:)]; 
            break;
        case 8:
            [UIImageView setAnimationDidStopSelector: @selector(helpAnimation8:finished:context:)];
            break;
        default:
            break;
    }
    [UIImageView commitAnimations];
}

// ****** Help Animation
// *********************************************************

@end
