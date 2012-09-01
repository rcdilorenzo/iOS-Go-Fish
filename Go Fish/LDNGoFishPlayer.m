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
@synthesize name = _name, cards = _cards, books = _books, choosenRank = _choosenRank, choosenPlayer = _choosenPlayer;
@synthesize game = _game;

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

- (NSArray *)askPlayerForCardsOfRank:(NSString *)aRank
                              player:(LDNGoFishPlayer *)aPlayer {
    NSArray *cardsRequested = [aPlayer giveCardsOfRank:aRank];
    if (cardsRequested.count != 0) {
        for (LDNPlayingCard *card in cardsRequested) {
            [self.cards addObject:card];
            [self.game setCurrentPlayerWith:self];
        }
    } else {
        // Go Fish!
        if ([self.game end] == NO) {
            [self.cards addObject:[self.game drawFromGamesDeck]];
            [self.game setCurrentPlayerWith:aPlayer];
        }
    }
    NSLog(@"Cards Returned: %@", cardsRequested);
    NSLog(@"Cards: %@", self.cards);
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
            [self.books addObject:[self cardsOfRank:rank]];
            [self.cards removeObjectsInArray:[self cardsOfRank:rank]];
        }
    }
}

- (void)takeTurn {
    [self createDecisionFromOpponents:[self.game opponents:self] currentPlayer:self];
    //if (!decisionCreated) {
    //    self.choosenPlayer = [[self.game opponents:self] objectAtIndex:0];
    //    NSUInteger randomIndex = arc4random() % self.cards.count;
    //    self.choosenRank = [self.cards objectAtIndex:randomIndex];
    //}
    [self askPlayerForCardsOfRank:self.choosenRank player:self.choosenPlayer];
    NSLog(@"%@ chose to ask %@ for any %@\'s...", self.name, self.choosenPlayer.name, self.choosenRank);
    [self checkForBooks];
}

- (void)endTurn {
    self.choosenRank = [[NSString alloc] init];
    self.choosenPlayer = [[LDNGoFishPlayer alloc] init];
}


- (BOOL)createDecisionFromOpponents:(NSArray *)opponents
                          currentPlayer:(LDNGoFishPlayer *)currentPlayer {
    // empty for this parent class of LDNGoFishRobot
    return NO;
}

@end
