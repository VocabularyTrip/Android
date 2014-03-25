//
//  GameSequence.m
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import "GameSequence.h"

@implementation GameSequence

@synthesize gameName;
@synthesize gameType;
@synthesize includeImages;
@synthesize includeWords;
@synthesize cumulative;
@synthesize readAbility;

- (bool) gameIsTraining {
    return [gameName isEqualToString: @"Training"];
}

- (bool) gameIsChallenge {
    return [gameName isEqualToString: @"Challenge"];
}

- (bool) gameIsMemory {
    return [gameName isEqualToString: @"Memory"];
}

- (bool) gameIsSimon {
    return [gameName isEqualToString: @"Simon"];
}

- (bool) gameTypeIsTraining {
    return [gameType isEqualToString: @"Training"];
}

- (bool) gameTypeIsChallenge {
    return [gameType isEqualToString: @"Challenge"];
}

@end
