//
//  JKLFO.h
//  QCDemos
//
//  Created by Joris Kluivers on 10/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

typedef NS_ENUM(NSUInteger, JKLFOType) {
    JKLFOSine,
    JKLFOCos,
    JKLFOTriangle,
    JKLFOSquare,
    JKLFOSawtoothUp,
    JKLFOSawtoothDown,
    JKLFOPWM,
    JKLFORandom
} ;

@interface JKLFO : JKPatch

@property(nonatomic, strong) NSNumber *inputOffset;

/*!
 * Integer input value of type `JKLFOType`
 */
@property(nonatomic, strong) NSNumber *inputType;

@property(nonatomic, strong) NSNumber *inputPMWRatio;
@property(nonatomic, strong) NSNumber *inputPhase;
@property(nonatomic, strong) NSNumber *inputAmplitude;
@property(nonatomic, strong) NSNumber *inputPeriod;

@property(nonatomic, readonly) NSNumber *outputValue;

@end
