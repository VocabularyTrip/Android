//
//  Album.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 9/13/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figurine.h"
#import "AlbumPage.h"

#define cAlbum1 @"AlbumPrincess"
#define cAlbum2 @"AlbumMonsters"
#define cAlbum3 @"AlbumAnimals"

@interface Album : NSObject <NSXMLParserDelegate> {
	NSMutableArray *pages; 
	int actualPage;
	NSString *__unsafe_unretained xmlName;
}

@property (nonatomic) NSMutableArray *pages;
@property (nonatomic, assign) int actualPage;
@property (nonatomic, unsafe_unretained) NSString *xmlName;


- (void) reloadFigurines;
- (void) loadDataFromXML: (NSString *) xmlName;
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
- (void) parserDidEndDocument:(NSXMLParser *)parser;
- (void) resetAlbum: (NSString*) albumName;
- (bool) checkAnyBought: (NSString*) albumName;
    
@end
