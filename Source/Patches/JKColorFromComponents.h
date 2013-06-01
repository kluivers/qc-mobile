//
//  JKColorFromComponents.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKColorFromComponents : JKPatch

@property(nonatomic, strong) NSNumber *input1;
@property(nonatomic, strong) NSNumber *input2;
@property(nonatomic, strong) NSNumber *input3;
@property(nonatomic, strong) NSNumber *inputAlpha;

@property(nonatomic, readonly) CIColor *outputColor;

@end
