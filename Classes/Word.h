//
//  Word.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/7/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define cLearnedWeight 7

@interface Word : NSObject <AVAudioPlayerDelegate, NSURLConnectionDelegate> {
	UIImage *image;
	AVAudioPlayer * sound;	
	NSString *name; // English name
	NSString *fileName; // for image the fileName + ".png", and for sounds is the fileName + ".mp3"
    NSMutableDictionary *allTranslatedNames;
    NSString *localizationName; // if localization is chinese --> chinese name. If the localization is other than spanish, chinese, farsi, french, etc. English name
	int theme;
	int weightImage; // Value from 1 to 10 measure if the user recognize the sound with the image
    int order;
}

@property (nonatomic, assign) int order;
@property (nonatomic) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSMutableDictionary *allTranslatedNames;
@property (nonatomic, strong) NSString *localizationName;
@property (nonatomic, strong) AVAudioPlayer *sound;
@property (nonatomic, assign) int weightImage;
@property (nonatomic, assign) int theme;
@property (nonatomic, strong) NSString *translatedName; // Instance did't exist. Got value from allTranslatedNames

+ (void) download: (NSString*) wordName;
+ (NSString*) urlDownloadFrom;
+ (NSString*) downloadDestinationPath;
+ (NSString*) checkIfDestinationPathExist;

- (int) weight;
- (bool) playSound;
- (bool) playSoundWithDelegate: (id) delegate;
- (void) addTranslation: (NSString*) translation forKey: (NSString*) key;
- (NSString*) pathToSaveTranslations;
- (NSString*) getTranslatedNameForLang: (NSString*) langName;
- (NSString*) getLocalization;

- (AVAudioPlayer*) getAudioPlayerAtDir: (NSString*) dir;
- (AVAudioPlayer*) getAudioPlayerRelPath;

@end
