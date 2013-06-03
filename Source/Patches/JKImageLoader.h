//
//  JKImageLoader.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/10/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "JKPatch.h"
#import "JKImage.h"

@interface JKImageLoader : JKPatch

@property(nonatomic, readonly) NSInteger allImages;
@property(nonatomic, readonly) NSInteger colorCorrection;
@property(nonatomic, readonly) NSInteger fillBackground;
@property(nonatomic, readonly) NSData *imageData;

@property(nonatomic, readonly) JKImage *outputImage;


@end
