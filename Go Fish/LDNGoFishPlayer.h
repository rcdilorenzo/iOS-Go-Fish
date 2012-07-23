//
//  LDNGoFishPlayer.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDNGoFishPlayer : NSObject

@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)aPlayerName;

@end
