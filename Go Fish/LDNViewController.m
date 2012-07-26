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
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateCards];
}

- (void)removeAllSubviewsFrom:(UIView *)view {
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

- (void)updateLivePlayerCards {
    [self removeAllSubviewsFrom:self.livePlayerCardsView];
    NSMutableArray *livePlayerCards = [[self.game.players objectAtIndex:0] cards];
    CGFloat xOffset = (704/2) - ((([livePlayerCards count]*40)+18)/2);
    CGPoint position = CGPointMake(xOffset, 10);
    
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:0] cards]) {
        [card drawFromPosition:position view:self.livePlayerCardsView size:0.8];
        position.x += 40;
    }
}

- (void)updatePlayerTwoCards {
    [self removeAllSubviewsFrom:self.playerTwoCardsView];
    CGPoint position = CGPointMake(30, 0);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:1] cards]) {
        [card drawFromPosition:position view:self.playerTwoCardsView size:0.8];
        position.y += 40;
    }
}

- (void)updatePlayerThreeCards {
    [self removeAllSubviewsFrom:self.playerThreeCardsView];
    NSMutableArray *playerThreeCards = [[self.game.players objectAtIndex:2] cards];
    CGFloat xOffset = (581/2) - ((([playerThreeCards count]*40)+18)/2);
    CGPoint position = CGPointMake(xOffset, 10);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:2] cards]) {
        [card drawFromPosition:position view:self.playerThreeCardsView size:0.8];
        position.x += 40;
    }
}

- (void)updatePlayerFourCards {
    [self removeAllSubviewsFrom:self.playerFourCardsView];
    CGPoint position = CGPointMake(30, 0);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:3] cards]) {
        [card drawFromPosition:position view:self.playerFourCardsView size:0.8];
        position.y += 40;
    }
}

- (void)updateCards {
    [self updateLivePlayerCards];
    [self updatePlayerTwoCards];
    [self updatePlayerThreeCards];
    [self updatePlayerFourCards];
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
