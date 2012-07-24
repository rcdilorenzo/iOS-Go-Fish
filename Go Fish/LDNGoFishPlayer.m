//
//  LDNGoFishPlayer.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishPlayer.h"
#import "LDNDeckOfCards.h"

@implementation LDNGoFishPlayer
@synthesize name = _name;
@synthesize cards = _cards;

- (id)initWithName:(NSString *)aPlayerName {
    self = [super init];
    if (self) {
        _cards = [[NSMutableArray alloc] init];
        _name = aPlayerName;
    }
    return self;
}

@end
