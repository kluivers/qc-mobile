//
//  JKImageLoader.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/10/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageLoader.h"

@implementation JKImageLoader {
    CIImage *_outputImage;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        // TODO: automate setting properties
        _allImages = [state[@"allImages"] integerValue];
        _colorCorrection = [state[@"colorCorrection"] integerValue];
        _fillBackground = [state[@"fillBackground"] integerValue];
        _imageData = state[@"imageData"];
    }
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    // intentionally left blank
}

- (CIImage *) outputImage
{
    if (!_outputImage && _imageData) {
        UIImage *image = [UIImage imageWithData:self.imageData];
        if (!image) {
            NSLog(@"Creating image failed");
            return nil;
        }
        _outputImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    }
    
    return _outputImage;
}

@end
