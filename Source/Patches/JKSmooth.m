//
//  JKSmooth.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSmooth.h"
#import "JKInterpolationMath.h"

// TODO: make reusable, is replicated in Interpolator patch

static CGFloat (*interpolation[])(CGFloat, CGFloat, CGFloat) = {
    &JKLinearInterpolation,
    &JKQuadraticInInterpolation,
    &JKQuadraticOutInterpolation,
    &JKQuadraticInOutInterpolation,
    &JKCubicInInterpolation,
    &JKCubicOutInterpolation,
    &JKCubicInOutInterpolation,
    &JKExponentialInInterpolation,
    &JKExponentialOutInterpolation,
    &JKExponentialInOutInterpolation,
    &JKSinusoidalInInterpolation,
    &JKSinusoidalOutInterpolation,
    &JKSinusoidalInOutInterpolation
};

#define JK_INTERPOLATION_COUNT 13

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
    if ([self didValueForInputKeyChange:@"inputValue"]) {
        [self setFloat:time forStateKey:@"startTime"];
    }
    
    CGFloat startTime = [self floatForStateKey:@"startTime"];
    
    CGFloat lastOutput = [self floatForStateKey:@"lastOutput"];
    CGFloat inputValue = [self.inputValue floatValue];
    CGFloat start, end;
    
    CGFloat duration;
    NSInteger functionIndex = 0;
    
    if (inputValue < lastOutput) {
        // decreasing
        duration = [self.inputDecreasingDuration floatValue];
        functionIndex = [self.inputDecreasingInterpolation integerValue];
    } else {
        // increasing
        duration = [self.inputIncreasingDuration floatValue];
        functionIndex = [self.inputIncreasingInterpolation integerValue];
    }
    
    end = [self.inputValue floatValue];
    if ([self valueForStateKey:@"lastOutput"]) {
        start = [self floatForStateKey:@"lastOutput"];
    } else {
        start = end;
    }
    
    CGFloat progress = (time - startTime) / duration;
    
    int selectedFunction = functionIndex;
    if (selectedFunction >= JK_INTERPOLATION_COUNT) {
        // fallback to default
        NSLog(@"Selected interpolation function out of bounds");
        selectedFunction = 0;
    }
    
    self.outputValue = @(interpolation[selectedFunction](fminf(1.0f, progress), start, end));
    [self setValue:self.outputValue forStateKey:@"lastOutput"];
}

@end
