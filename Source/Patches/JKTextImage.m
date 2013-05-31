//
//  JKTextImage.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/13/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "JKTextImage.h"
#import "JKContext.h"
#import "JKContextUtil.h"

@implementation JKTextImage

- (NSAttributedString *) attributedStringInContext:(id<JKContext>)ctx
{
    CGFloat fontSize = JKUnitsToPixels(ctx, [self.inputGlyphSize floatValue]);
    NSString *fontName = self.inputFontName;
    NSLog(@"Font name: %@", fontName);
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSLog(@"Font: %@", font);
    
    return [[NSMutableAttributedString alloc] initWithString:self.inputString attributes:@{NSFontAttributeName: font}];
}

- (CGSize) imageSizeForCurrentInputInContext:(id<JKContext>)ctx
{
    CGSize maxSize = CGSizeMake(FLT_MAX, FLT_MAX);
    
    CGFloat maxWidth = JKUnitsToPixels(ctx, [self.inputWidth floatValue]);
    CGFloat maxHeight = JKUnitsToPixels(ctx, [self.inputHeight floatValue]);
    
    if (maxWidth > 0.0f) {
        maxSize.width = maxWidth;
    }
    
    if (maxHeight > 0.0f) {
        maxSize.height = maxHeight;
    }
    
    NSAttributedString *renderText = [self attributedStringInContext:ctx];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFAttributedStringRef) renderText);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, maxSize, NULL);
    CFRelease(framesetter);
    
    return CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
}


- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    CGSize size = [self imageSizeForCurrentInputInContext:context];
    
    NSLog(@"Suggested size: %@", NSStringFromCGSize(size));
    
    _outputWidth = @(JKPixelsToUnits(context, size.width));
    _outputHeight = @(JKPixelsToUnits(context, size.height));
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, rgbColorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    
    // TODO: core image text rendering
    
    
    
    // NSLog(@"Font name: %@", self.inputFontName);
    // [@"hello world" drawAtPoint:CGPointMake(0, 0) forWidth:size.width withFont:[UIFont fontWithName:self.inputFontName size:24.0] fontSize:24.0f lineBreakMode:NSLineBreakByCharWrapping baselineAdjustment:UIBaselineAdjustmentNone];
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    _outputImage = [CIImage imageWithCGImage:image];
    
    CGImageRelease(image);
}

@end
