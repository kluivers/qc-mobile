//
//  JKConditional.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKConditional.h"

typedef NS_ENUM(NSUInteger, JKConditionalTest) {
    JKTestIsEqual,
    JKTestIsNotEqual,
    JKTestIsGreater,
    JKTestIsLower,
    JKTestIsGreaterEqual,
    JKTestIsLowerEqual
};

@interface JKConditional ()
@property(nonatomic, strong) NSNumber *outputResult;
@end

@implementation JKConditional

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    CGFloat value1 = [self.inputValue1 floatValue];
    CGFloat value2 = [self.inputValue2 floatValue];
    CGFloat tolerance = [self.inputTolerance floatValue];
    
    BOOL result = NO;
    
    switch ([self.inputTest unsignedIntegerValue]) {
        case JKTestIsEqual:
            result = fabsf(value1 - value2) <= tolerance;
            break;
        case JKTestIsNotEqual:
            result = fabs(value1 - value2) > tolerance;
            break;
        case JKTestIsGreater:
            result = value1 > (value2 + tolerance);
            break;
        case JKTestIsLower:
            result = value1 < (value2 - tolerance);
            break;
        case JKTestIsGreaterEqual:
            result = value1 >= (value2 + tolerance);
            break;
        case JKTestIsLowerEqual:
            result = value1 <= (value2 - tolerance);
            break;
    }
    
    self.outputResult = @(result);
}

@end
