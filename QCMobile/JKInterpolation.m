//
//  JKInterpolation.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <tgmath.h>

#import "JKInterpolation.h"

@interface JKPatch (Private)
- (id) initWithState:(NSDictionary *)state key:(NSString *)key;
@end

@implementation JKInterpolation

- (id) initWithState:(NSDictionary *)state key:(NSString *)key
{
    self = [super initWithState:state key:key];
    if (self) {
        NSLog(@"Interpolation state: %@", state);
    }
    return self;
}

- (void) executeAtTime:(NSTimeInterval)time
{
    CGFloat start = self.inputValue1;
    CGFloat end = self.inputValue2;
    
    CGFloat progress = fmodf(time, self.inputDuration);
    
    _outputValue = start + (end - start) * progress;
    NSLog(@"output: %f", _outputValue);
}

@end
