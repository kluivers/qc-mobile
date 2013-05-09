//
//  JKInterpolation.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKInterpolation.h"

@implementation JKInterpolation

- (void) execute
{
    NSLog(@"Duration: %f", self.inputDuration);
    
    CGFloat start = self.inputValue1;
    CGFloat end = self.inputValue2;
    
    NSLog(@"Interpolate from %f to %f", start, end);
}

@end
