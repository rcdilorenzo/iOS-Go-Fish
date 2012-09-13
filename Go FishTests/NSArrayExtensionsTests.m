//
//  NSArrayExtensionsTests.m
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/4/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import "NSArrayExtensionsTests.h"
#import "NSArray+Extensions.h"
#import "LDNGoFishPlayer.h"

@implementation NSArrayExtensionsTests

- (void)testArrayContainsObject {
    NSArray *myArray = [[NSArray alloc] initWithObjects:@"Object 1", @"Object 2", nil];
    STAssertTrue([myArray containsString:@"Object 1"], @"Array should contain this string.");
    
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] initWithObjects:@"This Object", @"That Object", nil];
    STAssertTrue([myMutableArray containsString:@"That Object"], @"Mutable Array should contain this string.");
}

- (void)testUniqueArrayCreation {
    NSArray *arrayOfPlayers = [NSArray arrayWithObjects:
                               [[LDNGoFishPlayer alloc] initWithName:@"John"],
                               [[LDNGoFishPlayer alloc] initWithName:@"Jane"],
                               [[LDNGoFishPlayer alloc] initWithName:@"John"], nil];
    STAssertEqualObjects([[[arrayOfPlayers uniqueArrayWithKey:@"name"] objectAtIndex:0] name], @"John", @"First item's name in the array should be John");
    STAssertEqualObjects([[[arrayOfPlayers uniqueArrayWithKey:@"name"] lastObject] name], @"Jane", @"Last item's name in the array should be Jane");
}

@end
