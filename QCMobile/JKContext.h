//
//  JKContext.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EAGLContext, CIContext;

@protocol JKContext <NSObject>

@property(nonatomic, readonly) CGSize size;
@property(nonatomic, readonly) EAGLContext *glContext;
@property(nonatomic, readonly) CIContext *ciContext;

@end
