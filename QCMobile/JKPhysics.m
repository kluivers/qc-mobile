//
//  JKPhysics.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/30/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPhysics.h"

@implementation JKPhysics

@dynamic inputSampling, inputFriction;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _numberOfInputs = state[@"numberOfInputs"];
    }
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    for (NSUInteger i=1; i<=[self.numberOfInputs unsignedIntegerValue]; i++) {
        id value = [self valueForInputKey:[NSString stringWithFormat:@"input_%d", i]];
        
        NSLog(@"Set %@: %@", [NSString stringWithFormat:@"output_%d", i], value);
        [self setValue:value forOutputKey:[NSString stringWithFormat:@"output_%d", i]];
    }
}

@end
