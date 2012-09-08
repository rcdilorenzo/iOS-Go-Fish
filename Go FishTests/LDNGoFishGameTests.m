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
#import "LDNPlayingCard.h"
#import "LDNGoFishRobot.h"

@implementation LDNGoFishGameTests

- (void)setUp {
    [super setUp];
    self.defaultGame = [self setUpAndDealGame];
}

- (void)testGameInitWithoutPlayerNames {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithoutPlayerNames];
    STAssertNotNil(game, @"LDNGoFishGame does not exist.");
    STAssertEquals(game.players.count, (NSUInteger)4, @"There should be 4 players");
    STAssertTrue([[game.players lastObject] isKindOfClass:[LDNGoFishRobot class]], @"Last Player should be of class LDNGoFishPlayer.");
    for (LDNGoFishPlayer *player in game.players) {
        STAssertNotNil(player.name, @"Player needs to have a name.");
    }
    LDNDeckOfCards *deck = game.deck;
    STAssertNotNil(deck, @"The game needs a deck.");
}

- (void)testGameInitPlayerNames {
    NSArray *playerNames = [NSArray arrayWithObjects:@"Bob", @"Jim", nil];
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithPlayers:playerNames];
    STAssertEquals(game.players.count, (NSUInteger)2, @"The game should have 2 players.");
    STAssertEquals([[game.players objectAtIndex:0] name], @"Bob", @"Game should set first player's name");
    STAssertEquals([[game.players objectAtIndex:1] name], @"Jim", @"Game should set second player's name");
    LDNDeckOfCards *deck = game.deck;
    STAssertNotNil(deck, @"The game needs a deck.");
}

- (void)testDeal {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithPlayers:[NSArray arrayWithObjects:@"Bob", @"Jim", nil]];
    [game deal];
    STAssertEquals([[game.players objectAtIndex:0] cards].count, (NSUInteger)5, @"Each player must be dealt 5 cards.");
    STAssertEquals(game.deck.numberOfCards, (NSUInteger)42, @"Deck of cards should have 42 cards after dealing 5 cards to two players.");
    NSLog(@"Player 1 is a %@", [[game.players objectAtIndex:0] class]);
    STAssertEquals(game.currentPlayer, [game.players objectAtIndex:0], @"Current player should be set to the first player.");
}

- (void)testEndWhenPlayerHasNoCards {
    LDNGoFishGame *game = [self setUpAndDealGame];
    STAssertEquals([game end], NO, @"The game should not have ended yet.");
    LDNGoFishPlayer *playerOne = [game.players objectAtIndex:0];
    playerOne.cards = [[NSMutableArray alloc] init];
    STAssertEquals([game end], YES, @"The game should have ended.");
}

- (void)testEndWhenDeckHasNoCards {
    LDNGoFishGame *game = [self setUpAndDealGame];
    game.deck.cards = [[NSMutableArray alloc] init];
    STAssertEquals([game end], YES, @"The game should have ended.");
}

- (LDNGoFishGame *)setUpAndDealGame {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithoutPlayerNames];
    [game deal];
    return game;
}

#pragma-mark
#pragma-mark <Game Interaction> Tests
- (void)testSettingCurrentPlayer {
    [[[self.defaultGame.players objectAtIndex:0] game] setCurrentPlayerWith:[self.defaultGame.players objectAtIndex:1]];
    STAssertEquals(self.defaultGame.currentPlayer, ([self.defaultGame.players objectAtIndex:1]), @"<Game Interaction> should set the game's current player");
}

- (void)testGettingCurrentPlayer {
    self.defaultGame.currentPlayer = [self.defaultGame.players objectAtIndex:3];
    STAssertEquals([[[self.defaultGame.players objectAtIndex:0] game] getCurrentPlayerFromGame], [self.defaultGame.players objectAtIndex:3], @"<Game Interaction> should get the game's current player");
}

- (void)testGettingAllOpponents {
    STAssertEqualObjects([[[self.defaultGame.players objectAtIndex:2] game] opponents:[self.defaultGame.players objectAtIndex:2]],
                         ([NSArray arrayWithObjects:
                           [self.defaultGame.players objectAtIndex:0],
                           [self.defaultGame.players objectAtIndex:1],
                           [self.defaultGame.players objectAtIndex:3], nil]),
                         @"<Game Interaction> should return all opponents to the specified player");
}

- (void)testDrawFromGamesDeck {
    LDNPlayingCard *drawnCard = [[[self.defaultGame.players objectAtIndex:0] game] drawFromGamesDeck];
    STAssertNotNil(drawnCard.rank, @"Card should have a rank");
}

- (void)testGameMessageHelpers {
    [[[self.defaultGame.players objectAtIndex:0] game] addGameMessage:@"A message"];
    STAssertEqualObjects(self.defaultGame.gameMessages, ([NSArray arrayWithObjects:@"A message", nil]), @"Add game message should work appropriately");
    [[[self.defaultGame.players objectAtIndex:0] game] clearGameMessages];
    STAssertEquals(self.defaultGame.gameMessages.count, (NSUInteger)0, @"clearGameMessages should clear game messages");
}


/*
- (void)testGameWinner {
    LDNGoFishGame *game = [[LDNGoFishGame alloc] initWithoutPlayerNames];
    [[[game.players objectAtIndex:3] books] addObject:[NSMutableArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Spades"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Clubs"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"], nil]];
    [[[game.players objectAtIndex:2] books] addObject:[NSMutableArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Spades"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Diamonds"], nil]];
    [[[game.players objectAtIndex:3] books] addObject:[NSMutableArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Spades"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Diamonds"], nil]];
    game.deck.cards = [[NSMutableArray alloc] init];
    STAssertEquals(game.winner, [game.players objectAtIndex:3], @"Winner should be player 4");
    
    game = [[LDNGoFishGame alloc] initWithoutPlayerNames];
    [[[game.players objectAtIndex:0] books] addObject:[NSMutableArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Spades"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Clubs"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"], nil]];
    [[[game.players objectAtIndex:2] books] addObject:[NSMutableArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Spades"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"],
                                                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Diamonds"], nil]];
    game.deck.cards = [[NSMutableArray alloc] init];
    
    STAssertEqualObjects(game.winner, ([NSMutableArray arrayWithObjects:[game.players objectAtIndex:0], [game.players objectAtIndex:2], nil]), @"Winner should be player one and three");
}
*/
@end
