//
//  JKIteratorVariables.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKIteratorVariables.h"

#import "JKIterator.h"

@interface JKIteratorVariables ()
@property(nonatomic, strong) NSNumber *outputIndex;
@property(nonatomic, strong) NSNumber *outputPosition;
@property(nonatomic, strong) NSNumber *outputCount;
@end

@implementation JKIteratorVariables

@dynamic outputIndex;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self.parent isKindOfClass:[JKIterator class]]) {
        // set default values
        self.outputIndex = @0;
        
        return;
        
        // TODO: only do this once, parent is not going to change
    }
    
    JKIterator *parent = (JKIterator *) self.parent;
    
    self.outputIndex = parent.currentIndex;
    self.outputCount = parent.inputCount;
    
    NSUInteger i = [parent.currentIndex unsignedIntegerValue];
    NSUInteger c = [parent.inputCount unsignedIntegerValue];
    
    self.outputPosition = @((1.f / c) * i);
}

@end
