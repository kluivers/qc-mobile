//
//  JKLogic.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKLogic : JKPatch

@property(nonatomic, strong) NSNumber *inputValue1; // BOOL
@property(nonatomic, strong) NSNumber *inputValue2; // BOOL
@property(nonatomic, strong) NSNumber *inputOperation;

@property(nonatomic, readonly) NSNumber *outputResult; // BOOl

@end
