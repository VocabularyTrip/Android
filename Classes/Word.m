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
@synthesize fileName;
@synthesize allTranslatedNames;
@synthesize localizationName;
@synthesize sound;
@synthesize weightImage;
@synthesize weightWord;
@synthesize theme;
@synthesize order;

+ (NSString*) urlDownloadFrom {
    Language *lang = [UserContext getLanguageSelected];
    return [NSString stringWithFormat: @"%@%@%@", @"http://www.vocabularytrip.com/DictionarySounds/", lang.name, @"/"];
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

+ (void) download: (NSString*) fileName {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    // Set Source & Destination
    NSString *fullUrl =
    [NSString stringWithFormat: @"%@%@%@", [self urlDownloadFrom], fileName, @".mp3"];

    NSString *destPath = [self checkIfDestinationPathExist];
    destPath = [NSString stringWithFormat: @"%@%@%@", destPath, fileName, @".mp3"];
    if (![fm fileExistsAtPath: destPath isDirectory: &isDir]) {
    
        // Start Download
        //NSLog(@"Request download full path: %@", fullUrl);
        NSURL *url = [NSURL URLWithString: fullUrl];
        //NSLog(@"URL: %@, DestPath: %@", url, destPath);
        AFHTTPRequestOperation* operation = [AFProxy prepareDownload: url destination: destPath delegate:self];

        [operation start];
    } else {
        singletonVocabulary.qWordsLoaded++;
        [self refreshProgress];
    }
}

+ (void) refreshProgress {
    Language *lang = [UserContext getLanguageSelected];
    float progress =  (float) singletonVocabulary.qWordsLoaded / (float) lang.qWords;
    
    if (singletonVocabulary.isDownloading && singletonVocabulary.isDownloadView)
        [singletonVocabulary.delegate addProgress: progress];
    
    if (progress >= 1) singletonVocabulary.isDownloading = NO;
}

// Response to Download Word
+ (void) connectionFinishSuccesfully: (NSDictionary*) response {
    singletonVocabulary.qWordsLoaded++;
    [self refreshProgress];
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
        NSString *file = [[NSString alloc ] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [NSString stringWithFormat: @"%@.png", fileName]]; // [UserContext getIphoneIpadFile: name]];
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
                sound = [Sentence getAudioPlayer: fileName dir: lang.name];
            } else
                // Other words are downloaded and the path is relative
                sound = [Sentence getAudioPlayerRelPath: fileName];
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

-(bool) playSoundWithDelegate: (id) delegate {
	self.sound.delegate = delegate;
	[sound play];
    return (sound != nil);
}

-(bool) playSound {
    return [self playSoundWithDelegate: self];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	if (sound != nil) {
		sound.delegate = nil;
		[self purge];
	}
}

-(void) incWeight {
    if ([GameSequenceManager getCurrentGameSequence].readAbility) {
        if (weightWord < cMaxWeight) weightWord += cStepWeight;
        [self saveWeightWord];
    } else {
        if (weightImage < cMaxWeight) weightImage += cStepWeight;
        [self saveWeightImage];
	}

}

-(void) decWeight {
    if ([GameSequenceManager getCurrentGameSequence].readAbility) {
        if (weightWord > 1) weightWord -= cStepWeight;
        [self saveWeightWord];
    } else {
        if (weightImage > 1) weightImage-= cStepWeight;
        [self saveWeightImage];
    }
}

-(int) weight {
    if ([GameSequenceManager getCurrentGameSequence].readAbility)
        return self.weightWord;
    else
        return self.weightImage;
}

-(NSString*) weightImageKeyUserLang {
    User *u = [UserContext getUserSelected];
    Language *l = [u langSelected];
    return [NSString stringWithFormat: @"image%@-%i-%i", name, u.userId, l.key];
}

-(NSString*) weightWordKeyUserLang {
    User *u = [UserContext getUserSelected];
    Language *l = [u langSelected];
    return [NSString stringWithFormat: @"word%@-%i-%i", name, u.userId, l.key];
}

-(void) saveWeightWord {
    NSString *key = [self weightWordKeyUserLang];
    [[NSUserDefaults standardUserDefaults] setInteger: weightWord forKey: key];
}

-(void) saveWeightImage {
    NSString *key = [self weightImageKeyUserLang];
    [[NSUserDefaults standardUserDefaults] setInteger: weightImage forKey: key];
}

-(void) loadWeight {
    [self loadWeightWord];
    [self loadWeightImage];
}

-(int) loadWeightImage {
    NSString *key = [self weightImageKeyUserLang];
    weightImage = [[NSUserDefaults standardUserDefaults] integerForKey: key];
	if (weightImage == 0) {
		weightImage = cInitialWeight;
		[self saveWeightImage];
	}
	return weightImage;
}

-(int) loadWeightWord {
    NSString *key = [self weightWordKeyUserLang];
    weightWord = [[NSUserDefaults standardUserDefaults] integerForKey: key];
	if (weightWord == 0) {
		weightWord = cInitialWeight;
		[self saveWeightWord];
	}
	return weightWord;
}

-(void) resetWeight { 
	weightImage = cInitialWeight;
	[self saveWeightImage];
	weightWord = cInitialWeight;
	[self saveWeightWord];
}

-(int) weightImage {
	if (weightImage == 0) {
        weightImage = [self loadWeightImage];
	}
	return weightImage;
}

-(int) weightWord {
	if (weightWord == 0) {
        weightWord = [self loadWeightWord];
	}
	return weightWord;
}

- (NSString*) keyDictionary {
    return [NSString stringWithFormat: @"%@%@", cKeyDictionary, name];
}

- (void) addTranslation: (NSString*) translation forKey: (NSString*) key {
    [[self allTranslatedNames] setValue: translation forKey: key];
    if (![allTranslatedNames writeToFile: [self pathToSaveTranslations] atomically: YES])
        NSLog(@"Failed saving File: %@, path: %@", name, [self pathToSaveTranslations]);
}

- (NSString*) pathToSaveTranslations {
  
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat: @"%@/%@", [path objectAtIndex: 0], name];
//    return [[NSString alloc] initWithFormat:@"%@/%@/%@",
//            [[NSBundle mainBundle] resourcePath], @"Dict", name];
}

