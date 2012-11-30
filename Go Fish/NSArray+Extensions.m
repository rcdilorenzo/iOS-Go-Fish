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
        if ([self[i] isEqualToString:string]) {
            containsObject = YES;
        }
    }
    return containsObject;
    
}

- (NSArray *)uniqueArrayWithKey:(NSString *) key {
    NSMutableSet *tempValues = [[NSMutableSet alloc] init];
    NSMutableArray *uniqueArray = [NSMutableArray array];
    for(id obj in self) {
        if(! [tempValues containsObject:[obj valueForKey:key]]) {
            [tempValues addObject:[obj valueForKey:key]];
            [uniqueArray addObject:obj];
        }
    }
    return uniqueArray;
}

@end
