//
//  LDNPlayingCard.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNPlayingCard.h"

@implementation LDNPlayingCard
@synthesize rank = _rank;
@synthesize suit = _suit;
@synthesize value = _value;

#define RANKS [NSArray arrayWithObjects:@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King", @"Ace", nil]

- (id)initWithRank:(NSString *)rank suit:(NSString *)suit {
    self = [super init];
    if (self) {
        _rank = rank;
        _suit = suit;
        _value = [RANKS indexOfObject:rank];
    }
    return self;
}

@end