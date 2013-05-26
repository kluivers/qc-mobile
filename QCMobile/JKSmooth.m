//
//  JKSmooth.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSmooth.h"
#import "JKInterpolationMath.h"

static CGFloat (*interpolation[])(CGFloat, CGFloat, CGFloat) = {
    &JKLinearInterpolation,
    &JKQuadraticInInterpolation,
    &JKQuadraticOutInterpolation,
    &JKQuadraticInOutInterpolation,
    &JKCubicInInterpolation,
    &JKCubicOutInterpolation,
    &JKCubicInOutInterpolation
};

#define JK_INTERPOLATION_COUNT 7

@interface JKSmooth ()
@property(nonatomic, strong) NSNumber *outputValue;
@end

@implementation JKSmooth {
    CGFloat start;
    CGFloat end;
    NSTimeInterval startTime;
    CGFloat duration;
    NSInteger functionIndex;
}

@dynamic inputValue;
@dynamic inputIncreasingDuration, inputIncreasingInterpolation;
@dynamic inputDecreasingDuration, inputDecreasingInterpolation;

@dynamic outputValue;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if ([self didValueForInputKeyChange:@"inputValue"]) {
        startTime = time;
        
        if ([self.inputValue floatValue] < [self.outputValue floatValue]) {
            // decreasing
            duration = [self.inputDecreasingDuration floatValue];
            functionIndex = [self.inputDecreasingInterpolation integerValue];
        } else {
            // increasing
            duration = [self.inputIncreasingDuration floatValue];
            functionIndex = [self.inputIncreasingInterpolation integerValue];
        }
        
        end = [self.inputValue floatValue];
        if (self.outputValue) {
            start = [self.outputValue floatValue];
        } else {
            start = end;
        }
        
    }
    
    CGFloat progress = (time - startTime) / duration;
    
    int selectedFunction = functionIndex;
    if (selectedFunction >= JK_INTERPOLATION_COUNT) {
        // fallback to default
        NSLog(@"Selected interpolation function out of bounds");
        selectedFunction = 0;
    }
    
    self.outputValue = @(interpolation[selectedFunction](fminf(1.0f, progress), start, end));
}

@end
