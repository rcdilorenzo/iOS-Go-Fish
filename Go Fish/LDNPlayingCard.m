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

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@ of %@", self.rank, self.suit];
    return description;
}

- (void)drawFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size {
    UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", [[self.suit substringToIndex:1] lowercaseString], [[self.rank substringToIndex:1] lowercaseString]]];
    UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x, location.y, cardImage.size.width*size, cardImage.size.height*size)];
    [cardImageView setImage:cardImage];
    [view addSubview:cardImageView];
}

@end
