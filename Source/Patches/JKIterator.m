//
//  JKIterator.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKIterator.h"

@interface JKPatch (JKIteratorPrivate)
@property(nonatomic, strong) NSArray *nodes;
@end

@interface JKIterator ()
@property(nonatomic, strong) NSNumber *currentIndex;
@end

@implementation JKIterator {
    BOOL _isRenderer;
}

@dynamic inputCount;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        _isRenderer = NO;
        for (JKPatch *patch in self.nodes) {
            if ([patch isRenderer]) {
                _isRenderer = YES;
                break;
            }
        }
    }
    
    return self;
}

- (BOOL) isRenderer {
    // is a renderer if any of its children is a renderer
    return _isRenderer;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    for (NSUInteger i=0; i<[self.inputCount unsignedIntegerValue]; i++) {
        self.currentIndex = @(i);
        
        [super execute:context atTime:time];
    }
}

@end
