//
//  LDNLoginController.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/24/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNLoginController.h"
#import "NSData+Additions.h"

@interface LDNLoginController ()
@property (nonatomic) BOOL loginOn;

@end

@implementation LDNLoginController

#define SERVER_URL @"http://localhost:3000"

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
    [super viewDidLoad];
    self.loginOn = YES;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpeg"]];
    [self.view addSubview:backgroundImageView];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Log In"];
    [navBar pushNavigationItem:navItem animated:NO];
    
    UIBarButtonItem *signUpOrSignInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(signUp:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(signIn)];
    navBar.topItem.leftBarButtonItem = signUpOrSignInButton;
    navBar.topItem.rightBarButtonItem = doneButton;
    [self.view addSubview:navBar];
    
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 66, 280, 31)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.placeholder = @"Email";
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.font = [UIFont systemFontOfSize:14];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.emailField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 105, 280, 31)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.placeholder = @"Password";
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.passwordField];
}

- (void)signUp:(id)sender {
    [self dismissSelf];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IMPLEMENT ME" message:@"Please add modal view" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)signIn {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/current-user/info", SERVER_URL]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self dismissSelf];
}

- (void)dismissSelf {
    if (self.parentPopover) {
        [self.parentPopover dismissPopoverAnimated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([(NSHTTPURLResponse *)response statusCode] == 401) {
        [self loginWithEmail:self.emailField.text password:self.passwordField.text url:[[response URL] absoluteString]];
    }
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password url:(NSString *)url {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *crendentials = [NSString stringWithFormat:@"%@:%@", email, password];
    NSData *crendentialsData = [crendentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedCredentials = [NSString stringWithFormat:@"Basic %@", [crendentialsData base64Encoding]];
    [request setValue:encodedCredentials forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *loginResponse;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&loginResponse error:nil];
    NSLog(@"Response URL %@", [loginResponse URL]);
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"Data %@", result);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self setUserDefaults];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    NSLog(@"%@", error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)setUserDefaults {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set User Defaults" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
