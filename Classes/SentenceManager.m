//
//  Sentence.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "SentenceManager.h"
#import "UserContext.h"

//#include <stdlib.h>
//#import <AVFoundation/AVFoundation.h>

SentenceManager *singletonSentenceManager = nil;

@implementation SentenceManager

@synthesize allSentences;
@synthesize delegate;
@synthesize selector;
@synthesize isPlaying;
@synthesize currentAudio;

- (Sentence*) getSentenceOfMethod: (NSString*) aMethod {
	Sentence *aSentence;
	for (int i=0; i<[allSentences count]; i++) {
		aSentence = [allSentences objectAtIndex: i];
		if ([aSentence.method isEqualToString: aMethod])
			return aSentence;
	}
	return nil;
}

- (bool) playSpeaker: (NSString*) name delegate: (id) del selector: (SEL) aSelector {
    delegate = del;
    selector = aSelector;
    return [self playSpeaker: name];
}

- (bool) playSpeaker: (NSString*) name {
	Sentence *sentence = [self getSentenceOfMethod: name];
	if (sentence != nil) {
        return [sentence checkRestrictionsAndPlay];
	}
	return NO;
}

- (void) stopCurrentAudio {
    if (currentAudio) {
        [currentAudio stop];
        isPlaying = NO;
        currentAudio = nil;
        delegate = nil;
        selector = nil;
    }
}

- (void) audioPlayerDidFinishPlaying {
    singletonSentenceManager.isPlaying = NO;
    singletonSentenceManager.currentAudio = nil;
    @try {
        if (delegate && selector) {
            if ([delegate respondsToSelector: selector]) {
                [delegate performSelector: selector];
                delegate = nil;
                selector = nil;
            }
        }
     
     } @catch (NSException * e) {
            NSLog(@"Error Sentence.DidFinishPlaying");
     } @finally {
     }
}


+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName {
    NSURL* file_url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
                                                          pathForResource: fileName ofType:@"mp3"] isDirectory: NO];
    return [self getAudioPlayerAtURL: file_url];
}

+ (AVAudioPlayer*) getAudioPlayerAtURL: (NSURL*) file_url {
	@try {
		NSError* file_error = nil;
        
        AVAudioPlayer* aSound = [[AVAudioPlayer alloc] initWithContentsOfURL:file_url error:&file_error] ;
		if(!file_url || file_error) {
			NSLog(@"Error loading music file: %@", [file_error localizedDescription]);
		}
		aSound.numberOfLoops = 0;
        return aSound;
	} @catch (NSException * e) {
		NSLog(@"Error in getAudioPlayer: %@", file_url);
        singletonSentenceManager.isPlaying = NO;
        singletonSentenceManager.currentAudio = nil;
	}
	@finally {
	}
	return nil;
}


- (void)loadDataFromXML {
	
	if ([allSentences count] == 0) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"Sentences" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		allSentences = [[NSMutableArray alloc] init];
		
		[parser setDelegate: self];
		[parser parse];
	}	
}

- (NSString*) getLocalizedSentenceName: (NSString*) name {
    NSString* loc = [UserContext getPreferredLanguage];
    // Check if loc (the preferred language) is included in the available sentences
    // If not, the default is en: english
    if ([supportedLanguages rangeOfString: loc].length == 0) loc = @"en";
    return [NSString stringWithFormat: @"%@_%@", loc , name];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	@try {
		if ([elementName isEqualToString:@"Sentence"]) {
			
			Sentence *newSentence = [Sentence alloc];
			newSentence.names = [[NSMutableArray alloc] init];
            NSString* nameSentence = [self getLocalizedSentenceName: [attributeDict objectForKey:@"name"]];
			AVAudioPlayer *aSound = [SentenceManager getAudioPlayer: nameSentence];
			[newSentence.names addObject: aSound];
			//newSentence.next = [attributeDict objectForKey:@"Next"];
			newSentence.method = [attributeDict objectForKey:@"Method"];
			newSentence.type = [attributeDict objectForKey:@"type"];

			[allSentences addObject: newSentence];
		} else if ([elementName isEqualToString:@"Alternative"]) {
			Sentence* aSentence = [allSentences objectAtIndex: [allSentences count]-1]; 
            NSString* nameSentence = [self getLocalizedSentenceName: [attributeDict objectForKey:@"name"]];
			AVAudioPlayer *aSound = [SentenceManager getAudioPlayer: nameSentence];
			[aSentence.names addObject: aSound];
			
		} 
	}
	@catch (NSException * e) {
		NSLog(@"Error loading Sentences");
	}
	@finally {
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Sentence. Error Parsing at line: %li, column: %li", (long)parser.lineNumber, (long)parser.columnNumber);	
}


@end
