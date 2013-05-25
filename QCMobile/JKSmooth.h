//
//  JKSmooth.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKSmooth : JKPatch

@property(nonatomic, strong) NSNumber *inputValue;
@property(nonatomic, strong) NSNumber *inputIncreasingDuration;
@property(nonatomic, strong) NSNumber *inputIncreasingInterpolation;
@property(nonatomic, strong) NSNumber *inputDecreasingDuration;
@property(nonatomic, strong) NSNumber *inputDecreasingInterpolation;

@property(nonatomic, readonly) NSNumber *outputValue;

@end
