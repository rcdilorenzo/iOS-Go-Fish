//
//  LDNGoFishGame.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LDNDeckOfCards;

@interface LDNGoFishGame : NSObject

@property (nonatomic, strong, readonly) NSArray *players;
@property (nonatomic, strong, readonly) LDNDeckOfCards *deck;

@end
