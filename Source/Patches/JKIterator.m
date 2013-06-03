//
//  JKIterator.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKIterator.h"

@interface JKPatch (JKIteratorPrivate)
- (void) _setValue:(id)value forInputKey:(NSString *)key;
@end

@interface JKIterator ()
@property(nonatomic, strong) NSNumber *currentIndex;
@end

@implementation JKIterator {
    BOOL _isRenderer;
}

@dynamic inputCount;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    NSUInteger iterationCount = [self.inputCount unsignedIntegerValue];
    for (NSUInteger i=0; i<iterationCount; i++) {
        self.currentIndex = @(i);
        
        NSString *state = [NSString stringWithFormat:@"%@_%d", self.parent.state, i];
        self.state = state;
        
        [super execute:context atTime:time];
    }
}

@end