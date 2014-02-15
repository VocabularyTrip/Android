//
//  GameSequenceManager.h
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import <Foundation/Foundation.h>
#import "GameSequence.h"

extern NSMutableArray *allGameSequence;
extern int qtyAllGameSequence, currentGameSequence;

@interface GameSequenceManager : NSObject <NSXMLParserDelegate> {
}

+ (void) loadDataFromXML;
+ (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName: (NSString *) qualifiedName attributes: (NSDictionary *) attributeDict;
+ (GameSequence*) getCurrentGameSequence;

@end
