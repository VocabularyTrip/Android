  //
  //  LevelView.m
  //  VocabularyTrip2
  //
  //  Created by Ariel Jadzinsky on 8/6/11.
  //  Copyright 2011 VocabularyTrip. All rights reserved.
  //

#import "LevelView.h"
#import "UserContext.h"
#import "Word.h"
#import "Vocabulary.h"
#import "Album.h"
#import "Sentence.h"
#import "VocabularyTrip2AppDelegate.h"

@implementation LevelView

@synthesize page;
@synthesize backButton;

@synthesize levelText;
@synthesize prevVersionText;
@synthesize levelBoughtText;
@synthesize saveButton;

@synthesize word1Button;
@synthesize word2Button;
@synthesize word3Button;
@synthesize wordHelpButton;
@synthesize word1Label;
@synthesize word2Label;
@synthesize word3Label;
@synthesize trainLabel;
@synthesize coinView;

@synthesize train;
@synthesize wagon1;
@synthesize wagon2;
@synthesize wagon3;
@synthesize driverView;
@synthesize langView;
@synthesize wheel1;
@synthesize wheel2;
@synthesize wheel3;
@synthesize wheel4;
@synthesize wheel5;
@synthesize wheel6;
@synthesize wheel7;
@synthesize wheel8;
@synthesize wheel9;

@synthesize nextButton;
@synthesize prevButton;
@synthesize imageView;
@synthesize wordNamelabel;
@synthesize nativeWordNamelabel;
//@synthesize alertDownloadSounds;

@synthesize hand;
@synthesize helpButton;
@synthesize buyButton;
@synthesize backgroundView;

@synthesize progressBackView;
@synthesize progressMaskView;
@synthesize progressFillView;
@synthesize startWithHelpPurchase;
@synthesize startWithHelpDownload;

- (IBAction)done:(id)sender {
	VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
	[vocTripDelegate popMainMenuFromLevel];
	[theTimer invalidate];
	theTimer = nil;
	[theTimerAnimator invalidate];
	theTimerAnimator = nil;

	[self purgeLevel];

    [super done: sender];
}

- (void) viewWillAppear:(BOOL)animated {
  [self refreshLevelInfo];
  
  User *user = [UserContext getUserSelected];
  [driverView setImage: user.image];
  
  Language *lang = [UserContext getLanguageSelected];
  [langView setImage: lang.image];
  
  [super viewWillAppear: animated];
}

- (void) viewDidAppear:(BOOL)animated {
    if ([UserContext getHelpLevel] || startWithHelpPurchase) [self helpAnimation1];
    if (startWithHelpPurchase && ![Vocabulary isDownloadCompleted]) [self startLoading];
    if (startWithHelpDownload) [self helpDownload1];
    startWithHelpDownload = 0;
    startWithHelpPurchase = 0;
    [super viewDidAppear: animated];

    [self initializeTimerAnimator];
}

