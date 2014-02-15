//
//  GameSequenceManager.m
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import "GameSequenceManager.h"

NSMutableArray *allGameSequence = nil;
int qtyAllGameSequence, currentGameSequence = 0;

@implementation GameSequenceManager

+(void)loadDataFromXML {
	
	if ([allGameSequence count] == 0 ) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"GameSequence" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		allGameSequence = [[NSMutableArray alloc] init];
		currentGameSequence = 0;
		qtyAllGameSequence = 0;
		
		[parser setDelegate: self];
		[parser parse];
	}
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
   	if ([elementName isEqualToString:@"gameSequence"]) {
        GameSequence *gameSequence = [GameSequence alloc];
        
        gameSequence.gameType = [attributeDict objectForKey:@"gameType"];
        gameSequence.includeWords = [[attributeDict objectForKey:@"includeWords"] boolValue];
        gameSequence.includeImages = [[attributeDict objectForKey:@"includeImages"] boolValue];
        gameSequence.readAbility = [[attributeDict objectForKey:@"readAbility"] boolValue];
        gameSequence.cumulative = [[attributeDict objectForKey:@"cumulative"] boolValue];
        
        [allGameSequence addObject: gameSequence];
        qtyAllGameSequence++;
    }
}

+ (void)parserDidEndDocument:(NSXMLParser *)parser {
}

+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"LandscapeManager. Error Parsing at line: %i, column: %i", parser.lineNumber, parser.columnNumber);
}

+ (GameSequence *) getCurrentGameSequence {
	return [allGameSequence objectAtIndex: currentGameSequence];
}

@end
