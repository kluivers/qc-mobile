//
//  JKConditional.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKConditional : JKPatch

@property(nonatomic, strong) NSNumber *inputValue1;
@property(nonatomic, strong) NSNumber *inputTest;
@property(nonatomic, strong) NSNumber *inputValue2;
@property(nonatomic, strong) NSNumber *inputTolerance;

@property(nonatomic, readonly) NSNumber *outputResult; // BOOl

@end
