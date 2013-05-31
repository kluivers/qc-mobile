//
//  JKCounter.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKCounter : JKPatch

@property(nonatomic, strong) NSNumber *inputSignal;
@property(nonatomic, strong) NSNumber *inputSignalDown;
@property(nonatomic, strong) NSNumber *inputSignalReset;

@property(nonatomic, readonly) NSNumber *outputCount;

@end
