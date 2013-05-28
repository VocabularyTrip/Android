//
//  UIButtonEmptyFigurine.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/15/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figurine.h"

@interface UIButtonEmptyFigurine : UIButton {
	Figurine *__unsafe_unretained fig;
	int index; // represent de number in the current page
}

@property (nonatomic, unsafe_unretained) IBOutlet Figurine* fig;
@property (nonatomic, assign) int index;

@end
