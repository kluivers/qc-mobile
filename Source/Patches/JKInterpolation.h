//
//  JKInterpolation.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKInterpolation : JKPatch

@property(nonatomic, assign) NSNumber *inputDuration;
@property(nonatomic, assign) NSNumber *inputRepeat;
@property(nonatomic, assign) NSNumber *inputValue1;
@property(nonatomic, assign) NSNumber *inputValue2;
@property(nonatomic, assign) NSNumber *inputInterpolation;

@property(nonatomic, readonly) NSNumber *outputValue;

@end
