//
//  LDNGoFishGame.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDNGoFishPlayer.h"
#import "LDNDeckOfCards.h"

@interface LDNGoFishGame : NSObject <GameInteraction>

@property (nonatomic, strong, readonly) NSMutableArray *players;
@property (nonatomic, strong, readonly) LDNDeckOfCards *deck;
@property (nonatomic, strong) id currentPlayer;
@property (nonatomic, strong, readonly) NSMutableArray* gameMessages;
@property (nonatomic, strong, readonly, getter = getGameWinner) id winner;

- (id)initWithPlayers:(NSArray *)playerNames;
- (id)initWithoutPlayerNames;
- (id)initWithLivePlayer:(NSString *)playerName;
- (void)deal;
- (void)clearGameMessages;

@end
