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
    &JKQuadraticInOutInterpolation
};

#define JK_INTERPOLATION_COUNT 4

@implementation JKInterpolation {
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    CGFloat start = self.inputValue1;
    CGFloat end = self.inputValue2;
    
    if (self.inputRepeat == JKRepeatNone && time > self.inputDuration) {
        _outputValue = end;
        return;
    }
    
    if (self.inputRepeat == JKRepeatMirroredLoopOnce && time > self.inputDuration * 2) {
        _outputValue = start;
        return;
    }
    
    CGFloat duration = self.inputDuration;
    CGFloat progress = fmodf(time, duration);
    
    CGFloat normalizedTime = progress / duration;
    
    if (self.inputRepeat == JKRepeatMirorredLoop || self.inputRepeat == JKRepeatMirroredLoopOnce) {
        CGFloat mirrorProgress = fmodf(time, duration * 2);
        if (mirrorProgress > duration) {
            normalizedTime = 1 - normalizedTime;
        }
    }
    
    int selectedFunction = self.inputInterpolation;
    if (self.inputInterpolation >= JK_INTERPOLATION_COUNT) {
        // fallback to default
        NSLog(@"Selected interpolation function out of bounds");
        selectedFunction = 0;
    }
    _outputValue = interpolation[selectedFunction](normalizedTime, start, end);

//    if (self.inputRepeat == JKRepeatMirorredLoop || self.inputRepeat == JKRepeatMirroredLoopOnce) {
//        duration = duration * 2;
//    }
//    
//    CGFloat progress = fmodf(time, duration);
//    progress = self.inputDuration - fabsf(self.inputDuration - progress);
//    
//    _outputValue = start + (end - start) * progress;
}

@end
