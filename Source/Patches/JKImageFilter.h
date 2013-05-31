//
//  JKImageFilter.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKImageFilter : JKPatch

@property(nonatomic, strong) CIImage *inputImage;
@property(nonatomic, readonly) CIImage *outputImage;

@end
