//
//  NSObject+PeformBlock.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/8/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//
//  Basic Implementation Credit to:
//  http://stackoverflow.com/a/4007066

#import <Foundation/Foundation.h>

@interface NSObject (PeformBlock)

- (void)performBlock:(void (^)(void))block delay:(NSTimeInterval)delay;

@end
