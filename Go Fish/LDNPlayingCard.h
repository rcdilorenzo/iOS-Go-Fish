//
//  LDNPlayingCard.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDNPlayingCard : NSObject

@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger value;

- (id)initWithRank:(NSString *)rank suit:(NSString *)suit;
- (id)initWithRank:(NSString *)rank suit:(NSString *)suit value:(NSUInteger)value;
- (void)drawFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size;
    
@end
