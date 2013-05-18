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

#import "NSString+LowercaseFirst.h"

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
    
    NSMutableDictionary *_outputPortValues;
    NSMutableArray *_changedOutputKeys;
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
        
        _outputPortValues = [NSMutableDictionary dictionary];
        _changedOutputKeys = [NSMutableArray array];
        
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
        for (NSString *key in [customInputStates allKeys]) {
            [self setValue:customInputStates[key][@"value"] forInputKey:key];
        }
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
    if ([[self valueForInputKey:key] isEqual:value]) {
        return;
    }
    
    NSLog(@"Set %@ with %@", key, value);
    
    if (!value) {
        [_inputPortValues removeObjectForKey:key];
    } else {
        [_inputPortValues setObject:value forKey:key];
    }
    
    [self markInputKeyAsChanged:key];
}

- (void) markInputKeyAsChanged:(NSString *)inputKey
{
    if (![self.changedInputKeys containsObject:inputKey]) {
        [self.changedInputKeys addObject:inputKey];
    }
}

- (id) valueForInputKey:(NSString *)key
{
    return [_inputPortValues objectForKey:key];
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

#pragma mark - Output ports

- (BOOL) didValueForOutputKeyChanged:(NSString *)key
{
    return [_changedOutputKeys containsObject:key];
}

- (void) markOutputKeyAsChanged:(NSString *)key
{
    // TODO: reset changed output keys
    
    if (![_changedOutputKeys containsObject:key]) {
        [_changedOutputKeys addObject:key];
    }
}

- (void) setValue:(id)value forOutputKey:(NSString *)key
{
    id currentValue = [_outputPortValues objectForKey:key];
    
    if ([currentValue isEqual:value]) {
        return;
    }
    
    [self markOutputKeyAsChanged:key];
    
    if (!value) {
        [_outputPortValues removeObjectForKey:key];
        return;
    }
    
    [_outputPortValues setObject:value forKey:key];
}

- (id) valueForOutputKey:(NSString *)key
{
    return [_outputPortValues objectForKey:key];
}

#pragma mark - Dynamic property implementation for input/output keys

+ (NSString *) propertyNameFromSelector:(SEL)aSelector
{
    NSString *selectorAsString = NSStringFromSelector(aSelector);
    if (![selectorAsString hasPrefix:@"set"]) {
        return selectorAsString;
    }
    
    NSInteger endModifier = 0;
    if ([selectorAsString hasSuffix:@":"]) {
        endModifier = 1;
    }
    NSRange nameRange = NSMakeRange(3, [selectorAsString length] - 3 - endModifier);
    
    NSString *trimmedName = [selectorAsString substringWithRange:nameRange];
    return [trimmedName lowercaseFirstString];
}

+ (BOOL) resolveInstanceMethod:(SEL)sel
{
    NSString *method = NSStringFromSelector(sel);
    NSString *propertyName = [self propertyNameFromSelector:sel];
    
    if (![propertyName hasPrefix:@"output"] && ![propertyName hasPrefix:@"input"]) {
        return [super resolveInstanceMethod:sel];
    }
    
    id classType = [self class];
    
    objc_property_t property = class_getProperty(classType, [propertyName UTF8String]);
    char *dynamic = property_copyAttributeValue(property, "D");
    if (!dynamic) {
        // not a dynamic property
        free(dynamic);
        return [super resolveInstanceMethod:sel];
    }
    free(dynamic);
    
    if ([method hasPrefix:@"set"]) {
        NSLog(@"Create dynamic setter for: %@", propertyName);
        class_addMethod([self class], sel, (IMP)dynamicPortPropertySetter, "v@:@");
        return YES;
    } else {
        NSLog(@"Create dynamic getter for: %@", propertyName);
        class_addMethod([self class], sel, (IMP)dynamicPortPropertyGetter, "@@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void dynamicPortPropertySetter(JKPatch *self, SEL _cmd, id newValue)
{
    NSString *propertyName = [[self class] propertyNameFromSelector:_cmd];
    BOOL isInput = [propertyName hasPrefix:@"input"];
    
    if (isInput) {
        [self setValue:newValue forInputKey:propertyName];
    } else {
        [self setValue:newValue forOutputKey:propertyName];
    }
}

id dynamicPortPropertyGetter(JKPatch *self, SEL _cmd)
{
    NSString *propertyName = [[self class] propertyNameFromSelector:_cmd];
    BOOL isInput = [propertyName hasPrefix:@"input"];
    
    if (isInput) {
        return [self valueForInputKey:propertyName];
    } else {
        return [self valueForOutputKey:propertyName];
    }
}

/*
- (NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector
{
#pragma message "Clean up memory management"
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSString *propertyName = [self propertyNameFromSelector:aSelector];
    
    NSLog(@"%s - %@", __func__, propertyName);

    
    if (![propertyName hasPrefix:@"output"] && ![propertyName hasPrefix:@"input"]) {
        return [super methodSignatureForSelector:aSelector];
    }
    
    id classType = [self class];
    
    objc_property_t property = class_getProperty(classType, [propertyName UTF8String]);
    if (property == NULL) {
        NSLog(@"Property %@ not implemented", propertyName);
        return [super methodSignatureForSelector:aSelector];
    }
    
    char *dynamic = property_copyAttributeValue(property, "D");
    if (!dynamic) {
        free(dynamic);
        return [super methodSignatureForSelector:aSelector];
    }
    free(dynamic);
    
    char *type = property_copyAttributeValue(property, "T");
    
    if ([selectorName hasPrefix:@"set"]) {
        char *readonly = property_copyAttributeValue(property, "R");
        if (!readonly) {
            free(readonly);
            
            NSString *signatureString = [NSString stringWithFormat:@"%s@:", type];
            return [NSMethodSignature signatureWithObjCTypes:[signatureString UTF8String]];
        }
        free(readonly);
    } else {
        NSString *signatureString = [NSString stringWithFormat:@"v@:%s", type];
        return [NSMethodSignature signatureWithObjCTypes:[signatureString UTF8String]];
    }
    
    free(type);
    
    return [super methodSignatureForSelector:aSelector];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *selectorAsString = NSStringFromSelector([anInvocation selector]);
    NSString *propertyName = [self propertyNameFromSelector:[anInvocation selector]];
    
    if (![propertyName hasPrefix:@"output"] && ![propertyName hasPrefix:@"input"]) {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    id classType = [self class];
    
    objc_property_t property = class_getProperty(classType, [propertyName UTF8String]);
    char *dynamic = property_copyAttributeValue(property, "D");
    if (!dynamic) {
        [super forwardInvocation:anInvocation];
        free(dynamic);
        return;
    }
    
    free(dynamic);
    
    BOOL isInput = [propertyName hasPrefix:@"input"];
    
    if ([selectorAsString hasPrefix:@"set"]) {
        NSLog(@"Set a value...");
        
        __unsafe_unretained id tmpValue = nil;
        [anInvocation getArgument:&tmpValue atIndex:2];
        
        __strong id value = tmpValue;
        
        NSLog(@"Got value...: %@", value);
        
        if (isInput) {
            NSLog(@"Set input value: %@", value);
            [self setValue:value forInputKey:propertyName];
        } else {
            NSLog(@"Set output value: %@", value);
            [self setValue:value forOutputKey:propertyName];
        }
        return;
    } else {
        __unsafe_unretained id value = (isInput) ? [self valueForInputKey:propertyName] : [self valueForOutputKey:propertyName];
        id nilPtr = nil;
        
        NSLog(@"Invocation: %@", anInvocation);
        [anInvocation setReturnValue:&nilPtr];
        
        return;
    }
    
    [super forwardInvocation:anInvocation];
}
*/

@end
