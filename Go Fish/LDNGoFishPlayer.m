//
//  LDNGoFishPlayer.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishPlayer.h"
#import "LDNDeckOfCards.h"
#import "LDNPlayingCard.h"

@implementation LDNGoFishPlayer

- (id)initWithName:(NSString *)aPlayerName {
    self = [super init];
    if (self) {
        _choosenPlayer = [[LDNGoFishPlayer alloc] init];
        _choosenRank = [[NSString alloc] init];
        _cards = [[NSMutableArray alloc] init];
        _books = [[NSMutableArray alloc] init];
        _name = aPlayerName;
    }
    return self;
}

- (NSUInteger)getPlayerScore {
    return self.books.count;
}

- (void)sortCards {
    NSArray *descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES]];
    self.cards = [NSMutableArray arrayWithArray:[self.cards sortedArrayUsingDescriptors:descriptors]];
}

- (NSArray *)askPlayerForCardsOfRank:(NSString *)aRank
                              player:(LDNGoFishPlayer *)aPlayer {
    [self.game addGameMessage:[NSString stringWithFormat:@"%@ requests %@\'s from %@", self.name, aRank, aPlayer.name]];
    NSArray *cardsRequested = [aPlayer giveCardsOfRank:aRank];
    if (cardsRequested.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Player Hand Has Changed" object:aPlayer];
        [self.game addGameMessage:[NSString stringWithFormat:@"%@ gives %u card(s) of the rank %@", aPlayer.name, cardsRequested.count, aRank]];
        for (LDNPlayingCard *card in cardsRequested) {
            [self.cards addObject:card];
            [self.game setCurrentPlayerWith:self];
        }
    } else {
        [self.game addGameMessage:@"Go Fish!"];
        if ([self.game end] == NO) {
            [self.cards addObject:[self.game drawFromGamesDeck]];
            [self.game setCurrentPlayerWith:aPlayer];
        }
    }
    return cardsRequested;
}

- (NSArray *)giveCardsOfRank:(NSString *)aRank {
    NSArray *cardsOfSpecifiedRank = [self cardsOfRank:aRank];
    [self.cards removeObjectsInArray:cardsOfSpecifiedRank];
    return cardsOfSpecifiedRank;
}

- (NSArray *)cardsOfRank:(NSString *)aRank {
    NSMutableArray *cardsOfRank = [[NSMutableArray alloc] init];
    for (LDNPlayingCard *card in self.cards) {
        if ([card.rank isEqualToString:aRank]) {
            [cardsOfRank addObject:card];
        }
    }
    return cardsOfRank;
}

- (LDNPlayingCard *)drawFromDeck:(LDNDeckOfCards *)deck {
    NSUInteger randomIndex = arc4random() % deck.cards.count;
    LDNPlayingCard *selectedCard = [deck.cards objectAtIndex:randomIndex];
    [deck.cards removeObject:selectedCard];
    [self.cards addObject:selectedCard];
    [self checkForBooks];
    return selectedCard;
}

- (void)checkForBooks {
    NSArray *ranks = [NSArray arrayWithObjects:@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King", @"Ace", nil];
    for (NSString *rank in ranks) {
        if ([[self cardsOfRank:rank] count] == 4) {
            [self.game addGameMessage:[NSString stringWithFormat:@"New Book of %@\'s!", rank]];
            [self.books addObject:[self cardsOfRank:rank]];
            [self.cards removeObjectsInArray:[self cardsOfRank:rank]];
        }
    }
}

- (void)takeTurn {
    [self createDecisionFromOpponents:[self.game opponents:self] currentPlayer:self];
    [self askPlayerForCardsOfRank:self.choosenRank player:self.choosenPlayer];
    [self checkForBooks];
    [self sortCards];
    [self.game turnFinished];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Player Hand Has Changed" object:self];
}

- (void)createDecisionFromOpponents:(NSArray *)opponents
                          currentPlayer:(LDNGoFishPlayer *)currentPlayer {
    // template method for use in subclass: LDNGoFishRobot
}

@end
