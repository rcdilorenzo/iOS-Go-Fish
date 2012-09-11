//
//  LDNGoFishPlayerUI.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/10/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//
//
//  Updates to LDNGoFishPlayerUI require the notification
//  'Player Hand Has Changed' in the model.
//
//  player.cards must be the cards in the player's hand

#import <Foundation/Foundation.h>
#import "LDNGoFishPlayer.h"

@interface LDNGoFishPlayerUI : NSObject

@property (nonatomic, strong) LDNGoFishPlayer *player;
@property (nonatomic, strong) UIView *view;
@property (nonatomic) CGPoint position;

- (id)initWithPlayer:(id)player superview:(UIView *)superview position:(CGPoint)point orientation:(NSString *)orientation;
- (void)draw;

@end
