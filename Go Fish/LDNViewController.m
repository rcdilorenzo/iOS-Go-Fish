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
@property (weak, nonatomic) IBOutlet UIView *gameMessageView;

@end

@implementation LDNViewController

- (id)init {
    self = [super init];
    if (self) {
        _game = [[LDNGoFishGame alloc] init];
    }
    return self;
}

#pragma-mark
#pragma-mark System Callbacks
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.game setup];
    self.livePlayerDecision = [[NSMutableDictionary alloc] initWithCapacity:2];
    [self setDefaultLivePlayerDecision];
    [self updatePlayerNamesAndScores];
    [self.livePlayerTurnView setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateUI];
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
    [self setGameMessageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.gameMessageView.frame = CGRectMake(self.gameMessageView.frame.origin.x, self.gameMessageView.frame.origin.y, self.gameMessageView.frame.size.width, 25*self.game.gameMessages.count+35);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma-mark
#pragma-mark Game Events
- (void)setDefaultLivePlayerDecision {
    [self.livePlayerDecision setValue:[self.game.players objectAtIndex:1] forKey:@"player"];
    [self.livePlayerDecision setValue:[[[[self.game.players objectAtIndex:0] cards] objectAtIndex:0] rank] forKey:@"rank"];
}

- (IBAction)startGame:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [sender setAlpha:0.0];
                         self.navigationBar.topItem.title = [NSString stringWithFormat:@"Go Fish: %u Cards Remaining", [self.game.deck numberOfCards]];
                     }
                     completion:^(BOOL finished){
                         [self takePlayerTurn:nil];
                     }];
}

- (void)takePlayerTurn:(id)sender {
    [self.gamePlayTimer invalidate];
    if (self.game.end == YES) {
        NSLog(@"Game Ended");
        [self endGame];
        return;
    }
    if (self.game.currentPlayer == [self.game.players objectAtIndex:0]) {
        [self.livePlayerPicker reloadComponent:1];
        [UIView animateWithDuration:0.5 animations:^{[self.livePlayerTurnView setAlpha:1.0];}];
    } else {
        [self.game.currentPlayer takeTurn];
        self.gamePlayTimer = [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(takePlayerTurn:) userInfo:nil repeats:YES];
    }
    [self updateUI];
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"Go Fish: %u Cards Remaining", [self.game.deck numberOfCards]];
}

- (IBAction)takeLivePlayerTurn:(id)sender {
    [self.game.currentPlayer setChoosenPlayer:[self.livePlayerDecision valueForKey:@"player"]];
    [self.game.currentPlayer setChoosenRank:[self.livePlayerDecision valueForKey:@"rank"]];
    [self.game.currentPlayer takeTurn];
    [UIView animateWithDuration:0.5
                     animations:^{[self.livePlayerTurnView setAlpha:0.0];}
                     completion:^(BOOL finished) {[self takePlayerTurn:nil];}];
}

- (void)endGame {
    [self.livePlayerCardsView removeFromSuperview];
    [self.playerTwoCardsView removeFromSuperview];
    [self.playerThreeCardsView removeFromSuperview];
    [self.playerFourCardsView removeFromSuperview];
    
    [self.livePlayerName removeFromSuperview];
    [self.playerTwoLabel removeFromSuperview];
    [self.playerThreeLabel removeFromSuperview];
    [self.playerFourLabel removeFromSuperview];
    self.navigationBar.topItem.title = @"Go Fish: Game Ended";
}

