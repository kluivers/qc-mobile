//
//  JKPatch.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <objc/runtime.h>

#import "JKComposition.h"
#import "JKCompositionPrivate.h"

#import "JKContext.h"
#import "JKPatch.h"
#import "JKUnimplementedPatch.h"
#import "JKConnection.h"

#import "NSString+LowercaseFirst.h"

NSString * const JKPortAttributeTypeKey = @"JKPortAttributeTypeKey";
NSString * const JKPortTypeColor = @"JKColorPort";

@interface NSUnarchiver : NSCoder
+(id)unarchiveObjectWithData:(id)data;
@end

@interface JKPatch ()
@property(nonatomic, strong) JKPatch *parent;
@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSArray *connections;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, readonly) NSMutableArray *changedInputKeys;

@property(nonatomic, readonly) NSDictionary *publishedInputPorts;
@property(nonatomic, readonly) NSDictionary *publishedOutputPorts;

@property(nonatomic, readonly) NSDictionary *inputStates;

@property(nonatomic, strong) NSDictionary *virtualPatches;

- (void) resetChangedInputKeys;

@end

@implementation JKPatch {
    NSMutableArray *_inputPorts;
    NSMutableDictionary *_inputPortClass;
    NSMutableDictionary *_inputPortValues;
    
    NSMutableDictionary *_outputPortValues;
    NSMutableArray *_changedOutputKeys;
    
    BOOL _isRenderer;
}

@dynamic _enable;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super init];
    
    if (self) {
        _key = dict[@"key"];
        _identifier = dict[@"identifier"];
        
        _inputPorts = [NSMutableArray array];
        _inputPortClass = [NSMutableDictionary dictionary];
        _inputPortValues = [NSMutableDictionary dictionary];
        _changedInputKeys = [NSMutableArray array];
        
        _outputPortValues = [NSMutableDictionary dictionary];
        _changedOutputKeys = [NSMutableArray array];
        
        // TODO: check nodes to see if we are a renderer, based on subpatches
        
        // TODO: modify generated methods to take into account underscores
        self._enable = @YES;
//        [self setValue:@YES forInputKey:@"_enable"];
    
        NSDictionary *state = dict[@"state"];
        
        _version = [state[@"version"] unsignedIntegerValue];
        _timebase = state[@"timebase"];
        
        self.virtualPatches = state[@"virtualPatches"];
        
//        NSData *userInfoData = state[@"userInfo"];
//        if (userInfoData) {
//            // TODO: Stop using private API
//#pragma message "This uses undocumented private API on iOS"
//            _userInfo = [NSUnarchiver unarchiveObjectWithData:userInfoData];
//            NSLog(@"Unarchived userInfo: %@", _userInfo);
//        }
        
        NSMutableArray *connections = [NSMutableArray array];
        for (NSString *key in [state[@"connections"] allKeys]) {
            [connections addObject:[JKConnection connectionWithKey:key ports:state[@"connections"][key]]];
        }
        _connections = [NSArray arrayWithArray:connections];
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (NSDictionary *node in state[@"nodes"]) {
            NSString *className = node[@"class"];
            if ([className hasPrefix:@"/"]) {
                NSLog(@"'Instantiate' virtual patch for: %@", className);
                
                NSDictionary *virtualPatchDict = [composition.virtualPatches objectForKey:className];
                
                if (!virtualPatchDict) {
                    NSLog(@"No virtual patch information found for: %@", className);
                } else {
                    NSDictionary *rootPatchDict = virtualPatchDict[@"rootPatch"];
                    
                    JKPatch *patch = [JKPatch patchWithDictionary:rootPatchDict composition:composition];
                    patch.key = [node objectForKey:@"key"];
                    patch.parent = self;
                    
                    NSDictionary *inputParameters = virtualPatchDict[@"inputParameters"];
                    for (NSString *key in [inputParameters allKeys]) {
                        [patch setValue:inputParameters[key] forInputKey:key];
                    }
                    
                    // TODO: generalize setting custom input states
                    // - this also happens few lines below on self
                    NSDictionary *customInputStates = node[@"state"][@"customInputPortStates"];
                    for (NSString *key in [customInputStates allKeys]) {
                        [patch setValue:customInputStates[key][@"value"] forInputKey:key];
                    }
                    
                    // TODO: set other values from node dictionary to overwrite virtual values
                    // TODO: make sure we have a patch now
                    
                    [nodes addObject:patch];
                }
                
            } else {
                JKPatch *patch = [JKPatch patchWithDictionary:node composition:composition];
                patch.parent = self;
                [nodes addObject:patch];
            }
        }
        _nodes = [NSArray arrayWithArray:nodes];
        
        _isRenderer = NO;
        for (JKPatch *patch in _nodes) {
            if ([patch isRenderer]) {
                _isRenderer = YES;
                break;
            }
        }
        
        _inputStates = state[@"ivarInputPortStates"];
        for (NSString *key in [_inputStates allKeys]) {
            [self setValue:_inputStates[key][@"value"] forInputKey:key];
        }
        
        NSDictionary *customInputStates = state[@"customInputPortStates"];
        for (NSString *key in [customInputStates allKeys]) {
            if ([key isEqualToString:@"Pixels"]) {
                NSLog(@"Set pixels input: %@", customInputStates[key][@"value"]);
            }
            [self setValue:customInputStates[key][@"value"] forInputKey:key];
        }
        _customInputPorts = customInputStates;
        
        NSMutableDictionary *publishedInputPorts = [NSMutableDictionary dictionary];
        NSArray *publishedInputPortsState = state[@"publishedInputPorts"];
        for (NSDictionary *inputPort in publishedInputPortsState) {
            [publishedInputPorts setObject:inputPort forKey:inputPort[@"key"]];
        }
        _publishedInputPorts = publishedInputPorts;
        
        NSMutableDictionary *publishedOutputPorts = [NSMutableDictionary dictionary];
        NSArray *publishedOutputPortsState = state[@"publishedOutputPorts"];
        for (NSDictionary *outputPort in publishedOutputPortsState) {
            [publishedOutputPorts setObject:outputPort forKey:outputPort[@"key"]];
        }
        _publishedOutputPorts = publishedOutputPorts;
        
        for (NSString *key in state[@"systemInputPortStates"]) {
            id value = state[@"systemInputPortStates"][key][@"value"];
            [self safeSetValue:value forKey:key];
        }
    }
    
    return self;
}

