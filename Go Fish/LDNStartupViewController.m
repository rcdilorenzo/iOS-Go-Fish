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

@interface LDNStartupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *playerNameField;
@property (weak, nonatomic) IBOutlet CustomGradientButton *startButton;
@property (strong, nonatomic) CardAnimationViewController *cardAnimator;

@end

@implementation LDNStartupViewController
@synthesize playerNameField;
@synthesize startButton;

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
    self.cardAnimator = [[CardAnimationViewController alloc] init];
    [super viewDidLoad];
    [self.view insertSubview:self.cardAnimator.view atIndex:1];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPlayerNameField:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else {
        return NO;
    }

}
- (IBAction)startGame:(id)sender {
    LDNViewController *ldnVC = [self.storyboard instantiateViewControllerWithIdentifier:@"gameController"];
    if (playerNameField.text.length != 0) {
        ldnVC.game = [[LDNGoFishGame alloc] initWithLivePlayer:playerNameField.text];
        [self presentModalViewController:ldnVC animated:YES];
    } else {
        [self.startButton setNormalState:self];
        UIAlertView *invalidPlayerName = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No player name entered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidPlayerName show];
        [self.playerNameField setPlaceholder:@"Re-Enter Name"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startGame:textField];
    return YES;
}


@end