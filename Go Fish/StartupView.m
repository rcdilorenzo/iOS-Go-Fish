//
//  StartupView.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/27/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "StartupView.h"
#import <QuartzCore/QuartzCore.h>

@interface StartupView()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation StartupView
@synthesize startButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [self.startButton addTarget:self action:@selector(setHighlightedState:)
               forControlEvents:UIControlEventTouchDown];
    [self.startButton addTarget:self action:@selector(setNormalState:)
               forControlEvents:UIControlEventTouchCancel|UIControlEventTouchDragOutside|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}


- (void)drawRect:(CGRect)rect
{
    [self setNormalState:self.startButton];
}
- (void)setHighlightedState:(id)sender {
    CALayer *highlightedLayer = self.startButton.layer;
    highlightedLayer.cornerRadius = 8.0f;
    highlightedLayer.masksToBounds = YES;
    highlightedLayer.borderWidth = 1.0f;
    highlightedLayer.borderColor = [UIColor grayColor].CGColor;
    CAGradientLayer *highlightedShineLayer = [CAGradientLayer layer];
    highlightedShineLayer.frame = self.startButton.layer.bounds;
    highlightedShineLayer.colors = [NSArray arrayWithObjects:
                                    (id)[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f].CGColor,
                                    (id)[UIColor colorWithRed:0.09f green:0.00f blue:0.76f alpha:1.00f].CGColor,
                                    nil];
    highlightedShineLayer.locations = [NSArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       nil];
    [self.startButton.layer addSublayer:highlightedLayer];
    NSLog(@"highlight state was set.");
}

- (void)setNormalState:(id)sender {
    // http://www.apptite.be/blog/ios/creating-custom-ios-uibuttons/
    CALayer *layer = self.startButton.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor grayColor].CGColor;
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.startButton.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithRed:0.10f green:0.00f blue:1.00f alpha:1.00f].CGColor,
                         (id)[UIColor colorWithRed:0.09f green:0.00f blue:0.76f alpha:1.00f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [self.startButton.layer addSublayer:shineLayer];
    NSLog(@"Normal state was set.");
}

@end
