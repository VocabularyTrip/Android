//
//  Landscape.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Landscape.h"


@implementation Landscape

@synthesize layer1;
@synthesize layer2;
@synthesize layer3;
@synthesize layer1Name;
@synthesize layer2Name;
@synthesize layer3Name;

-(UIImage*) layer1 {
	if (layer1 == nil) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [ImageManager getIphoneIpadFile: layer1Name]];
        layer1 = [UIImage alloc];
        layer1 = [layer1 initWithContentsOfFile: file];
    }
	return layer1;
}

-(UIImage*) layer2 {
	if (layer2 == nil) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [ImageManager getIphoneIpadFile: layer2Name]];
        layer2 = [UIImage alloc];
        layer2 = [layer2 initWithContentsOfFile: file];
    }
	return layer2;
}

-(UIImage*) layer3 {
	if (layer3 == nil) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [ImageManager getIphoneIpadFile: layer3Name]];
        layer3 = [UIImage alloc];
        layer3 = [layer3 initWithContentsOfFile: file];
    }
	return layer3;
}

-(void) purge {
	layer1 = nil;
	layer2 = nil;
	layer3 = nil;
}

-(void) dealloc {
	//[self purge];
}

@end
