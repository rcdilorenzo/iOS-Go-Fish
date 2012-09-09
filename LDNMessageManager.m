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

@end


@implementation LDNMessageManager

- (id)initWithSuperview:(UIView *)superview {
    self = [super init];
    if (self) {
        self.superview = superview;
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width {
    [self createDefaults];
    self.position = position;
    self.width = width;
    return [self initWithSuperview:superview];
}

- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width color:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    return [self initWithSuperview:superview position:position width:width];
}

- (void)createDefaults {
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor colorWithRed:0.00f green:0.35f blue:0.02f alpha:1.00f];
    }
    if (!self.fontSize) {
        self.fontSize = 20;
    }
    if (!self.fontName) {
        self.fontName = @"AmericanTypewriter-Bold";
    }
    if (!self.textColor) {
        self.textColor = [UIColor whiteColor];
    }
    if (!self.messagePadding) {
        self.messagePadding = 20;
    }
    if (!self.messageDuration) {
        self.messageDuration = 5.0;
    }
    if (!self.backgroundRadius) {
        self.backgroundRadius = 7;
    }
}


#pragma-mark
#pragma-mark Messages

- (void)displayMessage:(id)message {
    [self addMessageToQueue:message];
    [self displayMessages];
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
    UIView *messageView = [self createMessageView];

    if (messageArray.count == 1) {
        messageView.frame = CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y, messageView.frame.size.width, (self.fontSize*messageArray.count)+(self.messagePadding*2));
    } else {
        messageView.frame = CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y, messageView.frame.size.width, ((self.fontSize*1.2)*messageArray.count)+(self.messagePadding*2));
    }
    
    [self createMessageLabels:messageArray forView:messageView];
    [self animateMessageView:messageView];
}

- (UIView *)createMessageView {
    UIView *messageView = [[UIView alloc] initWithFrame:self.frame];
    messageView.backgroundColor = self.backgroundColor;
    messageView.layer.cornerRadius = self.backgroundRadius;
    return messageView;
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