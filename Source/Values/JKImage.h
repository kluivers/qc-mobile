//
//  JKImage.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/3/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIImage;

@interface JKImage : NSObject

@property(nonatomic, readonly) CIImage *CIImage;

- (id) initWithCIImage:(CIImage *)image;

- (GLuint) textureFromImageContext:(CIContext *)context;

@end