- (void) initializeTimerAnimator {
	if (theTimerAnimator == nil) {
		theTimerAnimator = [CADisplayLink displayLinkWithTarget:self selector:@selector(randomAvatarAnimation)];
		theTimerAnimator.frameInterval = 400;
		[theTimerAnimator addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) randomAvatarAnimation {
    int i = arc4random() % 6;
    switch (i) {
        case 0:
            [AnimatorHelper avatarGreet: driverView];
            break;
        case 1:
            [AnimatorHelper avatarBlink: driverView];
            break;
        case 2:
            [AnimatorHelper avatarOk: driverView];
            break;
        default:
            [AnimatorHelper avatarBlink: driverView];
            break;
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self shiftTrain: [ImageManager getDeltaWidthIphone5]];
    [self shiftImageAndWordIphone5];
    
    // ************************
    // ***** Debug mode
  
    levelBoughtText.enabled = [activeConfig isEqualToString: @"Debug"] ? YES : NO;
	levelText.alpha = [activeConfig isEqualToString: @"Debug"] ? 1 : 0;
	saveButton.alpha = [activeConfig isEqualToString: @"Debug"] ? 1 : 0;
	levelBoughtText.alpha = [activeConfig isEqualToString: @"Debug"] ? 1 : 0;
	saveButton.alpha = [activeConfig isEqualToString: @"Debug"] ? 1 : 0;
    prevVersionText.alpha = [activeConfig isEqualToString: @"Debug"] ? 1 : 0;
  
    // ***** Debug mode
    // ************************
  
	wordNamelabel.alpha = 0;
	nativeWordNamelabel.alpha = 0;
	imageView.alpha = 0;
  
	NSURL* soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PageTurn" ofType:@"wav"]];
	AudioServicesCreateSystemSoundID((__bridge   CFURLRef) soundUrl, &pageTurnSoundId);
    
	originalframeImageView = imageView.frame;
    originalframeWord1ButtonView = word1Button.frame;
    originalframeWord2ButtonView = word2Button.frame;
    originalframeWord3ButtonView = word3Button.frame;
}

- (void) updateLevelSlider {
  
    int level = [UserContext getLevel] - 1;
    int i = level / 3;
    if (i == page) {
        progressBackView.alpha = 1;
        progressFillView.alpha = 1;
        progressMaskView.alpha = 1;
    
        CGRect frame = progressMaskView.frame;
        CGRect frameFill = progressBackView.frame;
        int deltaWidth = frameFill.size.width;
    
        CGRect frameOrigin;
    
        int r = level % 3;
        if (r==0) frameOrigin = wagon1.frame;
        if (r==1) frameOrigin = wagon2.frame;
        if (r==2) frameOrigin = wagon3.frame;
    
        //        int deltaX = frameOrigin.origin.x;
    
        float progress = [Vocabulary wasLearned] / 1;
        progress = [Vocabulary progressIndividualLevel]; // Overwrite with new formula
    
        frame.size.width = deltaWidth * (1-progress);
        frame.origin.x = frameOrigin.origin.x + (deltaWidth * progress);
        progressMaskView.frame = frame;
    
        frameFill.origin.x = frameOrigin.origin.x;
        progressBackView.frame = frameFill;
    
        frameFill = progressFillView.frame;
        frameFill.origin.x = frameOrigin.origin.x;
        progressFillView.frame = frameFill;
    
  } else {
      progressBackView.alpha = 0;
      progressFillView.alpha = 0;
      progressMaskView.alpha = 0;
  }
    
}

- (void) shiftTrain: (int) xPix {
  
	CGRect frame = train.frame;
	frame.origin.x = frame.origin.x + xPix;
	train.frame = frame;
  
	frame = driverView.frame;
	frame.origin.x = frame.origin.x + xPix;
	driverView.frame = frame;
  
    frame = langView.frame;
	frame.origin.x = frame.origin.x + xPix;
	langView.frame = frame;
  
	frame = wagon1.frame;
	frame.origin.x = frame.origin.x + xPix;
	wagon1.frame = frame;
  
	frame = wagon2.frame;
	frame.origin.x = frame.origin.x + xPix;
	wagon2.frame = frame;
  
	frame = wagon3.frame;
	frame.origin.x = frame.origin.x + xPix;
	wagon3.frame = frame;
  
	frame = word1Button.frame;
	frame.origin.x = frame.origin.x + xPix;
	word1Button.frame = frame;
  
	frame = word2Button.frame;
	frame.origin.x = frame.origin.x + xPix;
	word2Button.frame = frame;
  
	frame = word3Button.frame;
	frame.origin.x = frame.origin.x + xPix;
	word3Button.frame = frame;

    frame = wordHelpButton.frame;
	frame.origin.x = frame.origin.x + xPix;
	wordHelpButton.frame = frame;
    
    frame = word1Label.frame;
	frame.origin.x = frame.origin.x + xPix;
	word1Label.frame = frame;
  
	frame = word2Label.frame;
	frame.origin.x = frame.origin.x + xPix;
	word2Label.frame = frame;
  
	frame = word3Label.frame;
	frame.origin.x = frame.origin.x + xPix;
	word3Label.frame = frame;
  
	frame = wheel1.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel1.frame = frame;
  
	frame = wheel2.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel2.frame = frame;
  
	frame = wheel3.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel3.frame = frame;
  
	frame = wheel4.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel4.frame = frame;
  
	frame = wheel5.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel5.frame = frame;
  
	frame = wheel6.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel6.frame = frame;
  
	frame = wheel7.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel7.frame = frame;
  
    frame = wheel8.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel8.frame = frame;
  
    frame = wheel9.frame;
	frame.origin.x = frame.origin.x + xPix;
	wheel9.frame = frame;
  
}


- (void) refreshLevelInfo {
  
    NSString *coverName;
    coverName = [ImageManager getIphone5xIpadFile: @"empty-page-monsters"];
    [backgroundView setImage: [UIImage imageNamed: coverName]];
  
	levelText.text = [NSString stringWithFormat: @"%d", [UserContext getLevel]];
	levelBoughtText.text = [NSString stringWithFormat: @"%d", [UserContext getMaxLevel]];
  
	imageView.alpha = 0;
	prevButton.alpha = page > 0 ? 1 : 0;
    // ******** change 400 words
	nextButton.alpha = page < ([Vocabulary countOfLevels] / 3) - 1 ? 1 : 0 ;
  
    // ******** change 400 words - Pending
    // Ya no aplica que cada p[agina corresponda a un tipo de moneda.
	if (page == 0) {
		coinView.image = [UIImage imageNamed: @"token-bronze.png"];
		trainLabel.text = @"Bronze Level";
	}
	if (page == 1) {
		coinView.image = [UIImage imageNamed: @"token-silver.png"];
		trainLabel.text = @"Silver Level";
	}
	if (page == 2) {
		coinView.image = [UIImage imageNamed: @"token-gold.png"];
		trainLabel.text = @"Gold Level";
	}
    
	[self setImageToButton: 0];
	[self setImageToButton: 1];
	[self setImageToButton: 2];
  
    [self updateLevelSlider];
  
}

// Hay que sacarlos.... din[amicamente. dejarlo para la reingenieria con mapa para ver que es mejor.
-(void) addBuyIcon: (CGPoint) pos {
    UIImage *image = [UIImage imageNamed: @"BuyButton.png"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage: image];

    CGRect frame = iconView.frame;
    frame.origin = pos;
    frame.size.width = 50;
    frame.size.height = 50;
    iconView.frame = frame;
    [ImageManager fitImage: image inImageView: iconView];

    [self.view addSubview: iconView];
    [self.view bringSubviewToFront: iconView];
}

- (void) setImageToButton: (int) i {
  
    UIButton* wordButton;
    UILabel *wordLabel;
	if (i==0) {
        wordButton = word1Button;
        wordLabel = word1Label;
        wordButton.frame = originalframeWord1ButtonView;
    }
    
	if (i==1) {
        wordButton = word2Button;
        wordLabel = word2Label;
        wordButton.frame = originalframeWord2ButtonView;
    }
	if (i==2) {
        wordButton = word3Button;
        wordLabel = word3Label;
        wordButton.frame = originalframeWord3ButtonView;
    }

	int levelNumber = page * 3 + i;
	Level* level = [UserContext getLevelAt: levelNumber];
    
	if (levelNumber >= [UserContext getMaxLevel] && levelNumber != 0) {		// Buy - Hardcoded First level is free
        // Add $$ image
        [self addBuyIcon: wordButton.frame.origin];
	} else if (levelNumber >= [UserContext getLevel] && levelNumber != 0) {	// Locked - Hardcoded First level is free
        // Add lock image
        [self addBuyIcon: wordButton.frame.origin];
	}
    
    wordLabel.text = level.levelName;
    [ImageManager fitImage: level.image inButton: wordButton];

}

- (void) purgeLevel {
  
    // ******** change 400 words
	if (page >=0 && page < [Vocabulary countOfLevels]) {
		Level* level = [UserContext getLevelAt: page * 3 + 0];
		[level purge];
    
		level = [UserContext getLevelAt: page * 3 + 1];
		[level purge];
    
		level = [UserContext getLevelAt: page * 3 + 2];
		[level purge];
	}
}


- (IBAction) testAllSounds:(id)sender {
  NSLog(@"******************************************");
  NSLog(@"************* Test All Sounds*************");
  [Sentence testAllSentences];
  [Vocabulary testAllSounds];
  NSLog(@"************** End Test ******************");
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) aButtonIndex {
	switch (aButtonIndex) {
		case 0:
			break;
		case 1:
			[[UserContext getSingleton] resetGame];
			[self refreshLevelInfo];
			break;
		default:
			break;
	}
}

- (IBAction) word1ButtonClicked {
	buttonIndex = 0;
	[self showAndSayDictionary: page * 3 + buttonIndex];
}

- (IBAction) word2ButtonClicked {
	buttonIndex = 1;
	[self showAndSayDictionary: page * 3 + buttonIndex];
}

- (IBAction) word3ButtonClicked {
	buttonIndex = 2;
	[self showAndSayDictionary: page * 3 + buttonIndex];
}

- (IBAction) prevButtonClicked {
    if (helpButton.enabled == NO) {
        [self cancelAnimation];
        [self cancelAllAnimations];
    }
	[self purgeLevel];
	page--;
    [self refreshPage];
}

- (IBAction) nextButtonClicked {
    if (helpButton.enabled == NO) {
        [self cancelAnimation];
        [self cancelAllAnimations];
    }
	[self purgeLevel];
	page++;
    [self refreshPage];
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

- (void) refreshPage {
	[self refreshLevelInfo];
	AudioServicesPlaySystemSound(pageTurnSoundId);
    
	[self cancelAnimation];
    
	[UIView beginAnimations: @"Turn Page Right" context: nil];
	[UIView setAnimationDuration: 1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: self.view cache: YES];
	[UIView commitAnimations];
    flagCancelAllSounds = 0;
}

  // The button in the debug mode to save ad-hoc the information
- (IBAction) save:(id)sender {
	[[UserContext getUserSelected] setLevel: [levelText.text intValue]];
	[[UserContext getSingleton] setMaxLevel: [levelBoughtText.text intValue]];
  
    [[NSUserDefaults standardUserDefaults] setObject: prevVersionText forKey:@"prevStartupVersions"];
    [[UserContext getUserSelected] setMoney1: 1000];
    [[UserContext getUserSelected] setMoney2: 1000];
    [[UserContext getUserSelected] setMoney3: 1000];
  
	[self refreshLevelInfo];
}

/*- (IBAction) jumpDownloadDictionary {
  [self done: nil];
  VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
  [vocTripDelegate pushUserLangResumView];
}*/

- (void) showAndSayDictionary: (int) i {
    //if (i > 0 && [UserContext getMaxLevel] == 0) return;
    if (helpButton.enabled == NO) [self cancelAnimation];
	[Vocabulary initializeLevelAt: i];
	helpButton.enabled = NO;
	[self initializeTimer];
}

- (void) initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(showAndSayWord)];
		theTimer.frameInterval = 120;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	}
}

