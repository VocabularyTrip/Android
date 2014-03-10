//
//  SelectGameMode.m
//  VocabularyTrip
//
//  Created by Ariel on 1/6/14.
//
//

#import "GameStartView.h"
#import "GenericTrain.h"

@implementation GameStartView

@synthesize backgroundView;
@synthesize gameTypelabel;
@synthesize includeWordsLabel;
@synthesize includeImagesLabel;
@synthesize readAbilityLabel;
@synthesize cumulativeLabel;
@synthesize parentView;
@synthesize wordButton1;
@synthesize wordButton2;
@synthesize wordButtonLabel1;
@synthesize wordButtonLabel2;
@synthesize wagon1;
@synthesize wagon2;

- (void) viewDidLoad {
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    originalframeWord1ButtonView = CGRectMake(wordButton1.frame.origin.x, wordButton1.frame.origin.y, wordButton1.frame.size.width, wordButton1.frame.size.height);
    originalframeWord2ButtonView = CGRectMake(wordButton2.frame.origin.x, wordButton2.frame.origin.y, wordButton2.frame.size.width, wordButton2.frame.size.height);
}

- (void) show {
    
    gameTypelabel.text = [GameSequenceManager getCurrentGameSequence].gameType;
    
    if ([GameSequenceManager getCurrentGameSequence].cumulative) {
        cumulativeLabel.text = @"Cumulative";
        Word* aWord = [Vocabulary getRandomWordFromLevel: [UserContext getLevelNumber]];
        [ImageManager fitImage: aWord.image inButton: wordButton1];
        aWord = [Vocabulary getRandomWordFromLevel: [UserContext getLevelNumber]-1];
        [ImageManager fitImage: aWord.image inButton: wordButton2];
    } else {
        cumulativeLabel.text = @"Current Level";
        Word* aWord = [Vocabulary getRandomWordFromLevel: [UserContext getLevelNumber]];
        [ImageManager fitImage: aWord.image inButton: wordButton1];
        aWord = [Vocabulary getRandomWordFromLevel: [UserContext getLevelNumber]];
        [ImageManager fitImage: aWord.image inButton: wordButton2];
        
    }

    if ([GameSequenceManager getCurrentGameSequence].includeImages) {
        includeImagesLabel.text = @"Images";
        wordButton1.alpha = 1;
        wordButton2.alpha = 1;
    } else {
        includeImagesLabel.text = @"";
        wordButton1.alpha = 0;
        wordButton2.alpha = 0;
    }
    
    if ([GameSequenceManager getCurrentGameSequence].includeWords) {
        includeWordsLabel.text = @"Words";
        wordButtonLabel1.alpha = 1;
        wordButtonLabel2.alpha = 1;
    } else {
        includeWordsLabel.text = @"";
        wordButtonLabel1.alpha = 0;
        wordButtonLabel2.alpha = 0;
    }

    int deltaY = [GameSequenceManager getCurrentGameSequence].includeWords &&
    [GameSequenceManager getCurrentGameSequence].includeImages ? wordButtonLabel1.frame.size.height : 0;
    
    CGRect frame = wordButton1.frame;
    originalframeWord1ButtonView.origin.y =
    wagon1.frame.origin.y - deltaY - originalframeWord1ButtonView.size.height;
    frame.origin.y = originalframeWord1ButtonView.origin.y;
    wordButton1.frame = frame;
    
    frame = wordButton2.frame;
    originalframeWord2ButtonView.origin.y =
    wagon2.frame.origin.y - deltaY - originalframeWord2ButtonView.size.height;
    frame.origin.y = originalframeWord2ButtonView.origin.y;
    wordButton2.frame = frame;

    int deltaX = ([ImageManager windowWidthXIB] - backgroundView.frame.size.width) / 2;
    deltaY = ([ImageManager windowHeightXIB] - backgroundView.frame.size.height) / 2;
    
    [UIView animateWithDuration: 0.50 animations: ^ {
        self.view.frame = CGRectMake(
                                     deltaX, deltaY,
                                     backgroundView.frame.size.width,
                                     backgroundView.frame.size.height);
        self.view.alpha = 1;
    }];
    
    self.view.alpha = 1;
}

- (IBAction) hide {
    [UIView animateWithDuration: 0.25 animations: ^ {
        self.view.frame = CGRectMake(50, 50, 0, 0);
        self.view.alpha = 0;
    }];
    
    //[parentView startGame];
    [parentView introduceTrain];
}

@end
