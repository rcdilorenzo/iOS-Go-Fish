//
//  LDNMessageManager.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/8/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNMessageManager.h"
#import <QuartzCore/QuartzCore.h>

@interface LDNMessageManager ()
@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat width;
@property (nonatomic, strong) UIView *messageView;

@end


@implementation LDNMessageManager

- (id)initWithSuperview:(UIView *)superview {
    self = [super init];
    if (self) {
        self.superview = superview;
        self.queue = [[NSMutableArray alloc] init];
        [self createDefaults];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width {
    // Position must be specified for the ***portrait*** orientation
    self.position = position;
    self.portraitPosition = position;
    self.width = width;
    return [self initWithSuperview:superview];
}

- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width color:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    return [self initWithSuperview:superview position:position width:width];
}

- (void)createDefaults {
    if (!self.backgroundColor)   { self.backgroundColor = [UIColor colorWithRed:0.00f green:0.35f blue:0.02f alpha:1.00f]; }
    if (!self.fontSize)          { self.fontSize = 20;                         }
    if (!self.fontName)          { self.fontName = @"AmericanTypewriter-Bold"; }
    if (!self.textColor)         { self.textColor = [UIColor whiteColor];      }
    if (!self.messagePadding)    { self.messagePadding = 20;                   }
    if (!self.messageDuration)   { self.messageDuration = 5.0;                 }
    if (!self.backgroundRadius)  { self.backgroundRadius = 7;                  }
    
    if (self.landscapePosition.x == 0 && self.landscapePosition.y == 0) {
        self.landscapePosition = CGPointMake(self.position.y, self.position.x);
    }
}


#pragma-mark
#pragma-mark Messages

- (void)displayMessage:(id)message {
    [self addMessageToQueue:message];
    if (self.queue.count == 1) {
        [self displayMessages];
    }
}

- (void)addMessageToQueue:(id)message {
    if ([message isKindOfClass:[NSString class]]) {
        message = [NSArray arrayWithObject:message];
    }
    [self.queue addObject:message];
}

- (void)displayMessages {
    [self setFrame:CGRectMake(self.position.x,
                              self.position.y,
                              self.width,
                              (self.messagePadding*2)+self.fontSize)];
    [self displayNextMessage];
}

- (void)displayNextMessage {
    if (self.queue.count != 0) {
        [self displayArrayOfMessages:[self.queue objectAtIndex:0]];
    } else {
        [self allMessagesFinished];
    }
}

- (void)displayArrayOfMessages:(NSArray *)messageArray {
    self.messageView = [self createMessageView];
    // messageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;

    
    [self adjustFrameOfView:self.messageView
     numberOfLinesInMessage:messageArray.count];
    [self createMessageLabels:messageArray forView:self.messageView];
    [self animateMessageView:self.messageView];
}

- (void)orientationChanged:(id)sender {
    self.position = self.portraitPosition;
    if (self.superview.bounds.size.width > self.superview.bounds.size.height) {self.position = self.landscapePosition;}
    self.messageView.frame = CGRectMake(self.position.x, self.position.y, self.messageView.frame.size.width, self.messageView.frame.size.height);
}

- (void)adjustFrameOfView:(UIView *)view numberOfLinesInMessage:(NSUInteger)count {
    [self orientationChanged:nil];
    if (count == 1) {
        view.frame = CGRectMake(self.position.x, self.position.y, self.width, (self.fontSize*count)+(self.messagePadding*2));
    } else {
        view.frame = CGRectMake(self.position.x, self.position.y, self.width, ((self.fontSize*1.2)*count)+(self.messagePadding*2));
    }
}


- (UIView *)createMessageView {
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = self.backgroundColor;
    view.layer.cornerRadius = self.backgroundRadius;
    return view;
}

- (void)animateMessageView:(UIView *)messageView {
    messageView.alpha = 0;
    [self.superview addSubview:messageView];
    [UIView animateWithDuration:0.75 animations:^{messageView.alpha = 1.0;} completion:^(BOOL finished){
        [UIView animateWithDuration:0.75
                              delay:self.messageDuration-1.5
                            options:UIViewAnimationCurveEaseOut
                         animations:^{messageView.alpha = 0;}
                         completion:^(BOOL finished) {
                             [self messageFinished];
                             [messageView removeFromSuperview];
                             [self displayNextMessage];
                         }];
    }];
}

- (void)createMessageLabels:(NSArray *)messageLines forView:(UIView *)view {
    CGFloat YPosition = self.messagePadding;
    for (NSString *lineOfText in messageLines) {
        CGRect frame = CGRectMake(self.messagePadding,
                                  YPosition,
                                  view.frame.size.width-(self.messagePadding*2),
                                  self.fontSize);
        [view addSubview:[self createMessageLabel:lineOfText
                                            frame:frame]];
        YPosition += (self.fontSize*1.2);
    }
}

- (UILabel *)createMessageLabel:(NSString *)message frame:(CGRect)labelFrame {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:labelFrame];
    messageLabel.adjustsFontSizeToFitWidth = YES;
    messageLabel.text = message;
    messageLabel.font = [UIFont fontWithName:self.fontName size:self.fontSize];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = self.textColor;
    return messageLabel;
}


#pragma-mark
#pragma-mark Notifications
- (void)messageFinished {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Message Finished" object:[self.queue objectAtIndex:0]];
    [self.queue removeObjectAtIndex:0];
}

- (void)allMessagesFinished {
    if (self.queue.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"All Messages Finished" object:nil];
    }
}
@end