//
//  LDNMessageManager.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/8/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//
//  When a message is finished displayed, a "Message Finished"
//  notification will be posted. Once all messages are finished
//  being displayed, another notification "All Messages Finished"
//  will be posted.


#import <Foundation/Foundation.h>

@interface LDNMessageManager : NSObject

@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat messagePadding;
@property (nonatomic) CGFloat messageDuration;
@property (nonatomic) CGFloat backgroundRadius;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (id)initWithSuperview:(UIView *)superview;
- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width;
- (id)initWithSuperview:(UIView *)superview position:(CGPoint)position width:(CGFloat)width color:(UIColor *)backgroundColor;
- (void)addMessage:(id)message;
- (void)displayMessages;

@end