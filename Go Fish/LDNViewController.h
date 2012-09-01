//
//  LDNViewController.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDNGoFishGame.h"

@interface LDNViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) LDNGoFishGame *game;
@property (weak, nonatomic) IBOutlet UIPickerView *turnPicker;

@end
