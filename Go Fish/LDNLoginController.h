//
//  LDNLoginController.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/24/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDNLoginController : UIViewController
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIPopoverController *parentPopover;

@end
