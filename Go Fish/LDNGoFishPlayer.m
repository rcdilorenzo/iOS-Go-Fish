//
//  LDNGoFishPlayer.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 7/23/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "LDNGoFishPlayer.h"

@implementation LDNGoFishPlayer
@synthesize name = _name;

- (id)initWithName:(NSString *)aPlayerName {
    _name = aPlayerName;
    return self;
}

@end
