//
//  JKClear.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKClear.h"

@implementation JKClear

- (BOOL) isRenderer
{
    return YES;
}

- (void) execute
{
    if (!self.enable) {
        return;
    }
    
    NSLog(@"Clear with color: %@", self.inputColor);
    
    CGFloat red = 0.0, green = 0.0f, blue = 0.0f, alpha = 0.0f;
    [self.inputColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    glClearColor(red, green, blue, alpha);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end
