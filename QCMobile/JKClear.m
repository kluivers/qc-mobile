//
//  JKClear.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKClear.h"

@implementation JKClear

@dynamic inputColor;

- (BOOL) isRenderer
{
    return YES;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self._enable boolValue]) {
        return;
    }
    
    glClearColor(self.inputColor.red, self.inputColor.green, self.inputColor.blue, self.inputColor.alpha);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end
