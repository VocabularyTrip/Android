//
//  Landscape.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageManager.h"

@interface Landscape : NSObject {
	UIImage *layer1;
	UIImage *layer2;
	UIImage *layer3;
	NSString* layer1Name;
	NSString* layer2Name;
	NSString* layer3Name;
}

@property (nonatomic) UIImage *layer1;
@property (nonatomic) UIImage *layer2;
@property (nonatomic) UIImage *layer3;
@property (nonatomic, strong) NSString* layer1Name;
@property (nonatomic, strong) NSString* layer2Name;
@property (nonatomic, strong) NSString* layer3Name;

-(void) purge;
	
@end
