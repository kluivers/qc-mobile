//
//  JKStructureCount.m
//  QCDemos
//
//  Created by Joris Kluivers on 9/26/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKStructureCount.h"

@interface JKStructureCount ()
@property(nonatomic, strong) NSNumber *outputCount;
@end

@implementation JKStructureCount

@dynamic inputStructure;
@dynamic outputCount;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if ([self.inputStructure isKindOfClass:[NSArray class]]) {
        self.outputCount = @([(NSArray *)self.inputStructure count]);
        NSLog(@"Output count: %@", self.outputCount);
    }
}

@end
