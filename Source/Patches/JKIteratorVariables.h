//
//  JKIteratorVariables.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKIteratorVariables : JKPatch

@property(nonatomic, readonly) NSNumber *outputIndex;
@property(nonatomic, readonly) NSNumber *outputPosition;
@property(nonatomic, readonly) NSNumber *outputCount;

@end
