//
//  GameSequence.m
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import "GameSequence.h"

@implementation GameSequence

@synthesize gameType;
@synthesize includeImages;
@synthesize includeWords;
@synthesize cumulative;
@synthesize readAbility;

- (bool) gameTypeIsTraining {
    return [gameType isEqualToString: @"Training"];
}

- (bool) gameTypeIsChallenge {
    return [gameType isEqualToString: @"Challenge"];
}

- (bool) gameTypeIsMemory {
    return [gameType isEqualToString: @"Memory"];
}

@end
