//
//  JKImageProvider.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>


@protocol JKImageProvider <NSObject>

- (CIImage *) ciImage;
- (GLuint) textureName;

- (CGSize) size;

@end
