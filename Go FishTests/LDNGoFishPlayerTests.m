//
//  LDNGoFishPlayerTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/24/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishPlayerTests.h"
#import "LDNPlayingCard.h"
#import "LDNGoFishPlayer.h"
#import "LDNGoFishGame.h"
#import "NSArray+Extensions.h"

@interface LDNGoFishGame (Testing)
@property (nonatomic, strong) LDNDeckOfCards *deck;
@end

@interface LDNGoFishPlayer (Testing1)
@property (nonatomic, strong) NSString *choosenRank;
@property (nonatomic, strong) LDNGoFishPlayer *choosenPlayer;

@end

@interface LDNGoFishPlayerTests()
@property (nonatomic, strong) LDNGoFishGame *game;
@property (nonatomic, strong) LDNGoFishPlayer *playerOne;
@property (nonatomic, strong) LDNGoFishPlayer *playerTwo;
@property (nonatomic, strong) LDNGoFishPlayer *playerThree;
@end

@implementation LDNGoFishPlayerTests

- (void)setUp {
    [super setUp];
    self.game = [[LDNGoFishGame alloc] initWithPlayers:[NSArray arrayWithObjects:@"Daniel", @"Belshazzar", @"Bob", nil]];
    [self.game deal];
    self.playerOne = [self.game.players objectAtIndex:0];
    self.playerTwo = [self.game.players objectAtIndex:1];
    self.playerThree = [self.game.players lastObject];
}

- (void)testAskingPlayerForCards {
    self.playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    self.playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [self.playerOne askPlayerForCardsOfRank:@"3" player:self.playerTwo];
    STAssertTrue([self.game.gameMessages containsString:@"Daniel requests 3's from Belshazzar"], @"Game messages should reflect the requests of the players.");
    STAssertTrue([self.game.gameMessages containsString:@"Belshazzar gives 1 card(s) of the rank 3"], @"Game messages should reflect what the opponent returns to the request");
    STAssertEquals([[self.playerOne.cards lastObject] rank], @"3", @"Returned card should have a rank of 3.");
    STAssertEquals([[self.playerOne.cards lastObject] suit], @"Diamonds", @"Returned card should have a suit of diamonds.");
}

- (void)testAskingPlayerForMultipleCards {
    self.playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    self.playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Clubs"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [self.playerOne askPlayerForCardsOfRank:@"Jack" player:self.playerTwo];
    STAssertEquals([[self.playerOne.cards objectAtIndex:2] rank], @"Jack", @"Returned card should have a rank of Jack.");
    STAssertEquals([[self.playerOne.cards objectAtIndex:2] suit], @"Diamonds", @"Returned card should have a suit of diamonds.");
    STAssertEquals([[self.playerOne.cards objectAtIndex:3] rank], @"Jack", @"2nd returned card should have a rank of Jack.");
    STAssertEquals([[self.playerOne.cards objectAtIndex:3] suit], @"Clubs", @"2nd returned card should have a suit of clubs.");
}

- (void)testAskingPlayerForCardsOfRankWithoutSuccess {
    self.playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    self.playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Queen" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [self.playerOne askPlayerForCardsOfRank:@"3" player:self.playerTwo];
    STAssertTrue([self.game.gameMessages containsString:@"Go Fish!"], @"Game messages should say 'Go Fish!' if no cards are returned.");
    STAssertEquals([self.playerOne.game getCurrentPlayerFromGame], self.playerTwo, @"Game should set current player to be the second player if the request from the first player fails.");
    STAssertEquals(self.playerOne.cards.count, (NSUInteger)3, @"Returned card should not exist but a card from deck should be drawn.");
}

- (void)createCards {
    self.playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"9" suit:@"Spades"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Clubs"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"], nil];
    self.playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Spades"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
}

- (void)testBooksShouldBeCreatedIfFourOfRankInHand {
    [self createCards];
    [self.playerOne askPlayerForCardsOfRank:@"3" player:self.playerTwo];
    [self.playerOne checkForBooks];
    STAssertTrue([self.game.gameMessages containsString:@"New Book of 3\'s!"], @"Game messages should contain a new book message when a new book is created");
    STAssertEquals(self.playerOne.books.count, (NSUInteger)1, @"A book should have been created.");
    STAssertEquals(self.playerOne.cards.count, (NSUInteger)1, @"The books should remove the four cards of the same rank in player one\'s hand.");
}

- (void)testPlayerTurn {
    [self.game.players removeObject:self.playerThree];
    [self createCards];
    [self.playerTwo takeTurn];
    STAssertEquals(self.playerTwo.books.count, (NSUInteger)1, @"A book should have been created.");
    STAssertEquals(self.playerTwo.cards.count, (NSUInteger)2, @"The books should remove the four cards of the same rank in player one\'s hand.");
    LDNPlayingCard *lastCard = [self.playerTwo.cards lastObject];
    STAssertTrue([lastCard.rank isEqualToString:@"7"], @"Player should only have a 9 left in his hand.");
}

- (void)testGivingCardsOfRank {
    [self createCards];
    NSArray *returnedCards = [self.playerOne giveCardsOfRank:@"3"];
    NSArray *expectedReturnedCards = [NSArray arrayWithObjects:[[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"], [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Clubs"],[[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"], nil];
    STAssertEquals(returnedCards.count, expectedReturnedCards.count, @"The number of cards returned should be 3");
    for (int count=0; count < expectedReturnedCards.count; count++) {
        STAssertEquals([[returnedCards objectAtIndex:count] rank], [[expectedReturnedCards objectAtIndex:count] rank], @"Ranks returned should equal 3t");
        STAssertEquals([[returnedCards objectAtIndex:count] suit], [[expectedReturnedCards objectAtIndex:count] suit], @"Suits returned should equal the expected suit");
    }
}

@end