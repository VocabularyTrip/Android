//
//  Landscape.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Landscape.h"


@implementation Landscape

@synthesize image;
@synthesize sky;
@synthesize imageName;
@synthesize skyName;

-(UIImage*) image {
	if (image == nil) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [ImageManager getIphone5xIpadFile: imageName]];
        image = [UIImage alloc];
        image = [image initWithContentsOfFile: file];
    }
	return image;
}


-(UIImage*) sky {
	if (sky == nil) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [ImageManager getIphoneIpadFile: skyName]];		
        sky = [UIImage alloc];
        sky = [sky initWithContentsOfFile: file];
    }
	return sky;
}

-(void) purge {
	image = nil;
	sky = nil;
}

-(void) dealloc {
	[self purge];	
}

@end
