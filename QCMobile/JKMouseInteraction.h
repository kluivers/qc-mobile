//
//  JKMouseInteraction.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKMouseInteraction : JKPatch

@property(nonatomic, readonly) NSNumber *outputMouseDown;
@property(nonatomic, readonly) NSNumber *outputMouseOver;
@property(nonatomic, readonly) NSNumber *outputClickCount;
@property(nonatomic, readonly) NSNumber *outputXDrag;
@property(nonatomic, readonly) NSNumber *outputYDrag;

@end