//
//  JKPatch.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKContext;

@interface JKPatch : NSObject

@property(nonatomic, readonly) NSDictionary *userInfo;
@property(nonatomic, readonly) BOOL enable;
@property(nonatomic, readonly) NSString *key;
@property(nonatomic, readonly) NSString *identifier;

@property(nonatomic, readonly) NSDictionary *customInputPorts;

- (id) initWithDictionary:(NSDictionary *)dict;

+ (id) patchWithDictionary:(NSDictionary *)dict;

- (BOOL) isRenderer;

- (void) startExecuting:(id<JKContext>)context;
- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time;

- (void) addInputPortType:(NSString *)type key:(NSString *)key;

- (void) setValue:(id)value forInputKey:(NSString *)key;
- (id) valueForOutputKey:(NSString *)key;
- (id) valueForInputKey:(NSString *)key;

- (BOOL) didValueForInputKeyChange:(NSString *)inputKey;
- (BOOL) didValuesForInputKeysChange;
- (void) markInputKeyAsChanged:(NSString *)inputKey;

@end
