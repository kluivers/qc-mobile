//
//  JKImageCoreProvider.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JKImageProvider.h"

@interface JKImageCoreProvider : NSObject <JKImageProvider>

- (id) initWithCIImage:(CIImage *)image context:(CIContext *)context;

@end
