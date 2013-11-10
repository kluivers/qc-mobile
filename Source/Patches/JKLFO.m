//
//  JKLFO.m
//  QCDemos
//
//  Created by Joris Kluivers on 10/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKLFO.h"

@interface JKLFO ()
@property(nonatomic, strong) NSNumber *outputValue;
@end

@implementation JKLFO

@dynamic inputType, inputAmplitude, inputOffset, inputPeriod, inputPhase, inputPMWRatio;
@dynamic outputValue;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    CGFloat amplitude = [self.inputAmplitude floatValue];
    CGFloat period = [self.inputPeriod floatValue];
    CGFloat offset = [self.inputOffset floatValue];
    
    CGFloat result;
    
    switch ([self.inputType unsignedIntegerValue]) {
        case JKLFOSine:
            result = offset + amplitude * sinf(((2*M_PI) / period) * time);
            break;
        case JKLFOCos:
            result = offset + amplitude * cosf(((2*M_PI) / period) * time);
            break;
        case JKLFOTriangle:
            result = offset + amplitude * (fabs(1 - 0.5 * period + fmodf(1-time, period)) - 1);
            break;
        case JKLFOSquare:
            result = offset + amplitude * (-1 + roundf(fmodf(time, period) / period) * 2);
            break;
        case JKLFOSawtoothUp:
            result = offset - amplitude + 2*amplitude * (1/period) * fmodf(time, period);
            break;
        case JKLFOSawtootDown:
            result = offset + amplitude - 2*amplitude * (1/period) * fmodf(time, period);
            break;
        case JKLFOPWM:
            // TODO: implement pmw
        case JKLFORandom:
            // TODO: implement random function
        default:
            result = offset;
    }
    
    self.outputValue = @(result);
}

@end
