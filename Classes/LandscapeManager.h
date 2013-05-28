//
//  LandscapeManager.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/10/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Landscape.h"
#import "UserContext.h"

extern NSMutableArray *allLandscapes;
extern int qtyLandscapes, currentLandscape;

@interface LandscapeManager : NSObject <NSXMLParserDelegate> {

}

+ (void)loadDataFromXML;
+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
+ (Landscape*) getCurrentLandscape;
+ (Landscape *) switchLandscape;

@end
