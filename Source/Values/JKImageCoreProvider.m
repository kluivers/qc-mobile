//
//  JKImageCoreProvider.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageCoreProvider.h"

@implementation JKImageCoreProvider {
    CIImage *_image;
}

- (id) initWithCIImage:(CIImage *)image
{
    self = [super init];
    
    if (self) {
        _image = image;
    }
    
    return self;
}

- (CIImage *) ciImage
{
    return _image;
}

- (GLuint) textureName
{
    NSLog(@"Texture from CIImage: NOT SUPPORTED YET!");
    return 0;
}

- (CGSize) size
{
    return _image.extent.size;
}

@end
