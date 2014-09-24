//
//  Album.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/9/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>	
#import "Album.h"
#import "UIButtonEmptyFigurine.h"
#import "UserContext.h"

#define cComeFromMenu 1
#define cComeFromPlaying 2

@interface AlbumView : UIViewController {
	// ***********************
	// *** Toolbar	
	UIImageView *__unsafe_unretained backgroundView;
	UIButton *__unsafe_unretained backButton;
	UIButton *__unsafe_unretained soundButton;
	UIView *__unsafe_unretained money1View;
	UILabel *__unsafe_unretained money1Label;	
	UIView *__unsafe_unretained money2View;
	UILabel *__unsafe_unretained money2Label;	
	UIView *__unsafe_unretained money3View;
	UILabel *__unsafe_unretained money3Label;	
	UIImageView *__unsafe_unretained hand;
	UIButton *__unsafe_unretained helpButton;
	// *** Toolbar	
	// ***********************
	
	// ***********************
	// *** Navigation
	UILabel *__unsafe_unretained pageLabel;
	UIButton *__unsafe_unretained prevButton;
	UIButton *__unsafe_unretained nextButton;
	// *** Navigation
	// ***********************

	Album *album1;			// Album Princess. this object hold all figurines
	Album *album2;			// Album Monsters. this object hold all figurines
	Album *album3;			// Album Animals. this object hold all figurines
	Album *currentAlbum;	// This variable is a pionter to the Album viewed at the moment (the selected album)
	NSMutableArray *figurinesInPage; // This array is used to draw the page

	IBOutlet UIImageView *previewView; // the content of the magnifier. Is dynamic the image is replaced when the magnifier is over an emptu page
	
	AVAudioPlayer* pageTurnSoundId;	// Page turn
	AVAudioPlayer* tillSoundId;		// Till (cash machine)

	UIColor *emptyFigColor;
	UIFont *emptyFigFont;
	CADisplayLink *theTimer; 	
}

@property (nonatomic) NSMutableArray* figurinesInPage;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money1View;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *money1Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money2View;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *money2Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *money3View;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *money3Label;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *soundButton;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *pageLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *prevButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet Album *album1;
@property (nonatomic) IBOutlet Album *album2;
@property (nonatomic) IBOutlet Album *album3;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *hand;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *helpButton;

- (IBAction) done:(id)sender;
- (IBAction) prevButtonClicked: (id)sender;
- (IBAction) nextButtonClicked: (id)sender;
- (IBAction) soundClicked;
- (IBAction) helpClicked;

- (void) initialize;
- (void) reloadFigurines;
- (void) refreshSoundButton;
- (void) removeCurrentPage;
- (void) drawCurrentPage;
- (void) initMusicPlayer;
- (void) drawCover;
- (void) hideToolbar;
- (void) selectAlbum1;
- (void) selectAlbum2;
- (void) selectAlbum3;
- (void) initializePage;
- (void) initializePageAndThenSoundLoop;
- (UIButtonEmptyFigurine*) getEmptyFig: (Figurine*) fig index: (int) anIndex;
- (void) showMagnifier: (UIButtonEmptyFigurine*) emptyF at: (CGPoint) touchLocation;
- (void) onEmptyFigClick: (id) sender;
- (void) onEmptyFigClickRepeat: (id) sender;
- (void) onEmptyFigClickUp: (id) sender;
- (void) buyNewFigurine: (UIButtonEmptyFigurine *) buttonEmptyfig;
- (CGRect) adjustFrame: (UIView*) imageView toSize: (int) aSize;
- (void) adjustImage: (UIView*) imageView to: (Figurine*) fig;
- (void) setToolbarAlpha: (int) aValue;
- (void) refreshSoundButton;
- (void) refreshLabels;
- (void) refreshEmptyFigs;
- (void) setAffordable: (UIButtonEmptyFigurine*) buttonEmptyFig;
- (void) setAffordable: (UIButtonEmptyFigurine*) buttonEmptyFig to: (bool) aValue;
- (void) initializeTimer;

- (void) helpAnimation1;
- (void) helpAnimation1b;
- (void) drawHelpPage;
- (void) helpAnimation2; //: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation3;
- (void) helpAnimation4: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation5: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation6;
- (void) helpAnimation7: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation8: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation9: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation10: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimation11;
- (void) helpAnimationClick: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;
- (void) helpAnimationRelease: (NSString *) theAnimation finished: (BOOL)flag context: (void *)context;

@end

