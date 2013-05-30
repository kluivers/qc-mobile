//
//  JKRecursor.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/29/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKRecursor.h"

@interface JKRecursor ()
@property(nonatomic, strong) NSArray *savedPorts;
@end

@implementation JKRecursor

@dynamic inputInitialize;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        self.savedPorts = state[@"savedPorts"];
    }
    
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    for (NSArray *portInfo in self.savedPorts) {
        NSString *portName = portInfo[1];
        
        id value = nil;
        
        // TODO: also take initial value first time
        
        if ([self.inputInitialize boolValue]) {
            // pass through initial values
            
            NSString *initialValueKey = [NSString stringWithFormat:@"Initial_%@", portName];
            value = [self valueForInputKey:initialValueKey];
        } else {
            // take values from parent patch output ports
            
            value = [self.parent valueForOutputKey:portName];
        }
        
        [self setValue:value forOutputKey:portName];
    }
}

@end
