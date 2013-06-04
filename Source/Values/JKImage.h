//
//  JKImage.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/3/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JKContext.h"

@class CIImage;

@interface JKImage : NSObject

@property(nonatomic, readonly) CGSize size;

- (id) initWithData:(NSData *)data;

- (id) initWithCIImage:(CIImage *)image;

- (GLuint) textureWithContext:(id<JKContext>)context;

@end
