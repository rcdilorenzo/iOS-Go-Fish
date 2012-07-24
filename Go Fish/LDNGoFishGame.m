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

@interface LDNGoFishGame()
@property (nonatomic, strong) NSMutableArray *players;
@end

@implementation LDNGoFishGame
@synthesize players = _players, deck = _deck;

- (id)init
{
    NSArray *playerNames = [NSMutableArray arrayWithObjects:@"John", @"Jay", @"Doug", @"Ken", nil];
    return [self initWithPlayers:playerNames];
}

- (id)initWithPlayers:(NSArray *)playerNames {
    self = [super init];
    self.players = [[NSMutableArray alloc] init];
    for (NSString *playerName in playerNames) {
        [self.players addObject:[[LDNGoFishPlayer alloc] initWithName:playerName]];
    }
    _deck = [[LDNDeckOfCards alloc] init];
    return self;
}

- (void)setup {
    for (int i = 0; i < 5; i++) {
        for (LDNGoFishPlayer *player in self.players) {
            [player.cards addObject:self.deck.draw];
        }
    }
}

@end
