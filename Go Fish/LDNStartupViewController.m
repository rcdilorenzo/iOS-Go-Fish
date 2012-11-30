//
//  LDNStartupViewController.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/25/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNStartupViewController.h"
#import "LDNViewController.h"
#import "CustomGradientButton.h"
#import "CardAnimationViewController.h"
#import "LDNMessageManager.h"
#import "LDNLoginController.h"

@interface LDNStartupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *playerNameField;
@property (weak, nonatomic) IBOutlet CustomGradientButton *startButton;
@property (strong, nonatomic) CardAnimationViewController *cardAnimator;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UIBarButtonItem *loginButton;
@property (strong, nonatomic) UIPopoverController *loginPopover;

@end

@implementation LDNStartupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(showLoginPopover:)];
    LDNLoginController *loginVC = [[LDNLoginController alloc] init];
    self.loginPopover = [[UIPopoverController alloc] initWithContentViewController:loginVC];
    loginVC.parentPopover = self.loginPopover;
    self.navigationBar.topItem.leftBarButtonItem = self.loginButton;
    self.cardAnimator = [[CardAnimationViewController alloc] init];
    [super viewDidLoad];
    [self.view insertSubview:self.cardAnimator.view atIndex:1];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.playerNameField resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setPlayerNameField:nil];
    [self setStartButton:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else {
        return NO;
    }

}

- (void)showLoginPopover:(id)sender {
    self.loginPopover.popoverContentSize = CGSizeMake(320, 160);
    [self.loginPopover presentPopoverFromBarButtonItem:self.loginButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    NSLog(@"Subviews of popover: %@", self.loginPopover.contentViewController.view.subviews);
}

- (IBAction)startGame:(id)sender {
    LDNViewController *ldnVC = [self.storyboard instantiateViewControllerWithIdentifier:@"gameController"];
    if (self.playerNameField.text.length != 0) {
        ldnVC.game = [[LDNGoFishGame alloc] initWithLivePlayer:self.playerNameField.text];
        self.playerNameField.text = @"";
        [self presentModalViewController:ldnVC animated:YES];
    } else {
        [self.startButton setNormalState:self];
        UIAlertView *invalidPlayerName = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No player name entered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidPlayerName show];
        [self.playerNameField setPlaceholder:@"Re-Enter Name"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end