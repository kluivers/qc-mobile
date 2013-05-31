//
//  JKGradient.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/24/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKGradient : JKPatch

@property(nonatomic, readonly) NSNumber *numberofPoints;
@property(nonatomic, readonly) BOOL clearDepthBuffer;

@property(nonatomic, retain) NSNumber *inputDirection;
@property(nonatomic, retain) CIColor *inputColor1;
@property(nonatomic, retain) CIColor *inputColor2;

@end
