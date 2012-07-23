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

@implementation LDNGoFishGame
@synthesize players = _players, deck = _deck;

- (id)init
{
    self = [super init];
    if (self) {
        _players = [NSArray arrayWithObjects:
                    [[LDNGoFishPlayer alloc] initWithName:@"John"],
                    [[LDNGoFishPlayer alloc] initWithName:@"Jay"],
                    [[LDNGoFishPlayer alloc] initWithName:@"Doug"], 
                    [[LDNGoFishPlayer alloc] initWithName:@"Ken"], nil];
        _deck = [[LDNDeckOfCards alloc] init];
    }
    return self;
}

@end
