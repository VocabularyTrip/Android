//
//  Word.m
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/7/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import "Word.h"
#import "Sentence.h" // Is used just to upload de AVAudioPlayer. Showld be encapsulated elsewhere
#import "VocabularyTrip2AppDelegate.h"

@implementation Word

@synthesize image;
@synthesize name;
@synthesize allTranslatedNames;
@synthesize localizationName;
@synthesize sound;
@synthesize weight;
@synthesize theme;

+ (NSString*) urlDownloadFrom {
    Language *lang = [UserContext getLanguageSelected];
    return [NSString stringWithFormat: @"%@%@%@", @"http://www.vocabularytrip.com/Sounds/", lang.name, @"/"];
}

+ (NSString*) downloadDestinationPath {
    Language *lang = [UserContext getLanguageSelected];
    return [NSString stringWithFormat:@"%@%@%@%@", 
            NSHomeDirectory(), @"/Documents/Assets/Sounds/", lang.name, @"/"];
}

+ (NSString*) checkIfDestinationPathExist {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    
    NSString *destPath = [self downloadDestinationPath];
    if (![fm fileExistsAtPath: destPath isDirectory: &isDir]) {
        NSError *err = nil;
        [fm createDirectoryAtPath: destPath 
            withIntermediateDirectories: YES attributes: nil error: &err];
        NSString *result = err.localizedDescription;
        NSLog(@"Eror Creating Path %@", result);
    }
    return destPath;
}

+ (void) download: (NSString*) wordName {
    
    // Set Source & Destination
    NSString *fullUrl =
    [NSString stringWithFormat: @"%@%@%@", [self urlDownloadFrom], wordName, @".mp3"];
    NSString *destPath = [self checkIfDestinationPathExist];
    destPath = [NSString stringWithFormat: @"%@%@%@", destPath, wordName, @".mp3"];
    
    // Start Download
    NSURL *url = [NSURL URLWithString: fullUrl];
    //NSLog(@"URL: %@, DestPath: %@", url, destPath);
    AFHTTPRequestOperation* operation = [AFProxy prepareDownload: url destination: destPath delegate:self];

    [operation start];

}

// Response to Download Word
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    //NSLog(@"Word Downloaded");
    singletonVocabulary.qWordsLoaded++;
    Language *lang = [UserContext getLanguageSelected];
    float progress =  (float) singletonVocabulary.qWordsLoaded / (float) lang.qWords;
        
    if (singletonVocabulary.isDownloading && singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate addProgress: progress];
    
    if (progress >= 1) singletonVocabulary.isDownloading = NO;
}

+ (void) connectionFinishWidhError:(NSError *) error url: (NSURL *) url {
    NSString *result = error.localizedDescription;
    NSLog(@"*******************");
    NSLog(@"%@", result);
    NSLog(@"Error with url: %@", url);
    NSLog(@"*******************");
    singletonVocabulary.isDownloading = NO;
    if (singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate downloadFinishWidhError: result];
}

-(UIImage*) image {
	if (image == nil) {
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [UserContext getIphoneIpadFile: name]];
        image = [UIImage alloc];
        image = [image initWithContentsOfFile: file];
    }
	return image;
}

-(AVAudioPlayer*) sound {
	if (sound == nil)
		@try {
            if (theme == 1) {
                // Colors are stored ad-hoc and are not downloaded
                Language *lang = [UserContext getLanguageSelected];
                sound = [Sentence getAudioPlayer: name dir: lang.name]; 
            } else
                // Other words are downloaded and the path is relative
                sound = [Sentence getAudioPlayerRelPath: name]; 
		} @catch (NSException * e) {
			NSLog(@"Can't load sound %@", name);
		}
		@finally {
		}
	
	return sound;
}

-(void) purge {
	image = nil;
	sound = nil;
}

-(bool) playSound {
	self.sound.delegate = self;
	[sound play];
    return (sound != nil);
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	if (sound != nil) {
		sound.delegate = nil;
		[self purge];
	}
}

-(void) incWeight {
	if (weight < cMaxWeight) weight += cStepWeight;
	[self saveWeight];
}

-(void) decWeight {
	if (weight > 1) weight -= cStepWeight;
	[self saveWeight];
}

-(NSString*) weightKeyUserLang {
    User *u = [UserContext getUserSelected];
    Language *l = [u langSelected];
    return [NSString stringWithFormat: @"%@-%i-%i", name, u.userId, l.key];
}

-(void) saveWeight { 
    NSString *key = [self weightKeyUserLang];
	[[NSUserDefaults standardUserDefaults] setInteger: weight forKey: key];
}

-(int) loadWeight {
    NSString *key = [self weightKeyUserLang];
    weight = [[NSUserDefaults standardUserDefaults] integerForKey: key];
	if (weight == 0) {
		weight = cInitialWeight;
		[self saveWeight];
	}
	return weight;
}

-(void) resetWeight { 
	weight = cInitialWeight;
	[self saveWeight];
}

-(int) weight {
	if (weight == 0) {
        weight = [self loadWeight];
	}
	return weight;
}

- (NSString*) translatedName {
    Language *lang = [UserContext getLanguageSelected];
    NSString *translated = [allTranslatedNames objectForKey: lang.name];
    if ([translated isEqualToString: @""]) // If language doesnt exist, use English.
        translated = [allTranslatedNames objectForKey: @"English"];
    return translated;
}

-(void) dealloc {
	[self purge];
}


@end