+ (instancetype) patchWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    NSString *className = dict[@"class"];
    if ([className hasPrefix:@"/"]) {
        return [[JKUnimplementedPatch alloc] initWithName:[className stringByAppendingString:@" (virtual)"]];
    }
    
    NSString *patchClassName = [className stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"JK"];
    
    Class patchClass = NSClassFromString(patchClassName);
    if (!patchClass) {
        return [[JKUnimplementedPatch alloc] initWithName:patchClassName];
    }
    
    return [[patchClass alloc] initWithDictionary:dict composition:composition];
}

#pragma mark -

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *)key
{
    return nil;
}

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
    
    if (type == [CIColor class] && [value isKindOfClass:[NSDictionary class]]) {
        CGFloat red = [[value objectForKey:@"red"] floatValue];
        CGFloat green = [[value objectForKey:@"green"] floatValue];
        CGFloat blue = [[value objectForKey:@"blue"] floatValue];
        CGFloat alpha = [[value objectForKey:@"alpha"] floatValue];
        
        return [CIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
    } else if (type == [NSNumber class] || type == [NSString class]) {
        return value;
    } 
    
    return value;
}

- (id) convertValue:(id)value toType:(NSString *)type
{
    if ([JKPortTypeColor isEqualToString:type]) {
        return [self convertValue:value toClass:[CIColor class]];
    }
    
    return value;
}

#pragma mark -

- (BOOL) isRenderer
{
    return _isRenderer;
}

- (GLKMatrix4) transform
{
    if (self.parent) {
        return [self.parent transform];
    }
    
    return GLKMatrix4Identity;
}

