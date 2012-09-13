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
#import "LDNGoFishPlayerViewiPad.h"
#import "LDNGoFishPlayerViewiPhone.h"
#import "Constants.h"
#import "NSArray+Extensions.h"


@interface LDNViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *livePlayerTurnView;
@property (strong, nonatomic) NSMutableDictionary *livePlayerDecision;
@property (weak, nonatomic) IBOutlet UIPickerView *livePlayerPicker;
@property (strong, nonatomic) NSTimer *gamePlayTimer;
@property (strong, nonatomic) LDNMessageManager *messageManager;
@property (strong, nonatomic) UIBarButtonItem *shareButton;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation LDNViewController

#pragma-mark
#pragma-mark System Callbacks
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(newGame)];
    self.navigationBar.topItem.rightBarButtonItem = newGameButton;
    
    [self.game deal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self setUpIPhoneViews];
    } else {
        [self setUpIPadViews];
    }
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
#pragma-mark iPhone Setup
- (void)setUpIPhoneViews {
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.view position:CGPointMake(10, 150) width:300];
    self.messageManager.landscapePosition = CGPointMake(90, 90);
    self.messageManager.fontSize = 16;
    self.messageManager.backgroundColor = [UIColor colorWithRed:0.00f green:0.35f blue:0.02f alpha:0.7f];
    self.navigationBar.translucent = YES;
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleNavigationBarIfNeeded)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    self.tapRecognizer.numberOfTouchesRequired = 1;
    [self.backgroundView addGestureRecognizer:self.tapRecognizer];
    
    [self setUpIPhonePlayerViews];
}

- (void)setUpIPhonePlayerViews {
   
    CGPoint pointArray[] = {CGPointMake(35, 370), CGPointMake(5, 90), CGPointMake(35, 5), CGPointMake(250, 90)};
    NSArray *orientationArray = [NSArray arrayWithObjects:UIOrientationHorizontal, UIOrientationVertical, UIOrientationHorizontal, UIOrientationVertical, nil];
    int autoresizingArray[] = {UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin,
        UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin,
        UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth,
        UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin};
    for (int count=0; count<self.game.players.count; count++) {
        LDNGoFishPlayerViewiPhone *playerView = [[LDNGoFishPlayerViewiPhone alloc] initWithPlayer:[self.game.players objectAtIndex:count]
                                                                                         position:pointArray[count]
                                                                                      orientation:[orientationArray objectAtIndex:count]];
        playerView.autoresizingMask = autoresizingArray[count];
        [self.view insertSubview:playerView belowSubview:self.backgroundView];
    }
}

- (void)toggleNavigationBarIfNeeded {
    if (self.backgroundView && self.navigationBar.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{self.navigationBar.alpha = 0;}];
    } else if (self.backgroundView) {
        [UIView animateWithDuration:0.5 animations:^{self.navigationBar.alpha = 1;}];
    }
}

#pragma-mark
#pragma-mark iPad Setup
- (void)setUpIPadViews {
    self.messageManager = [[LDNMessageManager alloc] initWithSuperview:self.view position:CGPointMake(200, 400) width:380];
    self.messageManager.landscapePosition = CGPointMake(322, 295);
    [self setUpIPadPlayerViews];
}

- (void)setUpIPadPlayerViews {
    CGPoint pointArray[] = {CGPointMake(125, 874), CGPointMake(60, 284), CGPointMake(125, 62), CGPointMake(600, 284)};
    NSArray *orientationArray = [NSArray arrayWithObjects:UIOrientationHorizontal, UIOrientationVertical, UIOrientationHorizontal, UIOrientationVertical, nil];
    int autoresizingArray[] = {UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin,
        UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin,
        UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth,
        UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin};
    for (int count=0; count<self.game.players.count; count++) {
        LDNGoFishPlayerViewiPad *playerView = [[LDNGoFishPlayerViewiPad alloc] initWithPlayer:[self.game.players objectAtIndex:count]
                                                                                     position:pointArray[count]
                                                                                  orientation:[orientationArray objectAtIndex:count]];
        playerView.autoresizingMask = autoresizingArray[count];
        [self.view addSubview:playerView];
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
                         self.navigationBar.topItem.title = [NSString stringWithFormat:@"Go Fish: %u Cards Left", [self.game.deck numberOfCards]];
                     }
                     completion:^(BOOL finished){
                         [self takePlayerTurn:nil];
                     }];
    [self toggleNavigationBarIfNeeded];
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
        [self toggleNavigationBarIfNeeded];
        return;
    }
    if (self.game.currentPlayer == [self.game.players objectAtIndex:0]) {
        [self.livePlayerPicker reloadComponent:0];
        [UIView animateWithDuration:0.5 animations:^{[self.livePlayerTurnView setAlpha:1.0];}];
        [self.livePlayerPicker setNeedsDisplay];
    } else if (sender != @"livePlayerTurnFinished") {
        [self.game.currentPlayer takeTurn];
    }
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"Go Fish: %u Cards Left", [self.game.deck numberOfCards]];
}

