//
//  JKImageFilter.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@class JKImage;

@interface JKImageFilter : JKPatch

@property(nonatomic, strong) JKImage *inputImage;
@property(nonatomic, readonly) JKImage *outputImage;

@end
