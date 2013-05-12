//
//  JKImageFilter.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/11/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageFilter.h"

@implementation JKImageFilter {
    CIFilter *_filter;
}

- (void) startExecuting:(id<JKContext>)context
{
    _filter = [CIFilter filterWithName:self.identifier];
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValueForInputKeyChange:@"inputImage"] && ![self didValueForInputKeyChange:@"inputRadius"]) {
        return;
    }
    
    _outputImage = [_filter valueForKey:@"outputImage"];
}

- (void) setValue:(id)value forInputKey:(NSString *)key
{
    if ([[_filter inputKeys] containsObject:key]) {
        if ([[_filter valueForKey:key] isEqual:value]) {
            return;
        }
        
        [_filter setValue:value forKey:key];
        [self markInputKeyAsChanged:key];
    } else {
        [super setValue:value forKey:key];
    }
}

@end
