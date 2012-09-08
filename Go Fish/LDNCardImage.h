//
//  LDNCardImage.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/7/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDNPlayingCard.h"

@interface LDNCardImage : NSObject

@property (nonatomic, strong) LDNPlayingCard *card;

- (id)initWithCard:(LDNPlayingCard *)card;
- (id)drawFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size;
- (void)drawCardBackFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size;

@end
