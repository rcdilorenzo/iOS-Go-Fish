//
//  NSObject+PeformBlock.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/8/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "NSObject+PeformBlock.h"

@implementation NSObject (PeformBlock)

- (void)performBlock:(void (^)(void))block delay:(NSTimeInterval)delay {
    [self performSelector:@selector(executeBlock:) withObject:[block copy] afterDelay:delay];
}

- (void)executeBlock:(void (^)(void))block {
    block();
}

@end
