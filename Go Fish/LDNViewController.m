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
#import "LDNCardImage.h"
#import "LDNMessageManager.h"
#import "LDNGoFishPlayerUI.h"
#import "Constants.h"

@interface LDNViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *livePlayerTurnView;
@property (strong, nonatomic) NSMutableDictionary *livePlayerDecision;
@property (weak, nonatomic) IBOutlet UIPickerView *livePlayerPicker;
@property (strong, nonatomic) NSTimer *gamePlayTimer;
@property (strong, nonatomic) LDNMessageManager *messageManager;

@property (strong, nonatomic) LDNGoFishPlayerUI *playerOne;
@property (strong, nonatomic) LDNGoFishPlayerUI *playerTwo;
@property (strong, nonatomic) LDNGoFishPlayerUI *playerThree;
@property (strong, nonatomic) LDNGoFishPlayerUI *playerFour;
@end

@implementation LDNViewController

#pragma-mark
#pragma-mark System Callbacks
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.view position:CGPointMake(200, 400) width:380];
    self.messageManager.landscapePosition = CGPointMake(322, 295);
    [self.game deal];
    [self setUpPlayers];
    self.livePlayerDecision = [[NSMutableDictionary alloc] initWithCapacity:2];
    [self setDefaultLivePlayerDecision];
    [self.livePlayerTurnView setAlpha:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.messageManager.frame = CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-250, 400, 0);
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newGameMessage:) name:@"Updated Messages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePlayerTurn:) name:@"All Messages Finished" object:nil];
}

- (void)newGameMessage:(id)gameMessages {
    if ([[gameMessages object] count] > 1) {
        [self.messageManager displayMessage:[gameMessages object]];
        [self.game clearGameMessages];
    }
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
    } else if (sender != @"livePlayerTurnFinished") {
        [self.game.currentPlayer takeTurn];
    }
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"Go Fish: %u Cards Remaining", [self.game.deck numberOfCards]];
}

- (IBAction)takeLivePlayerTurn:(id)sender {
    [self.game.currentPlayer setChoosenPlayer:[self.livePlayerDecision valueForKey:@"player"]];
    [self.game.currentPlayer setChoosenRank:[self.livePlayerDecision valueForKey:@"rank"]];
    [self.game.currentPlayer takeTurn];
    [UIView animateWithDuration:0.5
                     animations:^{[self.livePlayerTurnView setAlpha:0.0];}
                     completion:^(BOOL finished) {[self takePlayerTurn:@"livePlayerTurnFinished"];}];
}

- (void)endGame {
    self.navigationBar.topItem.title = @"Go Fish: Game Ended";
}

- (void)setUpPlayers {
    self.playerOne = [[LDNGoFishPlayerUI alloc] initWithPlayer:[self.game.players objectAtIndex:0] superview:self.view position:CGPointMake(124, 874) orientation:UIOrientationHorizontal];
    [self.playerOne draw];
    self.playerOne.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.playerTwo = [[LDNGoFishPlayerUI alloc] initWithPlayer:[self.game.players objectAtIndex:1] superview:self.view position:CGPointMake(60, 284) orientation:UIOrientationVertical];
    [self.playerTwo draw];
    self.playerTwo.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    self.playerThree = [[LDNGoFishPlayerUI alloc] initWithPlayer:[self.game.players objectAtIndex:2] superview:self.view position:CGPointMake(125, 62) orientation:UIOrientationHorizontal];
    [self.playerThree draw];
    self.playerThree.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    self.playerFour = [[LDNGoFishPlayerUI alloc] initWithPlayer:[self.game.players objectAtIndex:3] superview:self.view position:CGPointMake(600, 284) orientation:UIOrientationVertical];
    [self.playerFour draw];
    self.playerFour.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
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

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
