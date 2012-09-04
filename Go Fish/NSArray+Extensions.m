//
//  NSArray+Extensions.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/4/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (BOOL)containsString:(NSString *)string {
    BOOL containsObject = NO;
    for (int i=0; i<self.count; i++) {
        if ([[self objectAtIndex:i] isEqualToString:string]) {
            containsObject = YES;
        }
    }
    return containsObject;
    
}

@end