- (void) startExecuting:(id<JKContext>)context
{
    if (_inputStates) {
        [self setDefaultInputStates:_inputStates];
    }
    
    /*if (_customInputPorts) {
        [self setDefaultInputStates:_customInputPorts];
    }*/
    
    for (JKPatch *patch in self.nodes) {
        if ([patch respondsToSelector:@selector(startExecuting:)]) {
            [patch startExecuting:context];
        }
    }
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self._enable boolValue]) {
        return;
    }
    
    if ([self.nodes count] < 1) {
        return;
    }
    
    NSArray *outputPatches = [self outputPatches];

    for (JKPatch *patch in outputPatches) {
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
        // [source resetChangedOutputKeys];
        [source execute:context atTime:time];
        
//        if ([source.key isEqualToString:@"Patch_1"] || [source.key isEqualToString:@"Patch_9"]) {
//            NSLog(@"Pixels to Units: %@", source.key);
//            NSLog(@"Input pixels: %@", [source valueForInputKey:@"Pixels"]);
//            NSLog(@"Output units: %@", [source valueForOutputKey:@"Units"]);
//        }
        
        [source resetChangedInputKeys];
        
        id sourceValue = [source valueForOutputKey:connection.sourcePort];
        if (sourceValue) {
            [destination setValue:sourceValue forInputKey:connection.destinationPort];
        }
    }
}

#pragma mark - Finding patches

- (JKPatch *) patchWithKey:(NSString *)key
{
    for (JKPatch *patch in self.nodes) {
        if ([patch.key isEqualToString:key]) {
            return patch;
        }
    }
    
    return nil;
}

/*!
 * A patch is an output patch if it is a renderer, or when one of it's outputs has
 * been published.
 */
- (NSArray *) outputPatches {
    NSArray *publishedNodeKeys = [[self.publishedOutputPorts allValues] valueForKeyPath:@"node"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRenderer = %@ OR key in %@", @YES, publishedNodeKeys];
    
    return [self.nodes filteredArrayUsingPredicate:predicate];
}



#pragma mark - Input Ports

- (void) setValue:(id)value forInputKey:(NSString *)key
{
    NSDictionary *publishedInput = [self.publishedInputPorts objectForKey:key];
    if (publishedInput) {
        // forward to node / port
        
        JKPatch *patch = [self patchWithKey:publishedInput[@"node"]];
        [patch setValue:value forInputKey:publishedInput[@"port"]];
        
        return;
    }
    
    NSDictionary *attributes = [[self class] attributesForPropertyPortWithKey:key];
    if (attributes && attributes[JKPortAttributeTypeKey]) {
        value = [self convertValue:value toType:attributes[JKPortAttributeTypeKey]];
    }
    
    if ([[self valueForInputKey:key] isEqual:value]) {
        return;
    }
    
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
    NSDictionary *publishedInput = [self.publishedInputPorts objectForKey:key];
    if (publishedInput) {
        // forward to node / port
        
        JKPatch *patch = [self patchWithKey:publishedInput[@"node"]];
        return [patch valueForInputKey:publishedInput[@"port"]];
    }
    
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
    NSDictionary *outputPort = [self.publishedOutputPorts objectForKey:key];
    if (outputPort) {
        // forward request to port
        
        
        JKPatch *patch = [self patchWithKey:outputPort[@"node"]];
        return [patch valueForOutputKey:outputPort[@"port"]];
    }
    
    return [_outputPortValues objectForKey:key];
}

#pragma mark - Dynamic property implementation for input/output keys

+ (NSArray *) systemInputPorts
{
    return @[@"_enable"];
}

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
    
    if (![propertyName hasPrefix:@"output"] && ![propertyName hasPrefix:@"input"] && ![[[self class] systemInputPorts] containsObject:propertyName]) {
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
        class_addMethod([self class], sel, (IMP)dynamicPortPropertySetter, "v@:@");
        return YES;
    } else {
        class_addMethod([self class], sel, (IMP)dynamicPortPropertyGetter, "@@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void dynamicPortPropertySetter(JKPatch *self, SEL _cmd, id newValue)
{
    NSString *propertyName = [[self class] propertyNameFromSelector:_cmd];
    BOOL isInput = [propertyName hasPrefix:@"input"] || [[[self class] systemInputPorts] containsObject:propertyName];
    
    if (isInput) {
        [self setValue:newValue forInputKey:propertyName];
    } else {
        [self setValue:newValue forOutputKey:propertyName];
    }
}

id dynamicPortPropertyGetter(JKPatch *self, SEL _cmd)
{
    NSString *propertyName = [[self class] propertyNameFromSelector:_cmd];
    BOOL isInput = [propertyName hasPrefix:@"input"] || [[[self class] systemInputPorts] containsObject:propertyName];
    
    if (isInput) {
        return [self valueForInputKey:propertyName];
    } else {
        return [self valueForOutputKey:propertyName];
    }
}

@end
