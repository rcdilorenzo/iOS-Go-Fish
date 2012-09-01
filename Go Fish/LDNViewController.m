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
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *livePlayerName;
@property (weak, nonatomic) IBOutlet UIView *livePlayerCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoLabel;
@property (weak, nonatomic) IBOutlet UIView *playerTwoCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerThreeLabel;
@property (weak, nonatomic) IBOutlet UIView *playerThreeCardsView;
@property (weak, nonatomic) IBOutlet UILabel *playerFourLabel;
@property (weak, nonatomic) IBOutlet UIView *playerFourCardsView;
@property (weak, nonatomic) IBOutlet UIView *livePlayerTurnView;

@property (strong, nonatomic) NSMutableDictionary *livePlayerDecision;
@property (weak, nonatomic) IBOutlet UIPickerView *livePlayerPicker;
@property (strong, nonatomic) NSTimer *gamePlayTimer;

@end

@implementation LDNViewController
@synthesize livePlayerPicker = _livePlayerPicker;
@synthesize livePlayerTurnView = _livePlayerTurnView;

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
    self.livePlayerDecision = [[NSMutableDictionary alloc] initWithCapacity:2];
    [self setDefaultLivePlayerDecision];
    [self.livePlayerTurnView setAlpha:0];
    [self.livePlayerName setFont:[UIFont fontWithName:@"American Typewriter" size:26]];
    self.livePlayerName.text = [[self.game.players objectAtIndex:0] name];
    [self.playerTwoLabel setFont:[UIFont fontWithName:@"American Typewriter" size:26]];
    self.playerTwoLabel.text = [[self.game.players objectAtIndex:1] name];
    [self.playerThreeLabel setFont:[UIFont fontWithName:@"American Typewriter" size:26]];
    self.playerThreeLabel.text = [[self.game.players objectAtIndex:2] name];
    [self.playerFourLabel setFont:[UIFont fontWithName:@"American Typewriter" size:26]];
    self.playerFourLabel.text = [[self.game.players objectAtIndex:3] name];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateCards];
}

- (void)setDefaultLivePlayerDecision {
    [self.livePlayerDecision setValue:[self.game.players objectAtIndex:1] forKey:@"player"];
    [self.livePlayerDecision setValue:[[[[self.game.players objectAtIndex:0] cards] objectAtIndex:0] rank] forKey:@"rank"];
}

- (IBAction)startGame:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [sender setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Animation Complete...");
                         [self takePlayerTurn:nil];
                     }];
}

- (void)takePlayerTurn:(id)sender {
    NSLog(@"takePlayerTurn");
    if (self.game.end == YES) {
        NSLog(@"Game Ended");
        return;
    }
    if (self.game.currentPlayer == [self.game.players objectAtIndex:0]) {
        [self.gamePlayTimer invalidate];
        NSLog(@"live player turn");
        [self.livePlayerPicker reloadComponent:1];
        [UIView animateWithDuration:0.5 animations:^{[self.livePlayerTurnView setAlpha:1.0];}];
        [self updateCards];
    } else {
        NSLog(@"robot player turn");
        [self.gamePlayTimer invalidate];
        [self.game.currentPlayer takeTurn];
        self.gamePlayTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(takePlayerTurn:) userInfo:nil repeats:YES];
        [self updateCards];
        
    }
}

- (IBAction)takeLivePlayerTurn:(id)sender {
    [self.game.currentPlayer setChoosenPlayer:[self.livePlayerDecision valueForKey:@"player"]];
    [self.game.currentPlayer setChoosenRank:[self.livePlayerDecision valueForKey:@"rank"]];
    [self.game.currentPlayer takeTurn];
    [UIView animateWithDuration:0.5
                     animations:^{[self.livePlayerTurnView setAlpha:0.0];}
                     completion:^(BOOL finished) {[self takePlayerTurn:nil];}];
}


- (void)removeAllSubviewsFrom:(UIView *)view {
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

- (void)updateLivePlayerCards {
    [self removeAllSubviewsFrom:self.livePlayerCardsView];
    // NSMutableArray *livePlayerCards = [[self.game.players objectAtIndex:0] cards];
    // CGFloat xOffset = (704/2) - ((([livePlayerCards count]*40)+18)/2);
    CGPoint position = CGPointMake(0, 10);
    
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
    // NSMutableArray *playerThreeCards = [[self.game.players objectAtIndex:2] cards];
    // CGFloat xOffset = (581/2) - ((([playerThreeCards count]*40)+18)/2);
    CGPoint position = CGPointMake(0, 10);
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
    NSLog(@"Updating Cards...");
    [self updateLivePlayerCards];
    NSLog(@"Live Player Cards updated...");
    [self updatePlayerTwoCards];
    [self updatePlayerThreeCards];
    [self updatePlayerFourCards];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 3;
    } else {
        return [[[self.game.players objectAtIndex:0] cards] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.game.players objectAtIndex:(row+1)] name];
    } else if (component == 1) {
        return [[[[self.game.players objectAtIndex:0] cards] objectAtIndex:row] rank];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self.livePlayerDecision setObject:[self.game.players objectAtIndex:(row+1)] forKey:@"player"];
    } else if (component == 1) {
        [self.livePlayerDecision setObject:[[[[self.game.players objectAtIndex:0] cards] objectAtIndex:row] rank] forKey:@"rank"];
    }
    NSLog(@"%@", self.livePlayerDecision);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 200;
    } else if (component == 1) {
        return 100;
    }
    return 200;
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
    [self setNavigationBar:nil];
    [self setTurnPicker:nil];
    [self setLivePlayerTurnView:nil];
    [self setLivePlayerPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self updateCards];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
