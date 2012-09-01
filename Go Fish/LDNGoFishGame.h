//
//  LDNGoFishGame.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDNGoFishPlayer.h"

@class LDNDeckOfCards;

@interface LDNGoFishGame : NSObject <GameInteraction>

@property (nonatomic, strong, readonly) NSMutableArray *players;
@property (nonatomic, strong, readonly) LDNDeckOfCards *deck;
@property (nonatomic, strong, readonly) id currentPlayer;

- (void)setupWithPlayers:(NSArray *)playerNames;
- (void)setupWithoutPlayerNames;
- (void)setupWithLivePlayer:(NSString *)playerName;
- (void)setup;

@end
