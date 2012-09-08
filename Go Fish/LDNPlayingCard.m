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

- (id)initWithRank:(NSString *)rank suit:(NSString *)suit {
    self = [super init];
    if (self) {
        _rank = rank;
        _suit = suit;
    }
    return self;
}

- (id)initWithRank:(NSString *)rank suit:(NSString *)suit value:(NSUInteger)value {
    self = [super init];
    if (self) {
        _rank = rank;
        _suit = suit;
        _value = value;
    }
    return self;
}


@end
