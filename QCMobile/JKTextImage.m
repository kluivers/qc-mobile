//
//  JKTextImage.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/13/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKTextImage.h"
#import "JKContext.h"

@implementation JKTextImage

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    CGFloat factor = 2.0f / [context size].width;
    CGSize size = CGSizeMake(200, 60);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, rgbColorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    // NSLog(@"Font name: %@", self.inputFontName);
    // [@"hello world" drawAtPoint:CGPointMake(0, 0) forWidth:size.width withFont:[UIFont fontWithName:self.inputFontName size:24.0] fontSize:24.0f lineBreakMode:NSLineBreakByCharWrapping baselineAdjustment:UIBaselineAdjustmentNone];
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    _outputImage = [CIImage imageWithCGImage:image];
    _outputWidth = @(size.width * factor);
    _outputHeight = @(size.height * factor);
    
    CGImageRelease(image);
}

@end
