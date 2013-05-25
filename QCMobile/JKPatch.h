//
//  JKPatch.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const JKPortAttributeTypeKey;

/*!
 * JKPortAttributeTypeKey values
 */
extern NSString * const JKPortTypeColor;


@protocol JKContext;
@class JKComposition;

@interface JKPatch : NSObject

@property(nonatomic, strong) NSNumber *_enable;

@property(nonatomic, readonly) NSDictionary *userInfo;
@property(nonatomic, readonly) NSString *key;
@property(nonatomic, readonly) NSString *identifier;

@property(nonatomic, readonly) NSDictionary *customInputPorts;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition;

+ (id) patchWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition;

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *)key;

- (BOOL) isRenderer;

- (void) startExecuting:(id<JKContext>)context __attribute((objc_requires_super));
- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time;

- (void) addInputPortType:(NSString *)type key:(NSString *)key;

- (void) setValue:(id)value forInputKey:(NSString *)key;

- (id) valueForInputKey:(NSString *)key;

- (BOOL) didValueForInputKeyChange:(NSString *)inputKey;
- (BOOL) didValuesForInputKeysChange;
- (void) markInputKeyAsChanged:(NSString *)inputKey;

/*!
 * @name Output keys
 */
- (BOOL) didValueForOutputKeyChanged:(NSString *)key;
- (void) setValue:(id)value forOutputKey:(NSString *)key;
- (id) valueForOutputKey:(NSString *)key;

@end
