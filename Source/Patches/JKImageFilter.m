//
//  JKImageFilter.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "JKImageFilter.h"
#import "JKImage.h"
#import "JKContext.h"

@interface JKImageFilter ()
@property(nonatomic, strong) JKImage *outputImage;
@end

@implementation JKImageFilter {
    CIFilter *_filter;
}

@dynamic inputImage, outputImage;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    if (self) {
        _filter = [CIFilter filterWithName:self.identifier];
        
        for (NSString *key in [_filter inputKeys]) {
            
            NSDictionary *attributes = [_filter attributes][key];
            NSLog(@"Attributes: %@", attributes);
            
            if ([attributes[@"CIAttributeClass"] isEqualToString:@"CIVector"]) {
                [self addVectorInputPortNamed:key type:attributes[@"CIAttributeType"]];
            } else if ([attributes[@"CIAttributeClass"] isEqualToString:@"CIColor"]) {
                [self addInputPortType:@"CIColor" key:key];
            } else {
                [self addInputPortType:@"NSObject" key:key];
            }
        }
    }
    return self;
}

- (void) addVectorInputPortNamed:(NSString *)name type:(NSString *)type
{
    if ([type isEqualToString:@"CIAttributeTypeRectangle"]) {
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_X", name]];
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_Y", name]];
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_Z", name]];
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_W", name]];
    } else if ([type isEqualToString:@"CIAttributeTypePosition"]) {
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_X", name]];
        [self addInputPortType:@"NSNumber" key:[NSString stringWithFormat:@"%@_Y", name]];
    }
}

- (id) valueForFilterInputKey:(NSString *)key
{
    NSDictionary *attributes = [_filter attributes][key];
    if ([attributes[@"CIAttributeClass"] isEqualToString:@"CIVector"]) {
        
        CGFloat values[4];
        size_t count = 0;
        
        NSString *type = attributes[@"CIAttributeType"];
        if ([type isEqualToString:@"CIAttributeTypeRectangle"]) {
            values[0] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_X", key]] floatValue];
            values[1] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_Y", key]] floatValue];
            values[2] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_Z", key]] floatValue];
            values[3] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_W", key]] floatValue];
            
            count = 4;
        } else if ([type isEqualToString:@"CIAttributeTypePosition"]) {
            values[0] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_X", key]] floatValue];
            values[1] = [[super valueForInputKey:[NSString stringWithFormat:@"%@_Y", key]] floatValue];
            count = 2;
        }
        
        return [CIVector vectorWithValues:values count:count];
    } else {
        // fallback to default super implementation for values of types
        // other than CIVector
        return [super valueForInputKey:key];
    }
}

/*
 * Some 'complex' properties on filters are split up in individual components
 * on patches. By overwriting the super implementation we intercept requests
 * for keys to complex properties and return the compound structure using
 * `valueForFilterInputKey:`
 */
- (id) valueForInputKey:(NSString *)key
{
    if ([[_filter inputKeys] containsObject:key]) {
        return [self valueForFilterInputKey:key];
    } else {
        return [super valueForInputKey:key];
    }
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    for (NSString *key in [_filter inputKeys]) {
        // TODO: general check to see if input value is JKImage
        if ([key isEqualToString:@"inputImage"]) {
            [_filter setValue:[self.inputImage CIImage] forKey:key];
        } else {
            [_filter setValue:[self valueForInputKey:key] forKey:key];
        }
    }
    
    CIImage *outputImage = [_filter valueForKey:@"outputImage"];
    self.outputImage = [[JKImage alloc] initWithCIImage:outputImage context:context.ciContext];
}

@end
