//
//  JKScreenInfo.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKScreenInfo.h"
#import "JKContext.h"

@interface JKScreenInfo ()
@property(nonatomic, strong) NSNumber *outputWidth;
@property(nonatomic, strong) NSNumber *outputHeight;
@end

@implementation JKScreenInfo

@dynamic outputHeight, outputWidth;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    self.outputWidth = @2.0f;
    
    CGFloat ratio = (context.size.height / context.size.width);
    self.outputHeight = @(2.0f * ratio);
}

@end
