//
//  JKMath.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKMath : JKPatch


@property(nonatomic, assign) NSInteger numberOfOperations;

@property(nonatomic, strong) NSNumber *inputValue;
@property(nonatomic, readonly) NSNumber *outputValue;

@end
