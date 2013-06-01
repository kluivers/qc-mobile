//
//  JKColorFromComponents.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKColorFromComponents.h"

@interface JKColorFromComponents ()
@property(nonatomic, strong) CIColor *outputColor;
@end

CGFloat hue2rgb(CGFloat p, CGFloat q, CGFloat t)
{
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1.f/6.f) return p + (q - p) * 6 * t;
    if (t < 0.5f) return q;
    if (t < 2.f/3.f) return p + (q - p) * (2.f/3.f - t) * 6;
    return p;
}

@implementation JKColorFromComponents

@dynamic input1, input2, input3, inputAlpha;
@dynamic outputColor;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    CGFloat value1 = [self.input1 floatValue]; // h or r
    CGFloat value2 = [self.input2 floatValue]; // s or g
    CGFloat value3 = [self.input3 floatValue]; // l or b
    CGFloat alpha = [self.inputAlpha floatValue];
    
    CIColor *color = nil;
    
    if ([self.identifier isEqualToString:@"hsl"]) {
        // hsl to rgb conversion from:
        // http://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion
        
        CGFloat r, g, b;
        
        if (value2 == 0) {
            r = g = b = value3;
        } else {
            CGFloat q = (value3 < 0.5) ? value3 * (1 + value2) : value3 + value2 - value3 * value2;
            CGFloat p = 2 * value3 - q;
            
            r = hue2rgb(p, q, value1 + 1.f/3.f);
            g = hue2rgb(p, q, value1);
            b = hue2rgb(p, q, value1 - 1.f/3.f);
        }
        
        color = [CIColor colorWithRed:r*255.f green:g*255.f blue:b*255.f alpha:alpha];
    } else if ([self.identifier isEqualToString:@"rgb"]) {
        color = [CIColor colorWithRed:value1 green:value2 blue:value3 alpha:alpha];
    }
    
    self.outputColor = color;
}

@end
