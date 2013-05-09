//
//  JKMath.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKMath : JKPatch

@property(nonatomic, assign) CGFloat inputValue;
@property(nonatomic, assign) NSInteger numberOfOperations;

@property(nonatomic, readonly) CGFloat outputValue;

@end
