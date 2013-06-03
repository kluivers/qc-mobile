//
//  JKIterator.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKIterator.h"

@interface JKPatch (JKIteratorPrivate)
@property(nonatomic, readonly) NSDictionary *publishedInputPorts;
- (JKPatch *) patchWithKey:(NSString *)key;
@end

@interface JKIterator ()
@property(nonatomic, strong) NSNumber *currentIndex;
@property(nonatomic, strong) NSMutableDictionary *capturedInputPortValues;
@end

@implementation JKIterator {
    BOOL _isRenderer;
    
}

@dynamic inputCount;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    if (self) {
        _capturedInputPortValues = [NSMutableDictionary dictionary];
    }
    return self;
}

//- (void) setValue:(id)value forInputKey:(NSString *)key
//{
//    NSDictionary *publishedInput = [self.publishedInputPorts objectForKey:key];
//    if (publishedInput) {
//        // capture value
//        [self.capturedInputPortValues setObject:value forKey:key];
//    }
//    
//    [super setValue:value forInputKey:key];
//}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    NSUInteger iterationCount = [self.inputCount unsignedIntegerValue];
    
    for (NSUInteger i=0; i<iterationCount; i++) {
        self.currentIndex = @(i);
        
        NSString *state = [NSString stringWithFormat:@"%@_%d", self.parent.state, i];
        self.state = state;
        
//        // reset values from published input ports
//        for (NSString *key in self.capturedInputPortValues) {
//            id value = self.capturedInputPortValues[key];
//            
//            NSDictionary *publishedInput = [self.publishedInputPorts objectForKey:key];
//            if (publishedInput) {
//                // forward to node / port
//                
//                JKPatch *patch = [self patchWithKey:publishedInput[@"node"]];
//                [patch setValue:value forInputKey:publishedInput[@"port"]];
//            }
//        }
        
        [super execute:context atTime:time];
    }
}

@end