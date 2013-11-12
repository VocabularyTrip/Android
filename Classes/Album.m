//
//  Album.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/13/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Album.h"


@implementation Album

@synthesize pages;
@synthesize actualPage;
@synthesize xmlName;


- (void) reloadFigurines {
    // each user change must reload the figurine
	Figurine* fig;
	AlbumPage* page;
	if ([pages count] == 0) return;
	
	for (int i=0; i < [pages count]; i++) {
		page = [pages objectAtIndex: i];
		for (int j=0; j < [page.figurines count]; j++) {
			fig = [page.figurines objectAtIndex: j];
			[fig readWasBought];
		} 
	}
}

- (void) resetAlbum: (NSString*) albumName {
	Figurine* fig;
	AlbumPage* page;
	if ([pages count] == 0) 
		[self loadDataFromXML: albumName];
	
	for (int i=0; i < [pages count]; i++) {
		page = [pages objectAtIndex: i];
		for (int j=0; j < [page.figurines count]; j++) {
			fig = [page.figurines objectAtIndex: j];
			[fig setWasBought: NO];
		} 
	}
}

- (double) progress {
	if ([pages count] == 0) return 0;
	Figurine* fig;
	AlbumPage* page;
    int total = 0;
    int qWasBought = 0;
    
	for (int i=0; i < [pages count]; i++) {
		page = [pages objectAtIndex: i];
		for (int j=0; j < [page.figurines count]; j++) {
			fig = [page.figurines objectAtIndex: j];
            if (fig.wasBought) qWasBought++;
            total++;
		}
	}
    NSLog(@"Progress: %f", (double) qWasBought / (double) total);
  	return ((double) qWasBought / (double) total);
}

- (bool) checkAnyBought: (NSString*) albumName {
	Figurine* fig;
	AlbumPage* page;
	if ([pages count] == 0) 
		[self loadDataFromXML: albumName];
    bool noBought = NO;
    
	for (int i=0; i < [pages count]; i++) {
		page = [pages objectAtIndex: i];
		for (int j=0; j < [page.figurines count]; j++) {
			fig = [page.figurines objectAtIndex: j];
			noBought = fig.wasBought || noBought;
		} 
	}
    return noBought;
}

-(void)loadDataFromXML: (NSString *) anXmlName {
	
	xmlName = anXmlName;
	NSString* ipadXmlName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [NSString stringWithFormat: @"%@~ipad", anXmlName] : anXmlName;
	
	if ([pages count] == 0 ) {
		NSString* path = [[NSBundle mainBundle] pathForResource: ipadXmlName ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		pages = [[NSMutableArray alloc] init];
		AlbumPage* tempPage = [[AlbumPage alloc] init];
		[pages addObject: tempPage];
		actualPage = 0;
		
		[parser setDelegate: self];
		[parser parse];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"Fig"]) {
		Figurine *fig = [Figurine alloc];
		fig.number = [[attributeDict valueForKey:@"number"] intValue];
		fig.imageName = [attributeDict objectForKey:@"image"];
		fig.page = [[attributeDict valueForKey:@"page"] intValue];
		fig.x = [[attributeDict valueForKey:@"x"] intValue];
		fig.y = [[attributeDict valueForKey:@"y"] intValue];
		fig.cost = [[attributeDict valueForKey:@"cost"] intValue];
		fig.size = [[attributeDict valueForKey:@"size"] intValue];
		fig.type = [attributeDict objectForKey:@"type"];
		fig.albumName = xmlName;
		
		[fig readWasBought];
		AlbumPage *newPage;
		
		if (actualPage != fig.page) {
			AlbumPage* tempPage = [[AlbumPage alloc] init];
			[pages addObject: tempPage];
			newPage = [pages lastObject];
			actualPage = fig.page;
		} else {
			newPage = [pages lastObject];
		}

		[newPage addFigurine: fig];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	actualPage = -2;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Error Parsing at line: %i, column: %i", parser.lineNumber, parser.columnNumber);	
}

-(void) dealloc {
	if (pages) {
		[pages removeAllObjects];
		pages = nil;
	}
}

@end
