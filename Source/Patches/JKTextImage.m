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
#import "JKImage.h"

@interface JKTextImage ()
@property(nonatomic, strong) JKImage *outputImage;
@end

@implementation JKTextImage

@dynamic inputFontName, inputGlyphSize;
@dynamic inputString;

@dynamic outputImage;

- (UIFont *) fontOfSize:(CGFloat)size
{
    NSString *fontName = self.inputFontName;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }

    return font;
}

- (NSAttributedString *) attributedStringInContext:(id<JKContext>)ctx
{
    CGFloat fontSize = JKUnitsToPixels(ctx, [self.inputGlyphSize floatValue]);
    
    return [[NSMutableAttributedString alloc] initWithString:self.inputString attributes:@{NSFontAttributeName: [self fontOfSize:fontSize]}];
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
    
    _outputWidth = @(JKPixelsToUnits(context, size.width));
    _outputHeight = @(JKPixelsToUnits(context, size.height));
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, rgbColorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    
    // TODO: core image text rendering
    
    CGFloat fontSize = JKUnitsToPixels(context, [self.inputGlyphSize floatValue]);
    UIFont *font = [self fontOfSize:fontSize];
    
    // NSLog(@"Font name: %@", self.inputFontName);
    [self.inputString drawAtPoint:CGPointMake(0, 0) forWidth:size.width withFont:font fontSize:fontSize lineBreakMode:NSLineBreakByCharWrapping baselineAdjustment:UIBaselineAdjustmentNone];
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    JKImage *resultImage = [[JKImage alloc] initWithCIImage:[CIImage imageWithCGImage:image]];
    self.outputImage = resultImage;
    
    CGImageRelease(image);
}

@end
