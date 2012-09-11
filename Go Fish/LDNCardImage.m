//
//  LDNCardImage.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/7/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNCardImage.h"

@implementation LDNCardImage

- (id)initWithCard:(LDNPlayingCard *)card {
    self = [super init];
    if (self) {
        self.card = card;
    }
    return self;
}

- (NSString *)rank {
    return self.card.rank;
}

- (NSString *)suit {
    return self.card.suit;
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

- (id)drawFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size {
    UIImage *cardImage = [UIImage imageNamed:[self cardImageName]];
    self.view = [[UIImageView alloc] initWithFrame:CGRectMake(location.x, location.y+10, cardImage.size.width*size, cardImage.size.height*size)];
    [self.view setImage:cardImage];
    [self.view setAlpha:0];
    [view addSubview:self.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [self.view setAlpha:1.0];
    [UIView commitAnimations];
    return self.view;
}

- (void)drawCardBackFromPosition:(CGPoint)location view:(UIView *)view size:(CGFloat)size {
    UIImage *cardImage = [UIImage imageNamed:@"backs_green.png"];
    self.view = [[UIImageView alloc] initWithFrame:CGRectMake(location.x, location.y+10, cardImage.size.width*size, cardImage.size.height*size)];
    [self.view setImage:cardImage];
    [self.view setAlpha:0];
    [view addSubview:self.view];
    [self.view setAlpha:1.0];
}

@end
