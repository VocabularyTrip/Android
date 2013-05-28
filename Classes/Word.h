//
//  Word.h
//  VocabularyTrip2
//
//  Created by Ariel Jadzinsky on 7/7/11.
//  Copyright 2011 __VocabularyTrip__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define cInitialWeight 10
#define cMaxWeight 16
#define cLearnedWeight 7
#define cStepWeight 3 

@interface Word : NSObject <AVAudioPlayerDelegate, NSURLConnectionDelegate> {
	UIImage *image;
	AVAudioPlayer * sound;	
	NSString *name; // English name, sound name, image name
    NSDictionary *allTranslatedNames; // if the app is Spanish --> Spanish name.
    NSString *localizationName; // if localization is chinese --> chinese name. If the localization is other than spanish, chinese, farsi, french, etc. English name
	int theme;
	int weight;
}

@property (nonatomic) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *allTranslatedNames;
@property (nonatomic, strong) NSString *localizationName;
@property (nonatomic, strong) AVAudioPlayer *sound;
@property (nonatomic, assign) int weight;
@property (nonatomic, assign) int theme;
@property (nonatomic, strong) NSString *translatedName; // Instance did't exist. Got value fromallTranslatedNames

+ (void) download: (NSString*) wordName;
+ (NSString*) urlDownloadFrom;
+ (NSString*) downloadDestinationPath;
+ (NSString*) checkIfDestinationPathExist;

- (void) incWeight;
- (void) decWeight;
- (void) saveWeight; 
- (int) loadWeight;
- (void) resetWeight; 
- (void) purge;
- (bool) playSound;
- (NSString*) weightKeyUserLang;
	
@end
