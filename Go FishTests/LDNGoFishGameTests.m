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
    STAssertEquals(game.deck.numberOfCards, (NSUInteger)42, @"Deck of cards should have 42 cards after dealing 5 cards to two players.");
}

- (void)testEndConditions {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithPlayers:[NSArray arrayWithObjects:@"John", @"Jay", @"Daniel", @"Ken", nil]];
    [game setup];
    STAssertNotNil([game end], @"The should not have ended yet.");
    NSUInteger count = 1;
    while (![game end]) {
        for (LDNGoFishPlayer *player in game.players) {
            [player takeTurn];
        }
        count++;
        if (count == 8) {
            [game.players objectAtIndex:0].cards = [[NSMutableArray alloc] init];
        }
    }
    STAssertEquals(count, (NSUInteger)8, @"Game should end when a player has no cards.");
    
    [game setup];
    count = 1;
    while (![game end]) {
        for (LDNGoFishPlayer *player in game.players) {
            [player takeTurn];
        }
        count++;
        if (count == 8) {
            game.deck.cards = [[NSMutableArray alloc] init];
        }
    }
}

//NSUInteger (^calculatedWinnerIndex) (LDNGoFishGame *game) = ^NSUInteger (LDNGoFishGame *game){
//    
//};

@end