#pragma-mark
#pragma-mark Game Messages
- (void)writeGameMessages:(NSMutableArray *)messages {
    NSMutableArray *messageLabels = [[NSMutableArray alloc] init];
    
    // Adjust frame based on the amount of messages
    self.gameMessageView.frame = CGRectMake(self.gameMessageView.frame.origin.x, self.gameMessageView.frame.origin.y, self.gameMessageView.frame.size.width, 25*messages.count+35);
    
    for (int i=1; i<=messages.count; i++) {
        CGRect frame = CGRectMake(20, 25*i-5, self.gameMessageView.frame.size.width-40, 20);
        [messageLabels addObject:[self drawGameMessage:[messages objectAtIndex:i-1] frame:frame]];
        NSLog(@"%@", NSStringFromCGRect(frame));
    }
    [UIView animateWithDuration:1.0 animations:^{self.gameMessageView.alpha = 1.0;} completion:^(BOOL finished){
        [UIView animateWithDuration:1.5 delay:3.5 options:UIViewAnimationCurveEaseOut animations:^{self.gameMessageView.alpha = 0;} completion:^(BOOL finished){
            for (int i=0; i<messageLabels.count; i++) {
                [[messageLabels objectAtIndex:i] removeFromSuperview];
            }
            [self.game clearGameMessages];
        }];
    }];
}

- (UILabel *)drawGameMessage:(NSString *)message frame:(CGRect)frame {
    UILabel *gameMessage = [[UILabel alloc] initWithFrame:frame];
    gameMessage.adjustsFontSizeToFitWidth = YES;
    gameMessage.text = message;
    gameMessage.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    gameMessage.backgroundColor = [UIColor clearColor];
    gameMessage.textColor = [UIColor colorWithRed:0.00f green:0.35f blue:0.02f alpha:1.00f];
    [self.gameMessageView addSubview:gameMessage];
    return gameMessage;
}

#pragma-mark
#pragma-mark Update Cards
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
        // [card drawFromPosition:position view:self.playerTwoCardsView size:0.8];
        [card drawCardBackFromPosition:position view:self.playerTwoCardsView size:0.8];
        position.y += 30;
    }
}

- (void)updatePlayerThreeCards {
    [self removeAllSubviewsFrom:self.playerThreeCardsView];
    // NSMutableArray *playerThreeCards = [[self.game.players objectAtIndex:2] cards];
    // CGFloat xOffset = (581/2) - ((([playerThreeCards count]*40)+18)/2);
    CGPoint position = CGPointMake(0, 10);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:2] cards]) {
        // [card drawFromPosition:position view:self.playerThreeCardsView size:0.8];
        [card drawCardBackFromPosition:position view:self.playerThreeCardsView size:0.8];
        position.x += 40;
    }
}

- (void)updatePlayerFourCards {
    [self removeAllSubviewsFrom:self.playerFourCardsView];
    CGPoint position = CGPointMake(30, 0);
    for (LDNPlayingCard *card in [[self.game.players objectAtIndex:3] cards]) {
        // [card drawFromPosition:position view:self.playerFourCardsView size:0.8];
        [card drawCardBackFromPosition:position view:self.playerFourCardsView size:0.8];
        position.y += 30;
    }
}

- (void)updatePlayerNamesAndScores {
    self.livePlayerName.text = [NSString stringWithFormat:@"%@ - %u Books", [[self.game.players objectAtIndex:0] name], [[self.game.players objectAtIndex:0] books].count];
    self.playerTwoLabel.text = [NSString stringWithFormat:@"%@ - %u", [[self.game.players objectAtIndex:1] name], [[self.game.players objectAtIndex:0] books].count];
    self.playerThreeLabel.text = [NSString stringWithFormat:@"%@ - %u Books", [[self.game.players objectAtIndex:2] name], [[self.game.players objectAtIndex:0] books].count];
    self.playerFourLabel.text = [NSString stringWithFormat:@"%@ - %u", [[self.game.players objectAtIndex:3] name], [[self.game.players objectAtIndex:0] books].count];
}

- (void)updateUI {
    if (self.game.gameMessages.count != 0) {
        NSLog(@"%@", self.game.gameMessages);
        [self writeGameMessages:self.game.gameMessages];
    }
    [self updatePlayerNamesAndScores];
    [self updateLivePlayerCards];
    [self updatePlayerTwoCards];
    [self updatePlayerThreeCards];
    [self updatePlayerFourCards];
}

#pragma-mark
#pragma-mark Picker View
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
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 200;
    } else if (component == 1) {
        return 100;
    }
    return 200;
}

@end
