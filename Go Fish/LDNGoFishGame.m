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

@interface LDNGoFishGame()
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) LDNDeckOfCards *deck;
@end

@implementation LDNGoFishGame
@synthesize players = _players, deck = _deck;

- (void)setupWithoutPlayerNames
{
    NSArray *playerNames = [NSMutableArray arrayWithObjects:@"John", @"Jay", @"Doug", @"Ken", nil];
    [self setupWithPlayers:playerNames];
}

- (void)setupWithLivePlayer:(NSString *)playerName {
    NSArray *playerNames = [NSMutableArray arrayWithObjects:playerName, @"Rack", @"Shack", @"Benny", nil];
    [self setupWithPlayers:playerNames];
}

- (void)setupWithPlayers:(NSArray *)playerNames {
    self.players = [[NSMutableArray alloc] init];
    NSUInteger count = 1;
    for (NSString *playerName in playerNames) {
        if (count == 1) {
            [self.players addObject:[[LDNGoFishRobot alloc] initWithName:playerName]];
        } else {
            [self.players addObject:[[LDNGoFishPlayer alloc] initWithName:playerName]];
        }
        NSLog(@"last object: %@", [self.players lastObject]);
        [[self.players lastObject] setGame:self];
        count = 2;
    }
    self.deck = [[LDNDeckOfCards alloc] init];
}

- (void)setup {
    for (int i = 0; i < 5; i++) {
        for (LDNGoFishPlayer *player in self.players) {
            [player drawFromDeck:self.deck];
        }
    }
}

- (NSArray *)opponents:(LDNGoFishPlayer *)player {
    NSMutableArray *opponents = self.players;
    [opponents removeObject:player];
    return opponents;
}

- (LDNPlayingCard *)drawFromGamesDeck {
    return [self.deck draw];
}

- (BOOL)end {
    for (LDNGoFishPlayer *player in self.players) {
        if (self.deck.cards.count != 0 || player.cards.count != 0) {
            return NO;
        } else {
            return YES;
        }
    }
}

@end
