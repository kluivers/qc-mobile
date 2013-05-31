//
//  JKImageDimensions.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageDimensions.h"
#import "JKContext.h"
#import "JKContextUtil.h"

@interface JKImageDimensions ()

@property(nonatomic, strong) NSNumber *outputWidth;
@property(nonatomic, strong) NSNumber *outputHeight;
@property(nonatomic, strong) NSNumber *outputPixelsWide;
@property(nonatomic, strong) NSNumber *outputPixelsHigh;
@property(nonatomic, strong) NSNumber *outputRatio;

@end

@implementation JKImageDimensions

@dynamic inputImage;
@dynamic outputWidth, outputHeight;
@dynamic outputPixelsWide, outputPixelsHigh;
@dynamic outputRatio;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    CGFloat imageWidth = CGRectGetWidth(self.inputImage.extent);
    CGFloat imageHeight = CGRectGetHeight(self.inputImage.extent);
    
    self.outputWidth = @(JKPixelsToUnits(context, imageWidth));
    self.outputHeight = @(JKPixelsToUnits(context, imageHeight));
    
    self.outputPixelsWide = @(imageWidth);
    self.outputPixelsHigh = @(imageHeight);
    
    self.outputRatio = @(imageWidth / imageHeight);
}

@end
