//
//  LDNGoFishRobot.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/24/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishRobot.h"
#import "LDNGoFishPlayer.h"
#import "LDNPlayingCard.h"

@implementation LDNGoFishRobot

- (id)initWithName:(NSString *)aPlayerName {
    return self = [super initWithName:aPlayerName];
}

- (BOOL)createDecisionFromOpponents:(NSArray *)opponents
                          currentPlayer:(LDNGoFishPlayer *)currentPlayer {
    NSUInteger randomIndex = arc4random() % opponents.count;
    self.choosenPlayer = opponents[randomIndex];
    NSMutableArray *cardRanks = [[NSMutableArray alloc] init];
    for (LDNPlayingCard *card in self.cards) {
        [cardRanks addObject:card.rank];
    }
    NSCountedSet *bagOfCardRanks = [[NSCountedSet alloc] initWithArray:cardRanks];
    NSString *modeOfRanks = [[NSString alloc] init];
    NSUInteger highestElementCount = 0;
    for (NSString *rank in bagOfCardRanks) {
        if ([bagOfCardRanks countForObject:rank] > highestElementCount) {
            highestElementCount = [bagOfCardRanks countForObject:rank];
            modeOfRanks = rank;
        }
    }
    self.choosenRank = modeOfRanks;
    return YES;
}

@end
