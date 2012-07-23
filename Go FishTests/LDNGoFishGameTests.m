//
//  LDNGoFishGameTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishGameTests.h"
#import "LDNGoFishGame.h"
#import "LDNGoFishPlayer.h"
#import "LDNDeckOfCards.h"

@implementation LDNGoFishGameTests

- (void)testCreationOfGoFishGame {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] init];
    STAssertNotNil(game, @"LDNGoFishGame does not exist.");
    STAssertEquals(game.players.count, (NSUInteger)4, @"There should be 4 players");
    for (LDNGoFishPlayer *player in game.players) {
        STAssertEqualObjects([player class], [LDNGoFishPlayer class], @"Player should be of class LDNGoFishPlayer");
        STAssertNotNil(player.name, @"Player needs to have a name.");
    }
    LDNDeckOfCards *deck = game.deck;
    STAssertNotNil(deck, @"The game needs a deck.");
}

@end
