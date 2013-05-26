//
//  JKInterpolationMath.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKInterpolationMath.h"

CGFloat JKLinearInterpolation(CGFloat t, CGFloat start, CGFloat end)
{
    return t * end + (1.f - t) * start;
}

#pragma mark - Quadratic

CGFloat JKQuadraticInInterpolation(CGFloat t, CGFloat start, CGFloat end)
{
    return JKLinearInterpolation(t*t, start, end);
}

CGFloat JKQuadraticOutInterpolation(CGFloat t, CGFloat start, CGFloat end)
{
    return JKLinearInterpolation(2*t - t*t, start, end);
}

CGFloat JKQuadraticInOutInterpolation(CGFloat t, CGFloat start, CGFloat end)
{
    CGFloat middle = (start + end) / 2;
    t = 2 * t;
    
    if (t <= 1) {
        return JKLinearInterpolation(t * t, start, middle);
    }
    
    t -= 1;
    
    return JKLinearInterpolation(2*t - t * t, middle, end);
}

#pragma mark - Cubic

CGFloat JKCubicInInterpolation(CGFloat t, CGFloat start, CGFloat end)
{
    return JKLinearInterpolation(t*t*t, start, end);
}

CGFloat JKCubicOutInterpolation(CGFloat t, CGFloat start, CGFloat end) {
    t -= 1;
    return JKLinearInterpolation(t*t*t + 1, start, end);
}

CGFloat JKCubicInOutInterpolation(CGFloat t, CGFloat start, CGFloat end) {
    CGFloat middle = (start + end) / 2;
    
    t = 2 * t;
    
    if (t <= 1) {
        return JKLinearInterpolation(t*t*t, start, middle);
    }
    
    t -= 2;

    return JKLinearInterpolation(t*t*t + 1, middle, end);
}



