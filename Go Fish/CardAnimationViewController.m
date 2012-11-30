//
//  ViewController.m
//  DeckOfCardsAnimation
//
//  Created by Christian Di Lorenzo on 7/28/12.
//  Copyright (c) 2012 Christian Di Lorenzo. All rights reserved.
//

#import "CardAnimationViewController.h"
#import "LDNPlayingCard.h"
#import "LDNDeckOfCards.h"
#import "LDNCardImage.h"
#import <QuartzCore/QuartzCore.h>

@interface CardAnimationViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfCardImageViews;
@property (nonatomic) int count;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int numberOfDecks;
@property (strong, nonatomic) NSMutableArray *cardImageSpeeds;
@property (strong, nonatomic) NSTimer *refreshSpeedsTimer;

@end

@implementation CardAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    self.view.gestureRecognizers = @[tapRecognizer];
    
    [self becomeFirstResponder];
    self.arrayOfCardImageViews = [[NSMutableArray alloc] initWithCapacity:52];
    self.cardImageSpeeds = [[NSMutableArray alloc] init];
    [self configureAccelerometer];
    [self startAnimation];
    [self createCardSpeeds];
    self.refreshSpeedsTimer = [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(changeSpeeds) userInfo:nil repeats:YES];
}

- (void)changeSpeeds {
    self.cardImageSpeeds = [[NSMutableArray alloc] init];
    [self createCardSpeeds];
}

- (void)createCardSpeeds {
    for (int i=0; i<self.arrayOfCardImageViews.count; i++) {
        [self.cardImageSpeeds addObject:[NSNumber numberWithInt:(arc4random() % 1000)/10+25]];
    }
}

- (void)startAnimation {
    if (self.arrayOfCardImageViews.count/52 <= 8) {
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        self.numberOfDecks = 1;
        
        self.count = 52*self.numberOfDecks-1;
        self.timer = [[NSTimer alloc] init];
        LDNDeckOfCards *deck = [[LDNDeckOfCards alloc] init];
        for (int i = 1; i < self.numberOfDecks+1; i++) {
            for (LDNPlayingCard *card in deck.cards) {
                CGFloat xOffset = ((int)self.view.bounds.size.width/2) - (72/2) + (0.5);
                CGFloat yOffset = ((int)self.view.bounds.size.height/2) - (62/2);
                LDNCardImage *cardImage = [[LDNCardImage alloc] initWithCard:card];
                if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                    [self.arrayOfCardImageViews addObject:[cardImage drawFromPosition:CGPointMake(xOffset, yOffset) view:self.view size:1.0]];
                } else {
                    [self.arrayOfCardImageViews addObject:[cardImage drawFromPosition:CGPointMake(xOffset, yOffset) view:self.view size:0.5]];
                }
                
            }
        }
        
        [self createCardSpeeds];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
}

- (void)timerFired:(int)count {
    if (self.count == -1) {
        self.timer = nil;
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    } else {
       [self animateCardImageView:(self.arrayOfCardImageViews)[(self.count+(self.arrayOfCardImageViews.count-52))]];
        self.count--;
    }
}

- (void)moveCard:(UIImageView *)cardImageView offset:(CGPoint)offset rotation:(CGFloat)rotation atIndex:(CGFloat)index {
    CGFloat totalX = cardImageView.center.x + offset.x;
    CGFloat totalY = cardImageView.center.y + offset.y;
    if (totalX < self.view.bounds.size.width && totalX > 0 && totalY > 0 && totalY < self.view.bounds.size.height) {
        cardImageView.center = CGPointMake(cardImageView.center.x + offset.x,
                                           cardImageView.center.y + offset.y);
        cardImageView.transform = CGAffineTransformRotate(cardImageView.transform, M_PI/180 * rotation);
    } else {
        [self.cardImageSpeeds removeObjectAtIndex:index];
        [self.cardImageSpeeds insertObject:[NSNumber numberWithInt:(arc4random() % 100 + 25)] atIndex:index];
    }
}

- (void)animateCardImageView:(UIImageView *)cardImageView {
    CGPoint randomPosition = CGPointMake((arc4random() % (int)self.view.bounds.size.width), (arc4random() % (int)self.view.bounds.size.height));
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:[cardImageView.layer position]];
    positionAnimation.toValue = [NSValue valueWithCGPoint:randomPosition];
    positionAnimation.duration = 0.5;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    cardImageView.layer.position = randomPosition;
    
    [cardImageView.layer addAnimation:positionAnimation forKey:@"position"];
    
    CGFloat degrees = (arc4random() % 180 + 1);
    CABasicAnimation* rotationAnimation;
    CATransform3D transform = CATransform3DIdentity;
    CATransform3D rotation = CATransform3DRotate(transform, degrees, 0.0, 0.0, -1.0);
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotation];
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.duration = 0.5;
    rotationAnimation.timingFunction = [CAMediaTimingFunction
                                        functionWithName:kCAMediaTimingFunctionEaseOut];
    cardImageView.layer.transform = rotation;
    [cardImageView.layer addAnimation: rotationAnimation forKey: @"transform"];
}

#define kAccelerometerFrequency        50.0 //Hz
-(void)configureAccelerometer
{
    UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
    theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
    
    theAccelerometer.delegate = self;
    // Delegate events begin immediately.
}

#define kFilteringFactor 0.1
UIAccelerationValue accelX, accelY, accelZ;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor));
    accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor));
    accelZ = (acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor));
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        for (int count=0; count < self.arrayOfCardImageViews.count; count++) {
            [self moveCard:(self.arrayOfCardImageViews)[count] offset:CGPointMake(accelX*[(self.cardImageSpeeds)[count] intValue], accelY*(-1)*[(self.cardImageSpeeds)[count] intValue]) rotation:accelY*5 atIndex:count];
        }
    } else {
        for (int count=0; count < self.arrayOfCardImageViews.count; count++) {
            [self moveCard:(self.arrayOfCardImageViews)[count] offset:CGPointMake(accelY*[(self.cardImageSpeeds)[count] intValue], accelX*[(self.cardImageSpeeds)[count] intValue]) rotation:accelY*5 atIndex:count];
        }
    }
    
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
