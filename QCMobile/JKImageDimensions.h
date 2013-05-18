//
//  JKImageDimensions.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@class CIImage;

@interface JKImageDimensions : JKPatch

@property(nonatomic, strong) CIImage *inputImage;

@property(nonatomic, readonly) NSNumber *outputWidth;
@property(nonatomic, readonly) NSNumber *outputHeight;
@property(nonatomic, readonly) NSNumber *outputPixelsWide;
@property(nonatomic, readonly) NSNumber *outputPixelsHigh;
@property(nonatomic, readonly) NSNumber *outputRatio;

@end
