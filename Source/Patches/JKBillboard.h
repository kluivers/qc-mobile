//
//  JKBillboard.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKSprite.h"

@interface JKBillboard : JKSprite

@property(nonatomic, readonly) NSNumber *CIRendering; // BOOl
@property(nonatomic, readonly) NSNumber *optimizedRendering; // BOOl
@property(nonatomic, readonly) NSString *sizeMode;

@property(nonatomic, strong) NSNumber *inputScale;
@property(nonatomic, strong) NSNumber *inputRotation;
@property(nonatomic, strong) NSNumber *inputPixelAligned;

@end
