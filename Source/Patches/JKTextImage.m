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

@property(nonatomic, strong) NSNumber *outputWidth;
@property(nonatomic, strong) NSNumber *outputHeight;
@end

@implementation JKTextImage

@dynamic inputFontName, inputGlyphSize;
@dynamic inputString;

@dynamic outputHeight, outputWidth;
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
    
    NSLog(@"Font size: %f", fontSize);
    
    return [[NSMutableAttributedString alloc] initWithString:self.inputString attributes:@{
        (id)kCTFontAttributeName: [self fontOfSize:fontSize],
        (id)kCTForegroundColorAttributeName: (id)[UIColor whiteColor].CGColor
    }];
}

- (CGSize) imageSizeForString:(NSAttributedString *)string inContext:(id<JKContext>)ctx
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
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, maxSize, NULL);
    CFRelease(framesetter);
    
    return CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
}


- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    NSAttributedString *renderText = [self attributedStringInContext:context];
    
    CGSize size = [self imageSizeForString:renderText inContext:context];
    
    self.outputWidth = @(JKPixelsToUnits(context, size.width));
    self.outputHeight = @(JKPixelsToUnits(context, size.height));
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, rgbColorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    
    // TODO: core text rendering
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    //Create Frame
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)renderText);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    
    //Draw Frame
    CTFrameDraw(frame, ctx);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    JKImage *resultImage = [[JKImage alloc] initWithCIImage:[CIImage imageWithCGImage:image] context:context.ciContext];
    self.outputImage = resultImage;
    
    CGImageRelease(image);
}

@end
