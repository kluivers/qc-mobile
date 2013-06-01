//
//  JKClock.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKClock : JKPatch

@property(nonatomic, strong) NSNumber *inputStartSignal;
@property(nonatomic, strong) NSNumber *inputStopSignal;
@property(nonatomic, strong) NSNumber *inputResetSignal;

@property(nonatomic, readonly) NSNumber *outputTime;

@end
