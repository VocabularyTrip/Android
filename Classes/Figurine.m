//
//  Figurine.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/12/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Figurine.h"
#import "UserContext.h"

@implementation Figurine

@synthesize image;
@synthesize number;
@synthesize x;
@synthesize y;
@synthesize cost;
@synthesize type;
@synthesize page;
@synthesize wasBought;
@synthesize size;
@synthesize albumName;
@synthesize imageName;

-(UIImage*) image {
	if (!image) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName];
		//self.image = [UIImage imageNamed: imageName];
        image = [UIImage alloc];
        image = [image initWithContentsOfFile: file];
    }
	return image;
}

-(void) purge {
	image = nil;
}

-(void) setImage: (UIImage *) newImage {
	image = newImage;
}

/*-(UIImage*) getPrivateImage {
	return image;
}*/

-(NSString*) keyName {
    User *user = [UserContext getUserSelected];
	return [NSString stringWithFormat: @"%i %@ %d ", user.userId, albumName, number];
}

-(void) setWasBought: (bool) newVal {
	wasBought = newVal;
	[[NSUserDefaults standardUserDefaults] setBool: wasBought forKey: [self keyName]];
}

-(void) readWasBought {
	wasBought = [[NSUserDefaults standardUserDefaults] boolForKey: [self keyName]];
}

-(bool) typeIsBronze {
	return [type isEqualToString: cBronzeType];
}

-(bool) typeIsSilver {
	return [type isEqualToString: cSilverType];
}

-(bool) typeIsGold {
	return [type isEqualToString: cGoldType];
}

-(UIImage*) tokenView {
	
	if ([self typeIsBronze]) return [UIImage imageNamed: [ImageManager getIphoneIpadFile: @"token-bronze"]];
	if ([self typeIsSilver]) return [UIImage imageNamed: [ImageManager getIphoneIpadFile: @"token-silver"]];
	if ([self typeIsGold]) return [UIImage imageNamed: [ImageManager getIphoneIpadFile: @"token-gold"]];
	return nil;
}

-(bool) canTheUserBuyIt {
	if ([self typeIsBronze]) return [UserContext getMoney1] >= cost;
	if ([self typeIsSilver]) return [UserContext getMoney2] >= cost;
	if ([self typeIsGold]) return [UserContext getMoney3] >= cost;	
	return NO;
}

-(bool) userLevelIsInCoinType {
	return
	([UserContext getLevel] > cLimitLevelSilver && [self typeIsGold]) || 
	([UserContext getLevel] > cLimitLevelBronze && [self typeIsSilver]) ||	
	([self typeIsBronze]);
}

-(void) buyIt {
	if ([self typeIsBronze]) return [UserContext addMoney1: -1 * cost];
	if ([self typeIsSilver]) return [UserContext addMoney2: -1 * cost];
	if ([self typeIsGold]) return [UserContext addMoney3: -1 * cost];	
}

- (void) explainWhyCannotBuyIt {
	// We enter here we the konowledge there are not money enough
	// Just in case we check it:
	if ([self canTheUserBuyIt]) return;
	
	// a Gold Figurine was selected, the user is gold level but there are not enough gold money
	if ([self userLevelIsInCoinType] && [self typeIsGold]) {
		[Sentence playSpeaker: @"AlbumView-onEmptyFigClick-NotEnoughGold"];
		// a Silver Figurine was selected, the user is silver level but there are not enough silver money
	} else if ([self userLevelIsInCoinType] && [self typeIsSilver]) {
		[Sentence playSpeaker: @"AlbumView-onEmptyFigClick-NotEnoughSilver"];
		// a Bronze Figurine was selected, the user is bronze level but there are not enough bronze money
	} else if ([self userLevelIsInCoinType] && [self typeIsBronze]) {
		[Sentence playSpeaker: @"AlbumView-onEmptyFigClick-NotEnoughBronze"];
		// a Silver Figurine was selected, but the user is not silver level yet
	} else if ([self typeIsSilver])  {
		[Sentence playSpeaker: @"AlbumView-onEmptyFigClick-NotInSilverSection"];
		// a Gold Figurine was selected, but the user is not gold level yet
	} else {
		[Sentence playSpeaker: @"AlbumView-onEmptyFigClick-NotInGoldSection"];
	}
}

-(void) dealloc {
	if (image) {
        image = nil;
    }
}

@end
