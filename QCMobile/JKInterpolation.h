//
//  JKInterpolation.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKInterpolation : JKPatch

@property(nonatomic, assign) CGFloat inputDuration;
@property(nonatomic, assign) NSInteger inputRepeat;
@property(nonatomic, assign) CGFloat inputValue1;
@property(nonatomic, assign) CGFloat inputValue2;

@property(nonatomic, readonly) CGFloat outputValue;

@end
