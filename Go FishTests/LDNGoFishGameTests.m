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

- (void)testGameSetup {
    NSArray *playerNames = [NSArray arrayWithObjects:@"Bob", @"Jim", nil];
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithPlayers:playerNames];
    STAssertEquals(game.players.count, (NSUInteger)2, @"The game should have 2 players.");
    [game setup];
    STAssertEquals([[game.players objectAtIndex:0] cards].count, (NSUInteger)5, @"Each player must be dealt 5 cards.");
}

@end
