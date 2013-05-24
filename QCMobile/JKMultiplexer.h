//
//  JKMultiplexer.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/24/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKMultiplexer : JKPatch

@property(nonatomic, readonly) NSNumber *inputCount;
@property(nonatomic, readonly) NSString *portClass;

@property(nonatomic, strong) NSNumber *inputIndex;
@property(nonatomic, readonly) id output;

@end
