//
//  JKCounter.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKCounter.h"

@interface JKCounter ()
@property(nonatomic, strong) NSNumber *outputCount;
@end

@implementation JKCounter

@dynamic inputSignal, inputSignalDown, inputSignalReset;
@dynamic outputCount;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    if ([self didValueForInputKeyChange:@"inputSignalReset"] && [[self valueForInputKey:@"inputSignalReset"] boolValue]) {
        // TODO: decrease output value
        self.outputCount = @(0);
    }
    
    if ([self didValueForInputKeyChange:@"inputSignal"] && [[self valueForInputKey:@"inputSignal"] boolValue]) {
        // TODO: increase output value
        self.outputCount = @([self.outputCount integerValue] + 1);
    }
    
    if ([self didValueForInputKeyChange:@"inputSignalDown"] && [[self valueForInputKey:@"inputSignalDown"] boolValue]) {
        // TODO: decrease output value
        self.outputCount = @([self.outputCount integerValue] + 1);
    }
}

@end