- (void) showAndSayWord {
  
	Word *word;
	word = [Vocabulary getOrderedWord];
    
	if ((word != nil)) {
        imageView.frame = originalframeImageView;
        [ImageManager fitImage: word.image inImageView: imageView];
		wordNamelabel.text = word.translatedName;
        if (![wordNamelabel.text isEqualToString: word.localizationName])
           nativeWordNamelabel.text =  word.localizationName;
        else
           nativeWordNamelabel.text = @"";

		imageView.alpha = 1;
		wordNamelabel.alpha = 1;
        nativeWordNamelabel.alpha = 1;
		if (![word playSound] && !singletonVocabulary.isDownloading) {
           if (angle==0) {    // I want this help to start only if it is not running already. Not to start every time it tries to say a word that does not exist.
               [self helpDownload1];
               angle = 1;
           }
        }
	} else {
		[self cancelAnimation];
		[self helpLevel: buttonIndex + page * 3];
	}
}

- (void) shiftImageAndWordIphone5 {
    int delta = [ImageManager getDeltaWidthIphone5];

	CGRect frame = imageView.frame;
	frame.origin.x = frame.origin.x + delta;
	imageView.frame = frame;
    
	frame = wordNamelabel.frame;
	frame.origin.x = frame.origin.x + delta;
	wordNamelabel.frame = frame;

    frame = nativeWordNamelabel.frame;
	frame.origin.x = frame.origin.x + delta;
	nativeWordNamelabel.frame = frame;
}

