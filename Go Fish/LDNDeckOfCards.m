//
//  LDNDeckOfCards.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNDeckOfCards.h"
#import "LDNPlayingCard.h"

@implementation LDNDeckOfCards
@synthesize cards = _cards;

- (id)init
{
    self = [super init];
    if (self) {
        _cards = [[NSMutableArray alloc] initWithCapacity:52];
        NSArray *ranks = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:2],
                          [NSNumber numberWithInt:3],
                          [NSNumber numberWithInt:4],
                          [NSNumber numberWithInt:5],
                          [NSNumber numberWithInt:6],
                          [NSNumber numberWithInt:7],
                          [NSNumber numberWithInt:8],
                          [NSNumber numberWithInt:9],
                          [NSNumber numberWithInt:10], @"Jack", @"Queen", @"King", @"Ace", nil];
        NSArray *suits = [NSArray arrayWithObjects:@"Clubs", @"Diamonds", @"Spades", @"Hearts", nil];
        
        NSUInteger count = 2;
        for (id rank in ranks) {
            for (NSString *suit in suits) {
                [self.cards addObject:[[LDNPlayingCard alloc] initWithRank:rank 
                                                                      suit:suit
                                                                     value:count]];
            }
            count += 1;
        }
    }
    
    return self;
}

- (NSUInteger)numberOfCards {
    return self.cards.count;
}

- (LDNPlayingCard *)draw {
    NSUInteger randomIndex = arc4random() % self.cards.count;
    LDNPlayingCard *topCard = [self.cards objectAtIndex:randomIndex];
    [self.cards removeObject:topCard];
    return topCard;
}

@end
