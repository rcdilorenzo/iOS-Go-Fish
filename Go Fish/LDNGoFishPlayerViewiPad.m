//
//  LDNGoFishPlayerUI.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/10/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishPlayerViewiPad.h"
#import "LDNGoFishPlayer.h"
#import "LDNGoFishRobot.h"
#import "LDNCardImage.h"
#import "Constants.h"

@interface LDNGoFishPlayerViewiPad ()
@property (nonatomic) BOOL isRobotPlayer;
@property (nonatomic, strong) NSString *orientation;
@property (nonatomic, strong) NSMutableArray *cardImages;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *title;
@end

@implementation LDNGoFishPlayerViewiPad
- (id)initWithVerticalOrientation {
    self = [self initWithFrame:CGRectMake(self.position.x, self.position.y, 120, 554+self.titleLabel.frame.size.height)];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 37)];
        self.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self updateTitle];
        [self updateCards];
        [self addSubview:self.titleLabel];
        [self.superview addSubview:self];
    }
    return self;
}

- (id)initWithHorizontalOrientation {
    self = [super initWithFrame:CGRectMake(self.position.x, self.position.y, 500, 100+self.titleLabel.frame.size.height)];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -3, 400, 42)];
        self.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self updateTitle];
        [self updateCards];
        [self addSubview:self.titleLabel];
        [self.superview addSubview:self];
    }
    return self;
}
- (id)initWithPlayer:(LDNGoFishPlayer *)player position:(CGPoint)point orientation:(NSString *)orientation {
    self.player = player;
    self.isRobotPlayer = ([player isKindOfClass:[LDNGoFishRobot class]]);
    self.position = point;
    self.orientation = orientation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerAfterTurn:) name:@"Player Hand Has Changed" object:nil];
    if (orientation == UIOrientationHorizontal) {
        return [self initWithHorizontalOrientation];
    } else {
        return [self initWithVerticalOrientation];
    }
}

- (void)updatePlayerAfterTurn:(id)sender {
    if ([sender object] == self.player) {
        NSLog(@"%@\'s Cards Updated", self.player.name);
        [self updateTitle];
        [self updateCards];
    }
}

- (void)updateCardImages {
    for (LDNCardImage *image in self.cardImages) { [image.view removeFromSuperview]; }
    self.cardImages = [[NSMutableArray alloc] init];
    for (LDNPlayingCard *card in self.player.cards) {
        [self.cardImages addObject:[[LDNCardImage alloc] initWithCard:card]];
    }
}

- (void)updateTitle {
    if (self.orientation == UIOrientationHorizontal) {
        self.title = [NSString stringWithFormat:@"%@ - %u Books", self.player.name, self.player.books.count];
    } else if (self.orientation == UIOrientationVertical) {
        self.title = [NSString stringWithFormat:@"%@ - %u", self.player.name, self.player.books.count];
    }
    
    self.titleLabel.text = self.title;
}

- (void)updateCards {
    [self updateCardImages];
    if (self.orientation == UIOrientationHorizontal) {
        CGPoint cardPosition = CGPointMake(20, 25);
        
        for (LDNCardImage *cardImage in self.cardImages) {
            if (self.isRobotPlayer) {
                [cardImage drawCardBackFromPosition:cardPosition view:self size:0.8];
            } else {
                [cardImage drawFromPosition:cardPosition view:self size:0.9];
            }
            cardPosition.x += 40;
        }
    } else if (self.orientation == UIOrientationVertical) {
        CGPoint cardPosition = CGPointMake(10, 25);
        for (LDNCardImage *cardImage in self.cardImages) {
            if (self.isRobotPlayer) {
                [cardImage drawCardBackFromPosition:cardPosition view:self size:0.8];
            } else {
                [cardImage drawFromPosition:cardPosition view:self size:0.8];
            }
            cardPosition.y += 30;
        }
    }
    
}

@end
