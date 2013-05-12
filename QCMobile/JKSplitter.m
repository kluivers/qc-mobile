//
//  JKSplitter.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/12/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSplitter.h"

@implementation JKSplitter

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValueForInputKeyChange:@"input"]) {
        return;
    }
    
    _output = self.input;
}

@end