- (IBAction)takeLivePlayerTurn:(id)sender {
    [self.game.currentPlayer setChoosenPlayer:[self.livePlayerDecision valueForKey:@"player"]];
    [self.game.currentPlayer setChoosenRank:[self.livePlayerDecision valueForKey:@"rank"]];
    [self.game.currentPlayer takeTurn];
    [UIView animateWithDuration:0.5
                     animations:^{[self.livePlayerTurnView setAlpha:0.0];}
                     completion:^(BOOL finished) {
                         [self takePlayerTurn:@"livePlayerTurnFinished"];
                         if (self.pickerView.center.y == 381) {self.pickerView.center = CGPointMake(self.pickerView.center.x, 166);}
                     }];
}

- (NSString *)getWinnerMessage {
    if ([self.game.winner isKindOfClass:[NSArray class]]) {
        NSMutableString *winnerNames = [NSMutableString stringWithString:@"Winners: "];
        for (LDNGoFishPlayer *winner in self.game.winner) {
            [winnerNames appendFormat:@"%@, ", winner.name];
        }
        return [winnerNames substringToIndex:winnerNames.length-2];
    } else if ([self.game.winner isKindOfClass:[LDNGoFishPlayer class]]) {
        return [NSString stringWithFormat:@"%@ wins!", [self.game.winner name]];
    } else {
        return self.game.winner;
    }
}

- (void)endGame {
    self.navigationBar.topItem.title = @"Go Fish: Game Ended";
    [self createNavigationBarItems];
    self.messageManager.messageDuration = 35.0;
    [self.messageManager displayMessage:[self getWinnerMessage]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Updated Messages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"All Messages Finished" object:nil];
}

- (void)createNavigationBarItems {
    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newGame)];
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(presentShareSheet)];
    self.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:newGameButton, self.shareButton, nil];
}

- (void)presentShareSheet {
    UIActionSheet *shareActions = [[UIActionSheet alloc] initWithTitle:@"Share Game Results" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", nil];
    [shareActions showFromBarButtonItem:self.shareButton animated:YES];
}

- (void)newGame {
    self.messageManager.messageDuration = 5.0;
    [self dismissModalViewControllerAnimated:YES];
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
        return [[[[self.game.players objectAtIndex:0] cards] uniqueArrayWithKey:@"value"] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.game.players objectAtIndex:(row+1)] name];
    } else if (component == 1) {
        return [[[[[self.game.players objectAtIndex:0] cards] uniqueArrayWithKey:@"value"] objectAtIndex:row] rank];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self.livePlayerDecision setObject:[self.game.players objectAtIndex:(row+1)] forKey:@"player"];
    } else if (component == 1) {
        [self.livePlayerDecision setObject:[[[[[self.game.players objectAtIndex:0] cards] uniqueArrayWithKey:@"value"] objectAtIndex:row] rank] forKey:@"rank"];
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

- (IBAction)hidePickerView:(id)sender {
    if (self.pickerView.center.y == 166 && self.pickerView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerView.center = CGPointMake(self.pickerView.center.x, self.pickerView.center.y+215);
        }];
    }
}

- (IBAction)showPickerView:(id)sender {
    if (self.pickerView.center.y == 381 && self.pickerView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerView.center = CGPointMake(self.pickerView.center.x, self.pickerView.center.y-215);
        }];
    }
}

#pragma-mark
#pragma-mark Action Sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:[NSString stringWithFormat:@"%@\'s Go Fish Game Results", [[self.game.players objectAtIndex:0] name]]];
        NSMutableString *messageBody = [NSMutableString stringWithString:@"<b>Go Fish Game Results:</b><br />"];
        for (LDNGoFishPlayer *player in self.game.players) {
            [messageBody appendFormat:@"%@: %u Books<br />", player.name, player.score];
        }
        [messageBody appendFormat:@"<br /><b>%@</b>", [self getWinnerMessage]];
        [mailVC setMessageBody:messageBody isHTML:YES];
        [self presentModalViewController:mailVC animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
