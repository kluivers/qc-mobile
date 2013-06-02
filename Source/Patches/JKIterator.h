//
//  JKIterator.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKIterator : JKPatch

@property(nonatomic, strong) NSNumber *inputCount;

// iterator variables
@property(nonatomic, readonly) NSNumber *currentIndex;

@end
