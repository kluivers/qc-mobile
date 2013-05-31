//
//  JKVideoInput.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@class CIImage;

@interface JKVideoInput : JKPatch

@property(nonatomic, retain) NSNumber *inputCapture;
@property(nonatomic, readonly) CIImage *outputImage;

@end
