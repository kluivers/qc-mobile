//
//  JKPatch.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKPatch : NSObject

@property(nonatomic, readonly) NSDictionary *userInfo;

+ (id) patchWithDictionary:(NSDictionary *)dict;

- (BOOL) isRenderer;

- (void) render;

@end
