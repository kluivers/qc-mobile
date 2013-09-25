//
//  JKImageDataProvider.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <GLKit/GLKit.h>

#import "JKImageDataProvider.h"

@implementation JKImageDataProvider {
    NSData *_data;
    
    CGImageSourceRef _imgSource;
    
    GLKTextureInfo *_textureInfo;
}

- (id) initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        _data = data;
        _imgSource = NULL;
    }
    return self;
}

- (void) dealloc
{
    if (_imgSource) {
        CFRelease(_imgSource);
    }
}

- (CGSize) size
{
    if (!_imgSource) {
        _imgSource = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    }
    
    NSDictionary *properties = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(_imgSource, 0, NULL));
    
    NSNumber *width = properties[(NSString *)kCGImagePropertyPixelWidth];
    NSNumber *height = properties[(NSString *)kCGImagePropertyPixelHeight];
    
    return CGSizeMake([width floatValue], [height floatValue]);
}

- (CIImage *) ciImage
{
    return [CIImage imageWithData:_data];
}

- (GLuint) textureName
{
    if (!_textureInfo) {
        UIImage *image = [UIImage imageWithData:_data];
        
        NSError *error = nil;
        _textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
        if (!_textureInfo) {
            NSLog(@"Error creating texture: %@", error);
        }
    }
    
    // TODO: check ownership. What happens to the texture when textureInfo object is released
    
    return _textureInfo.name;
}

@end
