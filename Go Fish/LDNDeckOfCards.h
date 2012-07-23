//
//  LDNDeckOfCards.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDNPlayingCard;
@interface LDNDeckOfCards : NSObject

@property (nonatomic, strong) NSMutableArray *cards;

- (NSUInteger)numberOfCards;
- (LDNPlayingCard *)draw;

@end
