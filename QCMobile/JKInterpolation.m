//
//  JKInterpolation.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <tgmath.h>

#import "JKInterpolation.h"
#import "JKInterpolationMath.h"

typedef NS_ENUM(NSInteger, JKInterpolationRepeat) {
    JKRepeatNone = 0,
    JKRepeatLoop,
    JKRepeatMirorredLoop,
    JKRepeatMirroredLoopOnce
};

typedef NS_ENUM(NSInteger, JKAnimationCurve) {
    JKLinear,
    JKQuadraticIn,
    JKQuadraticOut,
    JKQuadraticInOut,
    JKCubicIn,
    JKCubicOut,
    JKCubicInout,
    JKExponentialIn,
    JKExponentialOut,
    JKExponentialInOut,
    JKSinusoidalIn,
    JKSinusoidalOut,
    JKSinusoidalInOut
};

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

@interface JKInterpolation ()
@property(nonatomic, strong) NSNumber *outputValue;
@end

@implementation JKInterpolation

@dynamic inputDuration, inputRepeat, inputInterpolation, inputValue1, inputValue2;
@dynamic outputValue;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    CGFloat start = [self.inputValue1 floatValue];
    CGFloat end = [self.inputValue2 floatValue];
    
    if ([self.inputRepeat integerValue] == JKRepeatNone && time > [self.inputDuration floatValue]) {
        self.outputValue = @(end);
        return;
    }
    
    if ([self.inputRepeat integerValue] == JKRepeatMirroredLoopOnce && time > [self.inputDuration floatValue] * 2.0f) {
        self.outputValue = @(start);
        return;
    }
    
    CGFloat duration = [self.inputDuration floatValue];
    CGFloat progress = fmodf(time, duration);
    
    CGFloat normalizedTime = progress / duration;
    
    if ([self.inputRepeat integerValue] == JKRepeatMirorredLoop || [self.inputRepeat integerValue] == JKRepeatMirroredLoopOnce) {
        CGFloat mirrorProgress = fmodf(time, duration * 2);
        if (mirrorProgress > duration) {
            normalizedTime = 1 - normalizedTime;
        }
    }
    
    int selectedFunction = [self.inputInterpolation intValue];
    if (selectedFunction >= JK_INTERPOLATION_COUNT) {
        // fallback to default
        NSLog(@"Selected interpolation function out of bounds");
        selectedFunction = 0;
    }
    
    self.outputValue = @(interpolation[selectedFunction](normalizedTime, start, end));
}

@end
