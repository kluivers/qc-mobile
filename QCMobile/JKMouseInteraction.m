//
//  JKMouseInteraction.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKMouseInteraction.h"

#import "JKContext.h"

@interface JKMouseInteraction ()
@property(nonatomic, strong) NSNumber *outputMouseDown;
@property(nonatomic, strong) NSNumber *outputClickCount;
@end

@implementation JKMouseInteraction

@dynamic outputMouseDown, outputClickCount, outputXDrag, outputYDrag;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    UITouch *touch = [context.touches anyObject];
    
    // TODO: only update if needed
    
    self.outputMouseDown = @((touch != nil));
    self.outputClickCount = @(touch.tapCount);
}

@end
