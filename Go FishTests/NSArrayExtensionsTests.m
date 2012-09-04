//
//  NSArrayExtensionsTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/4/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "NSArrayExtensionsTests.h"
#import "NSArray+Extensions.h"

@implementation NSArrayExtensionsTests

- (void)testArrayContainsObject {
    NSArray *myArray = [[NSArray alloc] initWithObjects:@"Object 1", @"Object 2", nil];
    STAssertTrue([myArray containsString:@"Object 1"], @"Array should contain this string.");
    
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] initWithObjects:@"This Object", @"That Object", nil];
    STAssertTrue([myMutableArray containsString:@"That Object"], @"Mutable Array should contain this string.");
}

@end
