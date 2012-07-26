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

- (NSString *)cardImageName {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *rankString = [[NSString alloc] init];
    
    if ([formatter numberFromString:self.rank] == 0) {
        rankString = [[self.rank substringToIndex:1] lowercaseString];
    } else {
        rankString = self.rank;
    }
    
    NSString *suitString = [[self.suit substringToIndex:1] lowercaseString];
    NSString *cardImageName = [NSString stringWithFormat:@"%@%@.png", suitString, rankString];
    return cardImageName;
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@ of %@", self.rank, self.suit];
    return description;
}

- (void)drawFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size {
    UIImage *cardImage = [UIImage imageNamed:[self cardImageName]];
    UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x, location.y+10, cardImage.size.width*size, cardImage.size.height*size)];
    [cardImageView setImage:cardImage];
    [cardImageView setAlpha:0];
    [view addSubview:cardImageView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [cardImageView setAlpha:1.0];
    cardImageView.transform = CGAffineTransformMakeTranslation(0, -10);
    [UIView commitAnimations];
}

@end
