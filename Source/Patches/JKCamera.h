//
//  JKCamera.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKCamera : JKPatch

@property(nonatomic, strong) NSNumber *inputOriginX;
@property(nonatomic, strong) NSNumber *inputOriginY;
@property(nonatomic, strong) NSNumber *inputOriginZ;
@property(nonatomic, strong) NSNumber *inputRotateX;
@property(nonatomic, strong) NSNumber *inputRotateY;
@property(nonatomic, strong) NSNumber *inputRotateZ;
@property(nonatomic, strong) NSNumber *inputTranslateX;
@property(nonatomic, strong) NSNumber *inputTranslateY;
@property(nonatomic, strong) NSNumber *inputTranslateZ;
@property(nonatomic, strong) NSNumber *inputScaleX;
@property(nonatomic, strong) NSNumber *inputScaleY;
@property(nonatomic, strong) NSNumber *inputScaleZ;

@end