- (NSMutableDictionary*) allTranslatedNames {
    if (!allTranslatedNames) {
        allTranslatedNames = [[NSMutableDictionary alloc] initWithContentsOfFile:
                              [self pathToSaveTranslations]];
        if (!allTranslatedNames)
            allTranslatedNames = [[NSMutableDictionary alloc] init];
    }
    return allTranslatedNames;
}

- (void) setAllTranslatedNames: (NSMutableDictionary *) newAllTranslatedNames {
    if (!allTranslatedNames ) {
        allTranslatedNames = newAllTranslatedNames;
        [allTranslatedNames writeToFile: [self pathToSaveTranslations] atomically: YES];
    }
}

- (NSString*) getTranslatedNameForLang: (NSString*) langName {
    return [[self allTranslatedNames] objectForKey: langName];
}

- (NSString*) translatedName {
    Language *lang = [UserContext getLanguageSelected];
    NSString *translated = [self getTranslatedNameForLang: lang.name];
    if ([translated isEqualToString: @""]) // If language doesnt exist, use English.
        translated = [allTranslatedNames objectForKey: @"English"];
    return translated;
}

- (NSString*) localizationName {

    localizationName = [self getTranslatedNameForLang: [self getLocalization]];
    if ([[self translatedName] isEqualToString: localizationName])
        localizationName = @"";
    return localizationName;
}


-(NSString*) getLocalization {
    
    NSString *loc = [UserContext getPreferredLanguage];
    
    if ([loc isEqualToString: @"zh-Hant"]) return @"Chinese";
    if ([loc isEqualToString: @"fr"]) return @"French";
    if ([loc isEqualToString: @"es"]) return @"Spanish";
    if ([loc isEqualToString: @"fa"]) return @"Farsi";
    if ([loc isEqualToString: @"de"]) return @"German";
    if ([loc isEqualToString: @"it"]) return @"Italian";
    if ([loc isEqualToString: @"pt"]) return @"Portuguese";
    if ([loc isEqualToString: @"ar"]) return @"Arabic";
    if ([loc isEqualToString: @"he"]) return @"Hebrew";
    if ([loc isEqualToString: @"hi"]) return @"Hindi";
    if ([loc isEqualToString: @"ja"]) return @"Japanese";
    if ([loc isEqualToString: @"ko"]) return @"Korean";
    if ([loc isEqualToString: @"ru"]) return @"Russian";
    if ([loc isEqualToString: @"ms"]) return @"Malay";
    if ([loc isEqualToString: @"vn"]) return @"Vietnamese";
    
    return @"English";
}

-(void) dealloc {
	[self purge];
}


@end
