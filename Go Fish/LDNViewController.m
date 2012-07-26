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

@end

@implementation LDNViewController
@synthesize livePlayerName = _livePlayerName;
@synthesize livePlayerCardsView = _livePlayerCardsView;
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
    self.livePlayerName.text = [[self.game.players objectAtIndex:0] name];
    LDNPlayingCard *firstCard = [[LDNPlayingCard alloc] initWithRank:@"5" suit:@"Hearts"];
    LDNPlayingCard *secondCard = [[LDNPlayingCard alloc] initWithRank:@"7" suit:@"Spades"];
    LDNPlayingCard *thirdCard = [[LDNPlayingCard alloc] initWithRank:@"9" suit:@"Clubs"];
    LDNPlayingCard *fourthCard = [[LDNPlayingCard alloc] initWithRank:@"Jack" suit:@"Diamonds"];
    LDNPlayingCard *fifthCard = [[LDNPlayingCard alloc] initWithRank:@"King" suit:@"Hearts"];
    LDNPlayingCard *sixthCard = [[LDNPlayingCard alloc] initWithRank:@"King" suit:@"Spades"];
    NSArray *arrayOfCards = [[NSArray alloc] initWithObjects:firstCard, secondCard, thirdCard, fourthCard, fifthCard, sixthCard, nil];
    CGPoint position = CGPointMake((self.livePlayerCardsView.frame.size.width/2)-(40/arrayOfCards.count), 20);
    for (LDNPlayingCard *card in arrayOfCards) {
        [card drawFromPosition:position view:self.livePlayerCardsView size:0.8];
        position.x += 40;
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLivePlayerCardsView:nil];
    [self setLivePlayerName:nil];
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
