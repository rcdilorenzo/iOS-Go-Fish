//
//  LDNPlayinCardTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/24/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNPlayingCardTests.h"
#import "LDNPlayingCard.h"

@implementation LDNPlayingCardTests

- (void)testCardRankSuit {
    LDNPlayingCard *aCard = [[LDNPlayingCard alloc] initWithRank:@"3" suit:@"Spades"];
    STAssertEquals(aCard.rank, @"3", @"Rank should be 3.");
    STAssertEquals(aCard.suit, @"Spades", @"Suit should be spades.");
}

#pragma test initWithRank:suit:value

@end
