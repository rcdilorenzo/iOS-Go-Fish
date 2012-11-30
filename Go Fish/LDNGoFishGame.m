//
//  LDNGoFishGame.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishGame.h"
#import "LDNGoFishPlayer.h"
#import "LDNDeckOfCards.h"
#import "LDNGoFishRobot.h"
#import "NSArray+Extensions.h"

@interface LDNGoFishGame()
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) LDNDeckOfCards *deck;
@property (nonatomic, strong) NSMutableArray* gameMessages;
@end

@implementation LDNGoFishGame

- (id)initWithoutPlayerNames
{
    NSArray *playerNames = [NSMutableArray arrayWithObjects:@"John", @"Jay", @"Doug", @"Ken", nil];
    return [self initWithPlayers:playerNames];
}

- (id)initWithLivePlayer:(NSString *)playerName {
    NSArray *playerNames = [NSMutableArray arrayWithObjects:playerName, @"Rack", @"Shack", @"Benny", nil];
    return [self initWithPlayers:playerNames];
}

- (id)initWithPlayers:(NSArray *)playerNames {
    self = [super init];
    if (self) {
        self.players = [[NSMutableArray alloc] init];
        NSUInteger count = 1;
        for (NSString *playerName in playerNames) {
            if (count == 1) {
                [self.players addObject:[[LDNGoFishPlayer alloc] initWithName:playerName]];
                self.currentPlayer = (self.players)[0];
            } else {
                [self.players addObject:[[LDNGoFishRobot alloc] initWithName:playerName]];
            }
            [[self.players lastObject] setGame:self];
            count = 2;
        }
        self.deck = [[LDNDeckOfCards alloc] init];
        self.gameMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)deal {
    for (int i = 0; i < 5; i++) {
        for (LDNGoFishPlayer *player in self.players) {
            [player drawFromDeck:self.deck];
            [player sortCards];
        }
    }
}

- (id)getGameWinner {
    if ([self end]) {
        NSArray *sortedArray = [self.players sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"getPlayerScore" ascending:NO]]];
        NSMutableArray *winners = [[NSMutableArray alloc] init];
        for (LDNGoFishPlayer *player in sortedArray) {
            if (player.score == [sortedArray[0] getPlayerScore]) {
                [winners addObject:player];
            }
        }
        if (winners.count == 1) {return winners[0];} else {return winners;}
    } else { return @"Game not ended"; }
}

- (NSArray *)opponents:(LDNGoFishPlayer *)player {
    NSMutableArray *opponents = [NSMutableArray arrayWithArray:self.players];
    [opponents removeObject:player];
    return opponents;
}

- (LDNPlayingCard *)drawFromGamesDeck {
    return [self.deck draw];
}

- (BOOL)end {
    for (LDNGoFishPlayer *player in self.players) {
        if (self.deck.cards.count != 0 && player.cards.count != 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (void)setCurrentPlayerWith:(id)player {
    self.currentPlayer = player;
}

- (LDNGoFishPlayer *)getCurrentPlayerFromGame {
    return self.currentPlayer;
}

- (void)addGameMessage:(NSString *)message {
    [self.gameMessages addObject:message];
}

- (void)clearGameMessages {
    self.gameMessages = [[NSMutableArray alloc] init];
}

- (void)turnFinished {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Updated Messages" object:self.gameMessages];
}

@end
