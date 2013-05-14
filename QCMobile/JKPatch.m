//
//  JKPatch.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <objc/runtime.h>

#import "JKContext.h"
#import "JKPatch.h"
#import "JKUnimplementedPatch.h"
#import "JKConnection.h"

@interface NSUnarchiver : NSCoder
+(id)unarchiveObjectWithData:(id)data;
@end

@interface JKPatch ()
@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSArray *connections;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, readonly) NSMutableArray *changedInputKeys;
@property(nonatomic, readonly) NSDictionary *publishedInputPorts;
@property(nonatomic, readonly) NSDictionary *inputStates;

- (void) resetChangedInputKeys;

@end

@implementation JKPatch {
    NSMutableArray *_inputPorts;
    NSMutableDictionary *_inputPortClass;
    NSMutableDictionary *_inputPortValues;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        __enable = @YES;
        _key = dict[@"key"];
        _identifier = dict[@"identifier"];
        
        _inputPorts = [NSMutableArray array];
        _inputPortClass = [NSMutableDictionary dictionary];
        _inputPortValues = [NSMutableDictionary dictionary];
        _changedInputKeys = [NSMutableArray array];
        
//        NSLog(@"Patch: %@", state);
        
        NSDictionary *state = dict[@"state"];
        
        NSData *userInfoData = state[@"userInfo"];
        if (userInfoData) {
            // TODO: Stop using private API
#pragma message "This uses undocumented private API on iOS"
            _userInfo = [NSUnarchiver unarchiveObjectWithData:userInfoData];
//            NSLog(@"Unarchived userInfo: %@", _userInfo);
        }
        
        NSMutableArray *connections = [NSMutableArray array];
        for (NSString *key in [state[@"connections"] allKeys]) {
            [connections addObject:[JKConnection connectionWithKey:key ports:state[@"connections"][key]]];
        }
        _connections = [NSArray arrayWithArray:connections];
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (NSDictionary *node in state[@"nodes"]) {
            [nodes addObject:[JKPatch patchWithDictionary:node]];
        }
        _nodes = [NSArray arrayWithArray:nodes];
        
        _inputStates = state[@"ivarInputPortStates"];
        
        NSDictionary *customInputStates = state[@"customInputPortStates"];
        _customInputPorts = customInputStates;
        
        NSMutableDictionary *publishedInputPorts = [NSMutableDictionary dictionary];
        NSArray *publishedInputPortsState = state[@"publishedInputPorts"];
        for (NSDictionary *inputPort in publishedInputPortsState) {
            [publishedInputPorts setObject:inputPort forKey:inputPort[@"key"]];
        }
        _publishedInputPorts = publishedInputPorts;
        
        for (NSString *key in state[@"systemInputPortStates"]) {
            id value = state[@"systemInputPortStates"][key][@"value"];
            [self safeSetValue:value forKey:key];
        }
    }
    
    return self;
}

+ (instancetype) patchWithDictionary:(NSDictionary *)dict
{
    NSString *patchClassName = [dict[@"class"] stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"JK"];
    
    Class patchClass = NSClassFromString(patchClassName);
    if (!patchClass) {
        return [[JKUnimplementedPatch alloc] initWithName:patchClassName];
    }
    
    return [[patchClass alloc] initWithDictionary:dict];
}

#pragma mark -

- (void) addInputPortType:(NSString *)type key:(NSString *)key
{
    NSLog(@"%s - %@", __func__, key);
    
    if (![_inputPorts containsObject:key]) {
        [_inputPorts addObject:key];
        _inputPortClass[key] = type;
    }
}

- (void) setDefaultInputStates:(NSDictionary *)inputStates
{
    for (NSString *key in [inputStates allKeys]) {
        NSDictionary *inputDefaults = inputStates[key];
        
        [self safeSetValue:inputDefaults[@"value"] forKey:key];
    }
}

- (void) safeSetValue:(NSDictionary *)value forKey:(NSString *)key
{
    if ([_inputPorts containsObject:key]) {
        NSString *className = _inputPortClass[key];
        id newValue = [self convertValue:value toClass:NSClassFromString(className)];
        [self setValue:newValue forInputKey:key];
        return;
    }
    
    id classType = [self class];
    
    objc_property_t property = class_getProperty(classType, [key UTF8String]);
    if (property == NULL) {
        NSLog(@"Property %@ not implemented", key);
        return;
    }
    
    const char *propertyAttributes = property_getAttributes(property);
    
    NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
    NSString *typeAttribute = attributes[0];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 2) {
        
        NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        Class typeClass = NSClassFromString(typeClassName);
        
        if (typeClass) {
            id obj = [self convertValue:value toClass:typeClass];
            if (obj) {
                [self setValue:obj forInputKey:key];
            }
        }
    } else {
        // primitive type, set boxed value
        [self setValue:value forInputKey:key];
    }
}

