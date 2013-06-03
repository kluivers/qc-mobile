//
//  JKImageLoader.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/10/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageLoader.h"

@interface JKImageLoader ()
@property(nonatomic, strong) JKImage *outputImage;
@end

@implementation JKImageLoader

@dynamic outputImage;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
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
    if (self.outputImage) {
        return;
    }
    
    UIImage *image = [UIImage imageWithData:self.imageData];
    if (!image) {
        NSLog(@"Creating image failed");
    } else {
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        self.outputImage = [[JKImage alloc] initWithCIImage:ciImage];
    }
}

@end
