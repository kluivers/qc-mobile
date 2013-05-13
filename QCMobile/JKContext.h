//
//  JKContext.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class EAGLContext, GLKBaseEffect, CIContext;

@protocol JKContext <NSObject>

@property(nonatomic, readonly) CGSize size;
@property(nonatomic, readonly) EAGLContext *glContext;
@property(nonatomic, readonly) GLKBaseEffect *effect;
@property(nonatomic, readonly) CIContext *ciContext;
@property(nonatomic, readonly) GLKMatrix4 projectionMatrix;

@end
