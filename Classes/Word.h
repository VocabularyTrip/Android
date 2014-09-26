//
//  Word.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/7/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//#define cInitialWeight 10
//#define cMaxWeight 16
#define cLearnedWeight 7
//#define cStepWeight 3
//#define cKeyDictionary @"keyDictionry"

@interface Word : NSObject <AVAudioPlayerDelegate, NSURLConnectionDelegate> {
	UIImage *image;
	AVAudioPlayer * sound;	
	NSString *name; // English name, sound name, image name
	NSString *fileName; // for image the fileName + ".png", and for sounds is the fileName + ".mp3"
    NSMutableDictionary *allTranslatedNames; // if the app is Spanish --> Spanish name.
    NSString *localizationName; // if localization is chinese --> chinese name. If the localization is other than spanish, chinese, farsi, french, etc. English name
	int theme;
	int weightImage; // Value from 1 to 10 measure if recognize the sound with the image
//	int weightWord; // Similar to weightImage but measure if the user could read the sound. Is used in the mode. Is used if User.readAbility is true
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
//@property (nonatomic, assign) int weightWord;
@property (nonatomic, assign) int theme;
@property (nonatomic, strong) NSString *translatedName; // Instance did't exist. Got value from allTranslatedNames

+ (void) download: (NSString*) wordName;
+ (NSString*) urlDownloadFrom;
+ (NSString*) downloadDestinationPath;
+ (NSString*) checkIfDestinationPathExist;

- (int) weight;
//- (void) loadWeight; // load boath imageWeight and wordWeight
//- (void) saveWeightImage;
//- (void) saveWeightWord;
//- (int) loadWeightImage;
//- (int) loadWeightWord;
//- (void) resetWeight;
//- (void) purge;
- (bool) playSound;
- (bool) playSoundWithDelegate: (id) delegate;
//- (NSString*) weightKeyUserLang;
//- (NSString*) keyDictionary;
- (void) addTranslation: (NSString*) translation forKey: (NSString*) key;
- (NSString*) pathToSaveTranslations;
- (NSString*) getTranslatedNameForLang: (NSString*) langName;
- (NSString*) getLocalization;

@end
