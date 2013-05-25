//
//  JKSmooth.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSmooth.h"

@interface JKSmooth ()
@property(nonatomic, strong) NSNumber *outputValue;
@end

@implementation JKSmooth

@dynamic inputValue;
@dynamic inputIncreasingDuration, inputIncreasingInterpolation;
@dynamic inputDecreasingDuration, inputDecreasingInterpolation;

@dynamic outputValue;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    self.outputValue = self.inputValue;
}

@end
