//
//  JKSplitter.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/12/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSplitter.h"

@interface JKSplitter ()
@property(nonatomic, strong) id output;
@end

@implementation JKSplitter

@dynamic input, output;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValueForInputKeyChange:@"input"]) {
        return;
    }
    
    self.output = self.input;
}

@end
