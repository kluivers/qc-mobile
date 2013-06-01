//
//  JKExpression.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKExpression : JKPatch

@property(nonatomic, readonly) NSString *expression;

@property(nonatomic, readonly) NSNumber *outputResult;

@end