/*-(void) showAlertDownloadSounds {
  
    // alertDownloadSounds.alpha = 0.0;
	[UIImageView beginAnimations: @"helpAnimation" context: Nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDuration: 0.8];
    //[UIImageView setAnimationRepeatAutoreverses: YES];
  [UIImageView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
	[UIImageView setAnimationDidStopSelector: @selector(alertDownloadSoundsFinished)];
  
  alertDownloadSounds.alpha = 0.8;
	[UIImageView commitAnimations];
}

- (void) alertDownloadSoundsFinished {
    //alertDownloadSounds.alpha = 0.0;
}*/

-(void) cancelAnimation {
	imageView.alpha = 0;
	wordNamelabel.alpha = 0;
    nativeWordNamelabel.alpha = 0;
	helpButton.enabled = YES;
	if (theTimer) [theTimer invalidate];
	theTimer = nil;
}

-(void) helpLevel: (int) i {
    // the user reach the last level
	if ([UserContext getLevel] >= cLimitLevelGold) return;
  
	if ([UserContext getLevel] >= (i+1))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-LearnThisLevel"];
	else if ([UserContext getLevel] < (i+1))
		[Sentence playSpeaker: @"LevelView-DidSelectRow-UnlockLevel"];
}

- (IBAction) buyClicked {
  VocabularyTrip2AppDelegate *vocTripDelegate = (VocabularyTrip2AppDelegate*) [[UIApplication sharedApplication] delegate];
  [vocTripDelegate pushPurchaseView];
}

  // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
  return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	NSLog(@"didReceiveMemoryWarning in LevelView");
}

