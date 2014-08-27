//
//  Sentence.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 8/22/11.
//  Copyright 2011 __Created by Ariel Jadzinsky__. All rights reserved.
//

#import "Sentence.h"
#import "UserContext.h"
#include <stdlib.h>
#import <AVFoundation/AVFoundation.h>

NSMutableArray *allSentences = nil;
NSObject* delegate = nil;
SEL selector = nil;
bool isPlaying = NO;
AVAudioPlayer *currentAudio = nil;

@implementation Sentence

@synthesize names;
@synthesize method;
@synthesize next;
@synthesize type;
@synthesize wasPlayed;

+ (NSObject*) delegate {
	return delegate;
}	

+ (void) setDelegate: (NSObject*) aDelegate {
	delegate = aDelegate;
}	

+ (bool) playSpeaker: (NSString*) name delegate: (id) del selector: (SEL) aSelector {
    delegate = del;
    selector = aSelector;
    return [self playSpeaker: name];
}

+ (bool) playSpeaker: (NSString*) name {
	Sentence *sentence = [self getSentenceOfMethod: name];
	if (sentence != nil) {
		bool soundEnabled = UserContext.soundEnabled == 1;
		bool noRestrictionWithFirstTimeInSession = ![sentence.type isEqualToString: @"firstTimeInSession"] || sentence.wasPlayed == 0;
		if (!isPlaying && ([sentence.type isEqualToString: @"always"] ||
		(soundEnabled && noRestrictionWithFirstTimeInSession))) {
			isPlaying = YES;	// To avoid concurrence sentences. 
			[sentence play];
			sentence.wasPlayed = 1; // Some sentences are said just the first time (type = firstTimeInSession)
			return YES;
		}
	}
	return NO;
}

+ (void) stopCurrentAudio {
    if (currentAudio) {
        [currentAudio stop];
        isPlaying = NO;
        currentAudio = nil;
        delegate = nil;
        selector = nil;
    }
}

- (void) play {
	@try {
		int c = arc4random() % [names count];
		avProxy = [names objectAtIndex: c];
		avProxy.sound.delegate = self;
		if (avProxy.sound) {
            currentAudio = avProxy.sound;
            [avProxy.sound play];
        }
	}
	@catch (NSException * e) {
		NSLog(@"Error Sentence.Play");
        isPlaying = NO;
        currentAudio = nil;
	}
	@finally {
	}
	
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	isPlaying = NO;
    currentAudio = nil;
	@try {
        
        if (delegate && selector) {
            [delegate performSelector: selector];
            delegate = nil;
            selector = nil;
        }
        
		/*if ([next isEqualToString: @"NumCurrentLevel"]) {
			NSString *l = [[NSString alloc] initWithFormat: @"%d", [UserContext getLevelNumber]];
			[Sentence playSpeaker: l];
			//[delegate takeOutTrain]; 
		} else*/
        if (next != nil) {
			[Sentence playSpeaker: next];
		}

		[avProxy releaseSound];
	}
	@catch (NSException * e) {
		NSLog(@"Error Sentence.DidFinishPlaying");
	}
	@finally {
	}
    
    //[delegate sentenceDidFinish: method];
}

+(void)loadDataFromXML {
	
	if ([allSentences count] == 0) {
		NSString* path = [[NSBundle mainBundle] pathForResource: @"Sentences" ofType: @"xml"];
		NSData* data = [NSData dataWithContentsOfFile: path];
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
		
		allSentences = [[NSMutableArray alloc] init];
		
		[parser setDelegate: self];
		[parser parse];
	}	
}

+ (NSString*) getSentenceName: (NSString*) name {
    NSString* loc = [UserContext getPreferredLanguage];
    // Check if loc (the preferred language) is included in the available sentences
    // If not, the default is en: english
    if ([supportedLanguages rangeOfString: loc].length == 0) loc = @"en";
    return [NSString stringWithFormat: @"%@_%@", loc , name];
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	@try {
		if ([elementName isEqualToString:@"Sentence"]) {
			
			Sentence *newSentence = [Sentence alloc];
            NSString* nameSentence = [self getSentenceName: [attributeDict objectForKey:@"name"]];
			//NSString* nameSentence = [attributeDict objectForKey:@"name"];
			newSentence.names = [[NSMutableArray alloc] init]; 
			AudioPlayerProxy *aSound = [AudioPlayerProxy alloc];
            
			aSound.name = nameSentence;
			[newSentence.names addObject: aSound];
			newSentence.next = [attributeDict objectForKey:@"Next"];
			newSentence.method = [attributeDict objectForKey:@"Method"];
			newSentence.type = [attributeDict objectForKey:@"type"];

			[allSentences addObject: newSentence];
		} else if ([elementName isEqualToString:@"Alternative"]) {
			Sentence* aSentence = [allSentences objectAtIndex: [allSentences count]-1]; 
            NSString* nameSentence = [self getSentenceName: [attributeDict objectForKey:@"name"]];

			AudioPlayerProxy *aSound = [AudioPlayerProxy alloc];
			aSound.name = nameSentence;
			[aSentence.names addObject: aSound];
			
		} 
	}
	@catch (NSException * e) {
		NSLog(@"Error loading Sentences");
	}
	@finally {
	}
}

+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Sentence. Error Parsing at line: %li, column: %li", (long)parser.lineNumber, (long)parser.columnNumber);	
}

+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName {
    NSURL* file_url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]	 
                       pathForResource: fileName ofType:@"mp3"] isDirectory: NO]; 
    return [self getAudioPlayerAtURL: file_url];
}

+ (AVAudioPlayer*) getAudioPlayer: (NSString*) fileName dir: (NSString*) dir {
    NSString *a = [[NSBundle mainBundle] pathForResource: fileName ofType:@"mp3" inDirectory: dir];
    NSURL* file_url = [[NSURL alloc] initFileURLWithPath: a isDirectory: NO]; 
    return [self getAudioPlayerAtURL: file_url];
}


// This method is used to load words depending on language selected
// The path used is relative
+ (AVAudioPlayer*) getAudioPlayerRelPath: (NSString*) fileName {
       
    //Language *lang = [UserContext getLanguageSelected];
    
    //NSString *newPath = [NSString stringWithFormat:@"%@%@%@%@%@%@", NSHomeDirectory(), @"/Assets/Sounds/", lang.name, @"/", fileName, @".mp3"];
    NSString *newPath =  [NSString stringWithFormat:@"%@%@%@", [Word downloadDestinationPath], fileName, @".mp3"];
                          
    NSURL* file_url = [[NSURL alloc] initFileURLWithPath: newPath]; 

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
        isPlaying = NO;
        currentAudio = nil;
	}
	@finally {
	}
	return nil;
}


+ (void)parserDidEndDocument:(NSXMLParser *)parser {
}

+ (Sentence*) getSentenceOfMethod: (NSString*) aMethod {
	Sentence *aSentence;
	for (int i=0; i<[allSentences count]; i++) {
		aSentence = [allSentences objectAtIndex: i];
		if ([aSentence.method isEqualToString: aMethod]) 
			return aSentence;
	}	
	return nil;
}

+ (void) testAllSentences {
   	AudioPlayerProxy* avProxy;
	Sentence *aSentence;
	for (int i=0; i<[allSentences count]; i++) {
        aSentence = [allSentences objectAtIndex: i];
        for (int j=0; j < [aSentence.names count]; j++) {
            avProxy = [aSentence.names objectAtIndex: j];
            //avProxy.sound.delegate = self;
            if (avProxy.sound) [avProxy.sound play];
        }
	}	
	//return nil;
}


@end
