//
//  LDNViewController.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNViewController.h"
#import "LDNPlayingCard.h"
#import "LDNGoFishGame.h"

@interface LDNViewController ()
@property (weak, nonatomic) IBOutlet UILabel *livePlayerName;
@property (weak, nonatomic) IBOutlet UIView *livePlayerCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoLabel;
@property (weak, nonatomic) IBOutlet UIView *playerTwoCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerThreeLabel;
@property (weak, nonatomic) IBOutlet UIView *playerThreeCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerFourLabel;
@property (weak, nonatomic) IBOutlet UIView *playerFourCardsView;

@end

@implementation LDNViewController
@synthesize livePlayerName = _livePlayerName;
@synthesize livePlayerCardsView = _livePlayerCardsView;
@synthesize playerTwoLabel = _playerTwoLabel;
@synthesize playerTwoCardsView = _playerTwoCardsView;
@synthesize playerThreeLabel = _playerThreeLabel;
@synthesize playerThreeCardsView = _playerThreeCardsView;
@synthesize playerFourLabel = _playerFourLabel;
@synthesize playerFourCardsView = _playerFourCardsView;
@synthesize game = _game;

- (id)init {
    self = [super init];
    if (self) {
        _game = [[LDNGoFishGame alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.game setup];
    self.livePlayerName.text = [[self.game.players objectAtIndex:0] name];
    self.playerTwoLabel.text = [[self.game.players objectAtIndex:1] name];
    self.playerThreeLabel.text = [[self.game.players objectAtIndex:2] name];
    self.playerFourLabel.text = [[self.game.players objectAtIndex:3] name];
    [self updateCards];
    
}

- (void)removeAllSubviewsFrom:(UIView *)view {
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

- (void)updateCards {
    [self removeAllSubviewsFrom:self.livePlayerCardsView];
    [self removeAllSubviewsFrom:self.playerTwoCardsView];
    [self removeAllSubviewsFrom:self.playerThreeCardsView];
    [self removeAllSubviewsFrom:self.playerFourCardsView];
    NSMutableArray *livePlayerCards = [[self.game.players objectAtIndex:0] cards];
    CGFloat xOffset = (self.livePlayerCardsView.frame.size.width/2) - ((([livePlayerCards count]*10)+42)/2);
    CGPoint position = CGPointMake(xOffset, 20);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:0] cards]) {
        [card drawFromPosition:position view:self.livePlayerCardsView size:0.8];
        position.x += 40;
    }
    position = CGPointMake(30, 0);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:1] cards]) {
        [card drawFromPosition:position view:self.playerTwoCardsView size:0.8];
        position.y += 40;
    }
    NSMutableArray *playerThreeCards = [[self.game.players objectAtIndex:2] cards];
    xOffset = (self.playerThreeCardsView.frame.size.width/2) - ((([playerThreeCards count]*20)+42)/2);
    position = CGPointMake(xOffset, 20);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:2] cards]) {
        [card drawFromPosition:position view:self.playerThreeCardsView size:0.8];
        position.x += 40;
    }
    position = CGPointMake(30, 0);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:3] cards]) {
        [card drawFromPosition:position view:self.playerFourCardsView size:0.8];
        position.y += 40;
    }
}

- (void)viewDidUnload
{
    [self setLivePlayerCardsView:nil];
    [self setLivePlayerName:nil];
    [self setPlayerThreeLabel:nil];
    [self setPlayerThreeCardsView:nil];
    [self setPlayerTwoLabel:nil];
    [self setPlayerTwoCardsView:nil];
    [self setPlayerFourLabel:nil];
    [self setPlayerFourCardsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