- (void)viewDidUnload {
  [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	AudioServicesDisposeSystemSoundID(pageTurnSoundId);
}

  // *****************************
  // ***** Help Animation

- (IBAction) helpClicked {
    if (flagCancelAllSounds) return;
    // Before start help, we move to the page where the user is located.
    // We need the page where the progress bar is visible
    int level = [UserContext getLevel] - 1;
    int i = level / 3;
    if (i != page) {
        page = i;
        [self refreshPage];
    }
    
	[self helpAnimation1];
}

- (void) helpAnimation1 {
    if (flagCancelAllSounds) return;    
	helpButton.enabled = NO;
  
    // Make clicking hand visible
	[UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2)];
	[UIImageView setAnimationDuration: .5];
	hand.alpha = 1;
	[UIImageView commitAnimations];
}

- (void) helpAnimation2 {
    if (flagCancelAllSounds) return;    
    // bring clicking hand onto the corresponding wagon
	CGRect handFrame = hand.frame;
	[Sentence playSpeaker: @"Level_helpA"];
  
	handFrame.origin.y = word2Button.frame.origin.y + word2Button.frame.size.width / 2;
	handFrame.origin.x = word2Button.frame.origin.x + word2Button.frame.size.width / 2;
	[UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation3)];
    //	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation2b:finished:context:)];
	[UIImageView setAnimationDuration: 2];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	hand.frame = handFrame;
	[UIImageView commitAnimations];
}

- (void) helpAnimation3 {
    if (flagCancelAllSounds) return;
    // click down
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation4)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation4 {
    if (flagCancelAllSounds) return;
    // release click
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpAnimation5)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpAnimation5 {
    if (flagCancelAllSounds) return;
    // do nothing, change alpha to .99 and in next help back to 1
    if ([UserContext getMaxLevel] < 6) {
        [self helpEnd1];
        return;
    }
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation6)];
    [UIImageView setAnimationDuration: 4];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    hand.alpha=.99;
    [UIImageView commitAnimations];
}

- (void) helpAnimation6 {
    if (flagCancelAllSounds) return;    
    // go over to $ symbol
    CGPoint center = hand.center;
  
    int levelNumber = page * 3 + 2; // Hardcoded help is the third button in the current page.
	Level* level = [UserContext getLevelAt: levelNumber];
    [wordHelpButton setImage: level.image forState: UIControlStateNormal];

    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation7Pre)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center.x = word3Button.center.x + word3Button.frame.size.width/2 + word3Button.frame.size.width/2*cos(angle);
    //NSLog(@"angle: %f, x: %f, with: %f, cos: %f", angle, center.x, word3Button.frame.size.width, cos(angle));

    center.y = word3Button.center.y + word3Button.frame.size.height/2 - word3Button.frame.size.height/2*sin(angle);
  
    hand.center = center;
    hand.alpha = 1;
    
    //wordHelpButton.center = center;
    word3Button.alpha = 0;
    wordHelpButton.alpha = 1;
    [UIImageView commitAnimations];
}

