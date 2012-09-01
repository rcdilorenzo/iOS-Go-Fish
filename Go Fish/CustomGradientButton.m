//
//  CustomGradientButton.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/27/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "CustomGradientButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomGradientButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([self state] != 1) {
        [self setNormalState:self];
        [self setNeedsDisplay];
    } else {
        [self setHighlightedState:self];
        [self setNeedsDisplay];
    }
    [self addTarget:self action:@selector(setHighlightedState:) forControlEvents:UIControlStateHighlighted|UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(setNormalState:) forControlEvents:UIControlStateNormal|UIControlEventTouchDragOutside|UIControlEventTouchUpInside];
}

- (void)setHighlightedState:(id)sender {
    CALayer *highlightedLayer = self.layer;
    highlightedLayer.cornerRadius = 8.0f;
    highlightedLayer.masksToBounds = YES;
    highlightedLayer.borderWidth = 1.0f;
    highlightedLayer.borderColor = [UIColor blackColor].CGColor;
    CAGradientLayer *highlightedShineLayer = [CAGradientLayer layer];
    highlightedShineLayer.frame = self.layer.bounds;
    highlightedShineLayer.colors = [NSArray arrayWithObjects:
                                    (id)[UIColor colorWithRed:0.20f green:0.20f blue:1.0f alpha:1.0f].CGColor,
                                    (id)[UIColor colorWithRed:0.09f green:0.00f blue:0.65f alpha:1.0f].CGColor,
                                    nil];
    highlightedShineLayer.locations = [NSArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       nil];
    [self.layer insertSublayer:highlightedShineLayer below:self.titleLabel.layer];
    [self setNeedsDisplay];
}

- (void)setNormalState:(id)sender {
    // http://www.apptite.be/blog/ios/creating-custom-ios-uibuttons/
    CALayer *layer = self.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor grayColor].CGColor;
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:0.9f].CGColor,
                         (id)[UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:0.9f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [self.layer insertSublayer:shineLayer below:self.titleLabel.layer];
    [self setNeedsDisplay];
}

@end
