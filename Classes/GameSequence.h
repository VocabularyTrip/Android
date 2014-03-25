//
//  GameSequence.h
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import <Foundation/Foundation.h>

@interface GameSequence : NSObject {
    NSString* gameName;
    NSString* gameType;
    bool includeWords;
    bool includeImages;
    bool readAbility;
    bool cumulative;
}

@property (nonatomic, strong) NSString* gameName;
@property (nonatomic, strong) NSString* gameType;
@property (nonatomic) bool includeWords;
@property (nonatomic) bool includeImages;
@property (nonatomic) bool readAbility;
@property (nonatomic) bool cumulative;

- (bool) gameIsTraining;
- (bool) gameIsChallenge;
- (bool) gameIsMemory;
- (bool) gameIsSimon;

@end




