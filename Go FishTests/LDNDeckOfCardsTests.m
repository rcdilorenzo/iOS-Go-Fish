//
//  LDNDeckOfCardsTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNDeckOfCardsTests.h"
#import "LDNDeckOfCards.h"
#import "LDNPlayingCard.h"

@implementation LDNDeckOfCardsTests

- (void)testDeckOfCardsCreation {
    LDNDeckOfCards *deck = [[LDNDeckOfCards alloc] init];
    STAssertNotNil(deck, @"Deck should exist.");
    NSUInteger numberOfCards = [deck numberOfCards];
    STAssertEquals(numberOfCards, (NSUInteger)52, @"Should be 52 cards in a new deck");
}

- (void)testDrawingCardFromDeck {
    LDNDeckOfCards *deck = [[LDNDeckOfCards alloc] init];
    LDNPlayingCard *aCard = [deck draw];
    STAssertEquals([aCard class], [LDNPlayingCard class], @"Drawn card from deck should be a card object.");
    STAssertNotNil(aCard.rank, @"A card\'s rank should not be nil.");
    STAssertNotNil(aCard.suit, @"A card\'s suit should not be nil.");
    STAssertEquals([deck numberOfCards], (NSUInteger)51, @"The deck should have 51 cards after a card is drawn.");
}

- (void)testNumberOfCards {
    LDNDeckOfCards *deck = [[LDNDeckOfCards alloc] init];
    deck.cards = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    STAssertEquals([deck numberOfCards], (NSUInteger)5, @"Number of cards method should return the count of the cards in the deck");
}

@end
