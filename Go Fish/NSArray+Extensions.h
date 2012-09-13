//
//  NSArray+Extensions.h
//  Go Fish
//
//  Created by Christian Di Lorenzo on 9/4/12.
//  Copyright (c) 2012 Light Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensions)

- (BOOL)containsString:(NSString *)string;
- (NSArray *)uniqueArrayWithKey:(NSString *)key;

@end
