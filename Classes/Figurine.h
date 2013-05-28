//
//  Figurine.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/12/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sentence.h"


@interface Figurine : NSObject {
	int number;
	UIImage *image;
	int x,y;
	int cost;
	int page;
	NSString *type;
	bool wasBought;
	int size;		// Is the width in the Album. The Height will be proportional to this size
	NSString *albumName;
	NSString *imageName; // Is isued to implement a lazy initalization of UIImage (to save memory)
}  

@property (nonatomic) UIImage *image;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) int cost;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) bool wasBought;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *imageName;

-(void) setWasBought: (bool) newVal;
-(void) readWasBought;
-(UIImage*) tokenView;
-(bool) canTheUserBuyIt;
-(bool) userLevelIsInCoinType;
-(void) buyIt;
-(bool) typeIsBronze;
-(bool) typeIsSilver;
-(bool) typeIsGold;
-(void) explainWhyCannotBuyIt;
-(NSString*) keyName;
-(void) purge;
	
@end

