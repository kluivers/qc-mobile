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
@property(nonatomic, strong) NSNumber *outputPixelsWide;
@property(nonatomic, strong) NSNumber *outputPixelsHigh;
@property(nonatomic, strong) NSNumber *outputRatio;
@property(nonatomic, strong) NSNumber *outputResolution;
@end

@implementation JKScreenInfo

@dynamic outputHeight, outputWidth, outputPixelsWide, outputPixelsHigh, outputRatio, outputResolution;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    // TODO: only update if needed
    
    self.outputWidth = @2.0f;
    
    CGFloat ratio = (context.size.height / context.size.width);
    self.outputHeight = @(2.0f * ratio);
    
    self.outputPixelsWide = @(context.size.width);
    self.outputPixelsHigh = @(context.size.height);
    
    self.outputRatio = @(context.size.width / context.size.height);
    self.outputResolution = @(context.size.width / 2.0f);
}

@end
