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
@end

@implementation JKPatch

- (id) initWithState:(NSDictionary *)state key:(NSString *)key
{
    self = [super init];
    
    if (self) {
        _enable = YES;
        _key = key;
        
//        NSLog(@"Patch: %@", state);
        
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
        
        NSDictionary *inputStates = state[@"ivarInputPortStates"];
        if (inputStates) {
            [self setDefaultInputStates:inputStates];
        }
        
        NSDictionary *customInputStates = state[@"customInputPortStates"];
        if (customInputStates) {
            [self setDefaultInputStates:customInputStates];
        }
        _customInputPorts = customInputStates;
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
    
    return [[patchClass alloc] initWithState:dict[@"state"] key:dict[@"key"]];
}

#pragma mark -

- (void) setDefaultInputStates:(NSDictionary *)inputStates
{
    for (NSString *key in [inputStates allKeys]) {
        NSDictionary *inputDefaults = inputStates[key];
        
        [self safeSetValue:inputDefaults[@"value"] forKey:key];
    }
}

- (void) safeSetValue:(NSDictionary *)value forKey:(NSString *)key
{
    id classType = [self class];
    
    objc_property_t property = class_getProperty(classType, [key UTF8String]);
    if (property == NULL) {
        NSLog(@"Property %@ not implemented", key);
        return;
    }
    
    const char *propertyAttributes = property_getAttributes(property);
    
    NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
    NSString *typeAttribute = attributes[0];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        Class typeClass = NSClassFromString(typeClassName);
        
        if (typeClass) {
            id obj = [self convertValue:value toClass:typeClass];
            if (obj) {
                [self setValue:obj forKey:key];
            }
        }
    } else {
        // primitive type, set boxed value
        [self setValue:value forKey:key];
    }
}

- (id) convertValue:(NSDictionary *)value toClass:(Class)type
{
    if (type == [UIColor class]) {
        CGFloat red = [[value objectForKey:@"red"] floatValue];
        CGFloat green = [[value objectForKey:@"green"] floatValue];
        CGFloat blue = [[value objectForKey:@"blue"] floatValue];
        CGFloat alpha = [[value objectForKey:@"alpha"] floatValue];
        
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    
    return nil;
}

#pragma mark -

- (BOOL) isRenderer
{
    return NO;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (!self.enable) {
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
    [self setValue:value forKey:key];
}

- (id) valueForOutputKey:(NSString *)key
{
    return [self valueForKey:key];
}

@end
