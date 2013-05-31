//
//  JKSprite.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@class CIImage;

@interface JKSprite : JKPatch

@property(nonatomic, readonly) NSUInteger antialiasing;

@property(nonatomic, strong) CIColor *inputColor;
@property(nonatomic, strong) NSNumber *inputHeight;
@property(nonatomic, strong) NSNumber *inputWidth;
@property(nonatomic, strong) NSNumber *inputY;
@property(nonatomic, strong) NSNumber *inputX;
@property(nonatomic, strong) NSNumber *inputZ;
@property(nonatomic, strong) NSNumber *inputRX;
@property(nonatomic, strong) NSNumber *inputRY;
@property(nonatomic, strong) NSNumber *inputRZ;
@property(nonatomic, strong) NSNumber *inputCulling;
@property(nonatomic, strong) NSNumber *inputBlending;
@property(nonatomic, strong) NSNumber *inputZBuffer;
@property(nonatomic, strong) CIImage *inputImage;

@end
