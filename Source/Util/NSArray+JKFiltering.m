//
//  NSArray+JKFiltering.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/3/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "NSArray+JKFiltering.h"

@implementation NSArray (JKFiltering)

- (NSArray *) jk_filter:(BOOL(^)(id obj))filterBlock
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (id obj in self) {
        if (filterBlock(obj)) [result addObject:obj];
    }
    
    return result;
}

@end
