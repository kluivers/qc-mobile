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
@property(nonatomic, readonly) BOOL enable;
@property(nonatomic, readonly) NSString *key;

+ (id) patchWithDictionary:(NSDictionary *)dict;

- (BOOL) isRenderer;

- (void) executeAtTime:(NSTimeInterval)time;

@end
