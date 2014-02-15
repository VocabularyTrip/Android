//
//  GameSequence.h
//  VocabularyTrip
//
//  Created by Ariel on 2/14/14.
//
//

#import <Foundation/Foundation.h>

@interface GameSequence : NSObject {
    NSString* gameType;
    bool includeWords;
    bool includeImages;
    bool readAbility;
    bool cumulative;
}

@property (nonatomic, strong) NSString* gameType;
@property (nonatomic) bool includeWords;
@property (nonatomic) bool includeImages;
@property (nonatomic) bool readAbility;
@property (nonatomic) bool cumulative;

@end




