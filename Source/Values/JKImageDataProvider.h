//
//  JKImageDataProvider.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JKImageProvider.h"

@interface JKImageDataProvider : NSObject <JKImageProvider>

- (id) initWithData:(NSData *)data;

@end