- (void) helpAnimation7Pre {
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Level_helpB"];
    [self helpAnimation7];
}

- (void) helpAnimation7 {
    // hover over lock button
    if (flagCancelAllSounds) return;
    CGPoint center = hand.center;
//    if (angle<M_PI) {
//        [Sentence playSpeaker: @"Level_helpB"];
//    }

    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>4*M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation8)];
    } else {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation7)];
    }
    [UIImageView setAnimationDuration: .001];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center.x = word3Button.center.x + word3Button.frame.size.width/2 + word3Button.frame.size.width/2*cos(angle);
    center.y = word3Button.center.y + word3Button.frame.size.height/2 - word3Button.frame.size.height/2*sin(angle);
    hand.center = center;
  
    angle += M_PI/100;
    [UIImageView commitAnimations];
}

- (void) helpAnimation8 {
    // do nothing, change alpha to .99 and in next help back to 1
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"Level_helpC"];
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation8B)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    hand.alpha = .99;
    [UIImageView commitAnimations];
}

- (void) helpAnimation8B {
    // do nothing, change alpha to .99 and in next help back to 1
    if (flagCancelAllSounds) return;
    
	[Sentence playSpeaker: @"Level_helpC"];
    CGPoint center = hand.center;
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation9Pre)];
    [UIImageView setAnimationDuration: 4];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center.x = center.x+1;
    hand.center = center;
    hand.alpha = 1;
    
    int levelNumber = page * 3 + 2; // Hardcoded help is the third button in the current page.
	Level* level = [UserContext getLevelAt: levelNumber];
    [wordHelpButton setImage: level.image forState: UIControlStateNormal];
    [UIImageView commitAnimations];
}

- (void) helpAnimation9Pre {
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Level_helpD"];
    [self helpAnimation9];
}

- (void) helpAnimation9 {
    // hover over lock button
    if (flagCancelAllSounds) return;
//    if (angle<4.5*M_PI)
//        [Sentence playSpeaker: @"Level_helpD"];
    CGPoint center = hand.center;
  
    //NSLog(@"angle is: %g", angle);
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>8*M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation10)];
    } else {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation9)];
    }
    [UIImageView setAnimationDuration: .001];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center.x = word3Button.center.x + word3Button.frame.size.width/2 + word3Button.frame.size.width/2*cos(angle);
    center.y = word3Button.center.y + word3Button.frame.size.height/2 - word3Button.frame.size.height/2*sin(angle);
    hand.center = center;
  
    angle += M_PI/100;
    [UIImageView commitAnimations];
}

- (void) helpAnimation10 {
    // goto progress bar
    if (flagCancelAllSounds) return;
    CGPoint center = hand.center;
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation11Pre)];
    [UIImageView setAnimationDuration: 3];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center = progressMaskView.center;
    center.x = center.x + progressMaskView.frame.size.width/2;
    center.y = center.y + 2*progressMaskView.frame.size.height;
    hand.center = center;
    wordHelpButton.alpha = 0;
    word3Button.alpha = 1;
    angle=0;
    [UIImageView commitAnimations];
}

- (void) helpAnimation11Pre {
    if (flagCancelAllSounds) return;
	[Sentence playSpeaker: @"Level_helpE"];
    [self helpAnimation11];
}

- (void) helpAnimation11 {
    // hover over progress bar
    if (flagCancelAllSounds) return;

    CGPoint center = hand.center;
  
    //NSLog(@"angle is: %g", angle);
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    if (angle>4*M_PI) {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation12)];
    } else {
        [UIImageView setAnimationDidStopSelector: @selector(helpAnimation11)];
    }
    [UIImageView setAnimationDuration: .001];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center.x = progressMaskView.center.x + progressMaskView.frame.size.width/2*cos(angle);
    center.y = progressMaskView.center.y + 2*progressMaskView.frame.size.height - progressMaskView.frame.size.height/2*sin(angle);
    hand.center = center;
  
    angle += M_PI/100;
    [UIImageView commitAnimations];
}

