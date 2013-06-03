//
//  NSArray+JKFiltering.h
//  QCDemos
//
//  Created by Joris Kluivers on 6/3/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JKFiltering)

- (NSArray *) jk_filter:(BOOL(^)(id obj))filterBlock;

@end