- (id) convertValue:(id)value toClass:(Class)type
{
//    NSLog(@"From: %@ (%@) to %@", value, NSStringFromClass([value class]), NSStringFromClass(type));
    
    if (type == [CIColor class]) {
        CGFloat red = [[value objectForKey:@"red"] floatValue];
        CGFloat green = [[value objectForKey:@"green"] floatValue];
        CGFloat blue = [[value objectForKey:@"blue"] floatValue];
        CGFloat alpha = [[value objectForKey:@"alpha"] floatValue];
        
        return [CIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
    } else if (type == [NSNumber class] || type == [NSString class]) {
        return value;
    } 
    
    return nil;
}

#pragma mark -

- (BOOL) isRenderer
{
    return NO;
}

- (void) startExecuting:(id<JKContext>)context
{
    if (_inputStates) {
        [self setDefaultInputStates:_inputStates];
    }
    
    if (_customInputPorts) {
        [self setDefaultInputStates:_customInputPorts];
    }
    
    for (JKPatch *patch in self.nodes) {
        if ([patch respondsToSelector:@selector(startExecuting:)]) {
            [patch startExecuting:context];
        }
    }
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (!self._enable) {
        return;
    }
    
    if ([self.nodes count] < 1) {
        return;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRenderer = %@", @YES];

    // start executing each endpoint
    // for now endpoints are just renderers
    
    NSArray *renderers = [self.nodes filteredArrayUsingPredicate:predicate];
    for (JKPatch *patch in renderers) {
        [self resolveConnectionsForDestination:patch time:time inContext:context];
        [patch execute:context atTime:time];
        [patch resetChangedInputKeys];
    }
}

- (void) resolveConnectionsForDestination:(JKPatch *)destination time:(NSTimeInterval)time inContext:(id<JKContext>)context
{
    NSPredicate *destinationPort = [NSPredicate predicateWithFormat:@"destinationNode == %@", destination.key];
    NSArray *connections = [self.connections filteredArrayUsingPredicate:destinationPort];
    
    for (JKConnection *connection in connections) {
        JKPatch *source = [self patchWithKey:connection.sourceNode];
        
        [self resolveConnectionsForDestination:source time:time inContext:context];
        
        // TODO: check if source executed already
        [source execute:context atTime:time];
        [source resetChangedInputKeys];
        
        id sourceValue = [source valueForOutputKey:connection.sourcePort];
        if (sourceValue) {
            [destination setValue:sourceValue forInputKey:connection.destinationPort];
        }
    }
}

- (JKPatch *) patchWithKey:(NSString *)key
{
    for (JKPatch *patch in self.nodes) {
        if ([patch.key isEqualToString:key]) {
            return patch;
        }
    }
    
    return nil;
}

- (void) setValue:(id)value forInputKey:(NSString *)key
{
    if ([_inputPorts containsObject:key]) {
        if ([_inputPortValues[key] isEqual:value]) {
            return;
        }
        
        if (!value) {
            [_inputPortValues removeObjectForKey:key];
        } else {
            [_inputPortValues setObject:value forKey:key];
        }
        
        [self markInputKeyAsChanged:key];
        
        return;
    }
    
    NSDictionary *inputPort = [self.publishedInputPorts objectForKey:key];
    if (inputPort) {
        NSLog(@"Set published input ports! %@", inputPort);
        
        NSString *node = inputPort[@"node"];
        NSString *port = inputPort[@"port"];
        
        JKPatch *childPatch = [self patchWithKey:node];
        [childPatch setValue:value forInputKey:port];
        
        return;
    }
    
    if ([[self valueForKey:key] isEqual:value]) {
        return;
    }
    
    [self markInputKeyAsChanged:key];
    
    [self setValue:value forKey:key];
}

- (void) markInputKeyAsChanged:(NSString *)inputKey
{
    if (![self.changedInputKeys containsObject:inputKey]) {
        [self.changedInputKeys addObject:inputKey];
    }
}

- (id) valueForOutputKey:(NSString *)key
{
    return [self valueForKey:key];
}

- (id) valueForInputKey:(NSString *)key
{
    if ([_inputPorts containsObject:key]) {
        return [_inputPortValues objectForKey:key];
    }
    
    return [self valueForKey:key];
}

- (BOOL) didValueForInputKeyChange:(NSString *)inputKey
{
    return [self.changedInputKeys containsObject:inputKey];
}

- (BOOL) didValuesForInputKeysChange
{
    return [self.changedInputKeys count] > 0;
}

- (void) resetChangedInputKeys
{
    [self.changedInputKeys removeAllObjects];
}

@end
