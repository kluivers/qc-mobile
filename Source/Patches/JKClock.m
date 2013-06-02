//
//  JKClock.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKClock.h"

@interface JKClock ()
@property(nonatomic, strong) NSNumber *outputTime;
@end;

@implementation JKClock {
    BOOL running;
    
    NSTimeInterval startTime;
}

@dynamic inputStartSignal, inputStopSignal, inputResetSignal;
@dynamic outputTime;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        running = NO;
        self.outputTime = @0;
    }
    
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (running) {
        NSTimeInterval currentTime = time - startTime;
        self.outputTime = @(currentTime);
    }
    
    if ([self.inputResetSignal boolValue]) {
        startTime = time;
        self.outputTime = @(0.0);
    }
    
    if ([self.inputStartSignal boolValue] && !running) {
        running = YES;
        startTime = time;
        self.outputTime = @(0.0);
    }
    
    if ([self.inputStopSignal boolValue] && running) {
        running = NO;
    }
}

@end
