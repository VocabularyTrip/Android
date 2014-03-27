//
//  GameSequenceManager.m
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#define cCurrentGameSequence @"currentGameSequence"

#import "GameSequenceManager.h"
#import "UserContext.h"

NSMutableArray *allGameSequence = nil;
int qtyAllGameSequence, currentGameSequence = 0;

@implementation GameSequenceManager

+(void)loadDataFromXML {
	
	if ([allGameSequence count] == 0 ) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"GameSequence" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		allGameSequence = [[NSMutableArray alloc] init];
        
        currentGameSequence = [[NSUserDefaults standardUserDefaults] integerForKey: cCurrentGameSequence];
        
		qtyAllGameSequence = 0;
		
		[parser setDelegate: self];
		[parser parse];
	}
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
   	if ([elementName isEqualToString:@"gameSequence"]) {
        GameSequence *gameSequence = [GameSequence alloc];

        gameSequence.gameName = [attributeDict objectForKey:@"gameName"];
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
	NSLog(@"LandscapeManager. Error Parsing at line: %li, column: %li", (long)parser.lineNumber, (long)parser.columnNumber);
}

+ (GameSequence *) getCurrentGameSequence {
	return [allGameSequence objectAtIndex: currentGameSequence];
}


+ (void) resetSequence {
    currentGameSequence = 0;
}
    
+ (void) nextSequence: (NSString*) gameType {
    currentGameSequence++;
    if (currentGameSequence >= qtyAllGameSequence) currentGameSequence = 0;
    while (
           // Skip games with readAbility and user selected noReadAbility
           ([self getCurrentGameSequence].readAbility
           && ![UserContext getUserSelected].readAbility)
           ||
           // If gameType is specified, go for selection
           (![[self getCurrentGameSequence].gameType isEqualToString: gameType]
           && gameType)
    ) {
        currentGameSequence++;
        if (currentGameSequence >= qtyAllGameSequence) currentGameSequence = 0;
    }
    
    [[NSUserDefaults standardUserDefaults]
     setInteger: currentGameSequence
     forKey: cCurrentGameSequence];
}

+ (void) nextSequence {
    [self nextSequence: nil];
}

@end
