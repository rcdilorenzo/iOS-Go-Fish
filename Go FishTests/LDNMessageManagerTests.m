//
//  LDNMessageManagerTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/8/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNMessageManagerTests.h"
#import "LDNMessageManager.h"
#import "NSArray+Extensions.h"
#import "NSObject+PeformBlock.h"

@interface LDNMessageManager (Test)
@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat width;

- (void)messageFinished;
- (void)allMessagesFinished;
@end

@interface LDNMessageManagerTests ()
@property (nonatomic, strong) LDNMessageManager *messageManager;
@property (nonatomic, strong) UIView *aSuperview;
@property (nonatomic, strong) NSMutableArray *notifications;
@end

@implementation LDNMessageManagerTests

- (void)setUp {
    [super setUp];
    self.aSuperview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.aSuperview position:CGPointMake(150, 100) width:300];
    self.notifications = [[NSMutableArray alloc] init];
}

- (void)testInitWithSuperview {
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.aSuperview];
    STAssertEquals(self.messageManager.superview, self.aSuperview, @"initWithSuperview should assign superview");
}

- (void)testInitWithSuperViewPositionWidth {
    STAssertEquals(self.messageManager.position.x, (CGFloat)150, @"Position's x value should be set to specified value");
    STAssertEquals(self.messageManager.position.y, (CGFloat)100, @"Position's y value should be set to specified value");
    STAssertEquals(self.messageManager.width, (CGFloat)300, @"Width should be set to specified value");
}

- (void)testInitWithSuperviewPositionWidthColor {
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.aSuperview position:CGPointMake(150, 100) width:300 color:[UIColor redColor]];
    STAssertEquals(self.messageManager.backgroundColor, [UIColor redColor], @"Color should be set to specified value");
}

- (void)testAddingMessageToQueue {
    [self.messageManager addMessageToQueue:@"First Message"];
    [self.messageManager addMessageToQueue:[NSArray arrayWithObjects:@"Line 1", @"Line 2", nil]];
    STAssertTrue([[self.messageManager.queue objectAtIndex:0] containsString:@"First Message"], @"addMessageToQueue should add string to queue");
    STAssertTrue([[self.messageManager.queue objectAtIndex:0] isKindOfClass:[NSArray class]], @"addMessageToQueue converts string to array when before adding it to the queue");
    STAssertTrue([[self.messageManager.queue lastObject] containsString:@"Line 2"], @"addMessageToQueue adds objects to the end of the queue");
}

- (void)testDisplayMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self.notifications selector:@selector(addObject:) name:@"Message Finished" object:nil];
    
    [self.messageManager displayMessage:@"A message"];
    STAssertEquals(self.messageManager.queue.count, (NSUInteger)1, @"Queue should have an item in it");
    [self.messageManager messageFinished];
    STAssertEqualObjects([[self.notifications objectAtIndex:0] object], [NSArray arrayWithObject:@"A message"], @"Message Finished notification should have been posted");
    STAssertEquals(self.messageManager.queue.count, (NSUInteger)0, @"Queue should be emptied");
}

- (void)testMessageQueue {
    [[NSNotificationCenter defaultCenter] addObserver:self.notifications selector:@selector(addObject:) name:@"Message Finished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.notifications selector:@selector(addObject:) name:@"All Messages Finished" object:nil];
    [self.messageManager addMessageToQueue:@"First Message"];
    [self.messageManager addMessageToQueue:[NSArray arrayWithObjects:@"Line 1", @"Line 2", nil]];
    STAssertEquals(self.messageManager.queue.count, (NSUInteger)2, @"Message Queue should have 2 items in it");
    [self.messageManager displayMessages];
    [self.messageManager messageFinished];
    [self.messageManager messageFinished];
    [self.messageManager allMessagesFinished];
    STAssertEquals(self.notifications.count, (NSUInteger)3, @"3 notifications should have been posted");
    STAssertEquals(self.messageManager.queue.count, (NSUInteger)0, @"Message Queue should be emptied");
}
#pragma TODO Add Tests for Defaults/Properties

@end