- (void) helpAnimation12 {
    // do nothing, change alpha to .99 and in next help back to 1
    if (flagCancelAllSounds) return;
    
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpAnimation13)];
    [UIImageView setAnimationDuration: 2];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.alpha=.99;
  
    [UIImageView commitAnimations];
}

- (void) helpAnimation13 {

    [UserContext setHelpLevel: NO];
    if (flagCancelAllSounds) return;
    // do nothing, change alpha to .99 and in next help back to 1
    [Sentence playSpeaker:@"Level_helpF"];
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpEnd1)];
    [UIImageView setAnimationDuration: 4];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
    hand.alpha=1;
  
    [UIImageView commitAnimations];
}

-(void) helpEnd1{
    // hand dissapears
    if (flagCancelAllSounds) return;
    helpButton.enabled = YES;
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpEnd2)];
    [UIImageView setAnimationDuration: .5];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    hand.alpha = 0;
  
    [UIImageView commitAnimations];
}

-(void) helpEnd2{
    // get hand to original position
    if (flagCancelAllSounds) return;
    [UserContext setHelpLevel: NO];
    
    CGPoint center = hand.center;
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDuration: .01];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    center = progressMaskView.center;
    hand.center = center;
    angle = 0;      // set angle to 0 to restart animation if needed
  
    [UIImageView commitAnimations];
}

-(void) helpDownload1{
    // Make clicking hand visible
    if (flagCancelAllSounds) return;
    helpButton.enabled = NO;
  
    [UIImageView beginAnimations: @"helpAnimation" context: ( void *)(hand)];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpDownload2)];
    [UIImageView setAnimationDuration: .5];
    hand.alpha = 1;
    [UIImageView commitAnimations];
}

-(void) helpDownload2 {
    // bring clicking hand onto Download button
    if (flagCancelAllSounds) return;    
    [Sentence playSpeaker: @"Download_Help_1"];
  
    [UIImageView beginAnimations: @"helpAnimation" context:(__bridge void *)([NSNumber numberWithInt:0])];
    [UIImageView setAnimationDelegate: self];
    [UIImageView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIImageView setAnimationDidStopSelector: @selector(helpDownload3)];
  
    [UIImageView setAnimationDuration: 6];
    [UIImageView setAnimationBeginsFromCurrentState: YES];
  
    CGPoint center = confirmUserLangButton.center;
    center.y = center.y + hand.frame.size.height/2;
    hand.center = center;
  
    [UIImageView commitAnimations];
}

- (void) helpDownload3 {
    // click down
    if (flagCancelAllSounds) return;
    [Sentence playSpeaker: @"Download_Help_2"];
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload4)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width*.9;
	frame.size.height = frame.size.height*.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpDownload4 {
    // release click
    if (flagCancelAllSounds) return;    
	CGRect frame = hand.frame;
  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload5)];
	[UIImageView setAnimationDuration: .15];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
	frame.size.width = frame.size.width/.9;
	frame.size.height = frame.size.height/.9;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpDownload5 {
    // Wait before restarting this help
    if (flagCancelAllSounds) return;
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpDownload6)];
	[UIImageView setAnimationDuration: 3];
	[UIImageView setAnimationBeginsFromCurrentState: YES];
  
  CGRect frame = hand.frame;
	frame.size.width = frame.size.width*.99;
	frame.size.height = frame.size.height*.99;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}

- (void) helpDownload6 {
    // Wait before restarting this help
    if (flagCancelAllSounds) return;  
	[UIImageView beginAnimations: @"helpAnimation" context: nil];
	[UIImageView setAnimationDelegate: self];
	[UIImageView setAnimationDidStopSelector: @selector(helpEnd1)];
	[UIImageView setAnimationDuration: .9];
	[UIImageView setAnimationBeginsFromCurrentState: YES];

    CGRect frame = hand.frame;
	frame.size.width = frame.size.width/.99;
	frame.size.height = frame.size.height/.99;
	hand.frame = frame;
  
	[UIImageView commitAnimations];
}


@end
