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

@interface LDNMessageManager (Test)
@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic) CGFloat width;

- (void)messageFinished;
- (void)allMessagesFinished;
- (void)createDefaults;
- (void)adjustFrameOfView:(UIView *)view numberOfLinesInMessage:(NSUInteger)count;
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
    STAssertEquals(self.messageManager.portraitPosition.x, (CGFloat)150, @"Position's x value should be set to specified value");
    STAssertEquals(self.messageManager.portraitPosition.y, (CGFloat)100, @"Position's y value should be set to specified value");
    STAssertEquals(self.messageManager.landscapePosition.x, (CGFloat)100, @"Position's x value should be set to specified value");
    STAssertEquals(self.messageManager.landscapePosition.y, (CGFloat)150, @"Position's y value should be set to specified value");
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

- (void)testCreatingDefaults {
    [self.messageManager createDefaults];
    STAssertEqualObjects(self.messageManager.backgroundColor, [UIColor colorWithRed:0.00f green:0.35f blue:0.02f alpha:1.00f], @"Background color default is a darker green");
    STAssertEquals(self.messageManager.fontSize, (CGFloat)20, @"Font size default is 20");
    STAssertEqualObjects(self.messageManager.fontName, @"AmericanTypewriter-Bold", @"Font name default is Bold American Typewriter");
    STAssertEqualObjects(self.messageManager.textColor, [UIColor whiteColor], @"Text color default is white");
    STAssertEquals(self.messageManager.messagePadding, (CGFloat)20, @"Message padding default is 20");
    STAssertEquals(self.messageManager.messageDuration, (CGFloat)5.0, @"Message duration default is 5.0");
    STAssertEquals(self.messageManager.backgroundRadius, (CGFloat)7, @"Background radius default is 7");
}

- (void)testFrameAdjustment {
    self.messageManager.fontSize = 12;
    self.messageManager.messagePadding = 40;
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.messageManager adjustFrameOfView:testView numberOfLinesInMessage:3];
    
    // Height should be (12*1.2)*3+(40*2) => (14.4)*3+(80) => 43.2+80 => 123.2
    STAssertEquals(testView.frame.size.height, (CGFloat)123.2, @"Frame height should be set based on the number of messages, the font size, and the message padding");
}

@end