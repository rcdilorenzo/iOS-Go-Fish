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

@implementation LDNGoFishPlayerTests

- (void)testAskingPlayerForCards {
    LDNGoFishPlayer *playerOne = [[LDNGoFishPlayer alloc] initWithName:@"Daniel"];
    LDNGoFishPlayer *playerTwo = [[LDNGoFishPlayer alloc] initWithName:@"Belshazzar"];
    playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [playerOne askPlayerForCardsOfRank:@"3" player:playerTwo];
    STAssertEquals([[playerOne.cards lastObject] rank], @"3", @"Returned card should have a rank of 3.");
    STAssertEquals([[playerOne.cards lastObject] suit], @"Diamonds", @"Returned card should have a suit of diamonds.");
}

- (void)testAskingPlayerForMultipleCards {
    LDNGoFishPlayer *playerOne = [[LDNGoFishPlayer alloc] initWithName:@"Steve"];
    LDNGoFishPlayer *playerTwo = [[LDNGoFishPlayer alloc] initWithName:@"Bill"];
    playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Clubs"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [playerOne askPlayerForCardsOfRank:@"Jack" player:playerTwo];
    STAssertEquals([[playerOne.cards objectAtIndex:2] rank], @"Jack", @"Returned card should have a rank of Jack.");
    STAssertEquals([[playerOne.cards objectAtIndex:2] suit], @"Diamonds", @"Returned card should have a suit of diamonds.");
    STAssertEquals([[playerOne.cards objectAtIndex:3] rank], @"Jack", @"2nd returned card should have a rank of Jack.");
    STAssertEquals([[playerOne.cards objectAtIndex:3] suit], @"Clubs", @"2nd returned card should have a suit of clubs.");
}

- (void)testAskingPlayerForCardsOfRankWithoutSuccess {
    LDNGoFishPlayer *playerOne = [[LDNGoFishPlayer alloc] initWithName:@"David"];
    LDNGoFishPlayer *playerTwo = [[LDNGoFishPlayer alloc] initWithName:@"Saul"];
    playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Clubs"], nil];
    playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"Queen" suit:@"Diamonds"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [playerOne askPlayerForCardsOfRank:@"3" player:playerTwo];
    STAssertEquals(playerOne.cards.count, (NSUInteger)2, @"Returned card should not exist.");
}

- (void)testBooksShouldBeCreatedIfFourOfRankInHand {
    LDNGoFishPlayer *playerOne = [[LDNGoFishPlayer alloc] initWithName:@"David"];
    LDNGoFishPlayer *playerTwo = [[LDNGoFishPlayer alloc] initWithName:@"Saul"];
    playerOne.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"9" suit:@"Spades"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Clubs"],
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Diamonds"], nil];
    playerTwo.cards = [[NSMutableArray alloc] initWithObjects:
                       [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Spades"],
                       [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"],
                       [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"], nil];
    [playerOne askPlayerForCardsOfRank:@"3" player:playerTwo];
    [playerOne checkForBooks];
    STAssertEquals(playerOne.books.count, (NSUInteger)1, @"A book should have been created.");
    STAssertEquals(playerOne.cards.count, (NSUInteger)1, @"The books should remove the four cards of the same rank in player one\'s hand.");
}

@end
