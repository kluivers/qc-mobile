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
    // didValueForInputKeyChange doesn't work in iterators
    
    CGFloat currentInput = [self.inputValue floatValue];
    CGFloat lastInput = [self floatForStateKey:@"lastInput"];
    
    if (fabsf(currentInput - lastInput) > 0.001) {
        [self setValue:self.inputValue forStateKey:@"lastInput"];
        [self setValue:@(time) forStateKey:@"startTime"];
        
        if ([self valueForStateKey:@"lastOutput"]) {
            [self setValue:[self valueForStateKey:@"lastOutput"] forStateKey:@"start"];
        } else {
            [self setValue:self.inputValue forStateKey:@"start"];
        }
    }
    
    CGFloat startTime = [self floatForStateKey:@"startTime"];
    
    CGFloat lastOutput = [self floatForStateKey:@"lastOutput"];
    CGFloat start = [self floatForStateKey:@"start"];
    CGFloat end = [self.inputValue floatValue];
    
    CGFloat duration;
    NSInteger functionIndex = 0;
    
    if (end < lastOutput) {
        // decreasing
        duration = [self.inputDecreasingDuration floatValue];
        functionIndex = [self.inputDecreasingInterpolation integerValue];
    } else {
        // increasing
        duration = [self.inputIncreasingDuration floatValue];
        functionIndex = [self.inputIncreasingInterpolation integerValue];
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
