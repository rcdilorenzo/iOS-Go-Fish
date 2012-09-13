//
//  LDNGoFishPlayer.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDNPlayingCard;
@class LDNDeckOfCards;
@protocol GameInteraction;

@interface LDNGoFishPlayer : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, getter = getPlayerScore) NSUInteger score;
@property (nonatomic, weak) id <GameInteraction> game;
@property (nonatomic, strong) NSString *choosenRank;
@property (nonatomic, strong) LDNGoFishPlayer *choosenPlayer;

- (id)initWithName:(NSString *)aPlayerName;
- (NSArray *)askPlayerForCardsOfRank:(NSString *)aRank player:(LDNGoFishPlayer *)aPlayer;
- (NSArray *)giveCardsOfRank:(NSString *)aRank;
- (void)checkForBooks;
- (LDNPlayingCard *)drawFromDeck:(LDNDeckOfCards *)deck;
- (void)takeTurn;
- (void)sortCards;

@end

@protocol GameInteraction <NSObject>
- (NSArray *)opponents:(LDNGoFishPlayer *)player;
- (LDNPlayingCard *)drawFromGamesDeck;
- (void)setCurrentPlayerWith:(id)player;
- (LDNGoFishPlayer *)getCurrentPlayerFromGame;
- (void)addGameMessage:(NSString *)message;
- (void)turnFinished;
- (void)clearGameMessages;
- (BOOL)end;


@end