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
    NSNumber *inputRadius = self.customInputPorts[@"inputRadius"][@"value"];
    
    // TODO: generalize customInputPortStates for filters
    [_filter setValue:inputRadius forKey:@"inputRadius"];
    
    [_filter setValue:self.inputImage forKey:@"inputImage"];
    
    _outputImage = [_filter valueForKey:@"outputImage"];
}

@end
