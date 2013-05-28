//
//  LandscapeManager.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "LandscapeManager.h"
#import "Landscape.h"

NSMutableArray *allLandscapes=nil;
int qtyLandscapes, currentLandscape = 0;

@implementation LandscapeManager

+(void)loadDataFromXML {
	
	if ([allLandscapes count] == 0 ) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"Landscapes" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		allLandscapes = [[NSMutableArray alloc] init];	
		currentLandscape = 0;
		qtyLandscapes = 0;
		
		[parser setDelegate:self];
		[parser parse];
	}	
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	if ([elementName isEqualToString:@"landscape"]) {
		Landscape *landscape = [Landscape alloc];
		landscape.imageName = [attributeDict objectForKey:@"name"];
		landscape.skyName = [attributeDict objectForKey:@"sky"];
		[allLandscapes addObject:landscape]; 	
		qtyLandscapes++;
	}
}

+ (void)parserDidEndDocument:(NSXMLParser *)parser {
}

+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"LandscapeManager. Error Parsing at line: %i, column: %i", parser.lineNumber, parser.columnNumber);	
}

+ (Landscape *) getCurrentLandscape {
	return [allLandscapes objectAtIndex: currentLandscape];
}

+ (Landscape *) switchLandscape {
	[[self getCurrentLandscape] purge];
	currentLandscape++;
	if (currentLandscape >= qtyLandscapes) {
		currentLandscape = 0;
	}
	return [self getCurrentLandscape];
}

@end
