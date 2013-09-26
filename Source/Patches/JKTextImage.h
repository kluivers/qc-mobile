//
//  JKTextImage.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/13/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@class JKImage;

@interface JKTextImage : JKPatch

@property(nonatomic, strong) id inputString;
@property(nonatomic, strong) NSNumber *inputWidth;
@property(nonatomic, strong) NSNumber *inputHeight;
@property(nonatomic, strong) NSNumber *inputGlyphSize;
@property(nonatomic, strong) NSNumber *inputLeading;
@property(nonatomic, strong) NSString *inputFontName;
@property(nonatomic, strong) NSNumber *inputKerning;
@property(nonatomic, strong) NSNumber *inputCulling;

@property(nonatomic, readonly) JKImage *outputImage;
@property(nonatomic, readonly) NSNumber *outputWidth;
@property(nonatomic, readonly) NSNumber *outputHeight;

@end
