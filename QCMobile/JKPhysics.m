//
//  JKPhysics.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/30/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPhysics.h"

@interface JKPhysics ()
@property(nonatomic, strong) NSArray *speeds;
@end

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
    NSMutableArray *speeds = [NSMutableArray array];
    
    for (NSUInteger i=1; i<=[self.numberOfInputs unsignedIntegerValue]; i++) {
        NSString *outputKey = [NSString stringWithFormat:@"output_%d", i];
        NSString *inputKey = [NSString stringWithFormat:@"input_%d", i];
        
        id oldValue = [self valueForOutputKey:outputKey];
        id newValue = [self valueForInputKey:inputKey];
        
        if ([self.inputSampling boolValue]) {
            // TODO: take into account time between frames
            
            NSNumber *newSpeed = [self.speeds objectAtIndex:i-1];
            
            if ([self didValueForInputKeyChange:inputKey]) {
                // only calculate speed if value actually changed
                CGFloat speed = [newValue floatValue] - [oldValue floatValue];
                newSpeed = @(speed);
            }
            
            [speeds addObject:newSpeed];
        } else {
            // TODO: take into account time between frames
            
            CGFloat speed = [[self.speeds objectAtIndex:i-1] floatValue];
            
            newValue = @([newValue floatValue] + speed);
            
            speed *= 0.97f;
            
            [speeds addObject:@(speed)];
        }
        
        [self setValue:newValue forOutputKey:outputKey];
    }
    
    self.speeds = speeds;
}

@end
