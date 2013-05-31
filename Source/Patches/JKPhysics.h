//
//  JKPhysics.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/30/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKPhysics : JKPatch

@property(nonatomic, readonly) NSNumber *numberOfInputs;
@property(nonatomic, strong) NSNumber *inputSampling; // BOOL
@property(nonatomic, strong) NSNumber *inputFriction;

@end
