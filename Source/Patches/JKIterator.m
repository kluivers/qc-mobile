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
@property(nonatomic, strong) JKPatch *parent;
@end

@interface JKIterator ()
@property(nonatomic, strong) NSNumber *currentIndex;
@end

@implementation JKIterator {
    JKPatch *template;
    NSMutableArray *iterations;
    
    NSDictionary *_patchDescription;
    JKComposition *_composition;
}

@dynamic inputCount;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    // TODO: basically not needed to have super parse all nodes
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        _patchDescription = dict;
        _composition = composition;
        
        template = [[JKPatch alloc] initWithDictionary:_patchDescription composition:_composition];
        template.parent = self;
        
        iterations = [NSMutableArray array];
    }
    
    return self;
}

- (BOOL) isRenderer {
    // is a renderer if any of its children is a renderer
    return [template isRenderer];
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if ([self didValueForInputKeyChange:@"inputCount"] || [iterations count] < 1) {
        [iterations removeAllObjects];
        
        [iterations addObject:template];
        for (NSUInteger i=1; i<[self.inputCount unsignedIntegerValue]; i++) {
            JKPatch *p = [[JKPatch alloc] initWithDictionary:_patchDescription composition:_composition];
            p.parent = self;
            [iterations addObject:p];
        }
    }
    
    for (NSUInteger i=0; i<[self.inputCount unsignedIntegerValue]; i++) {
        self.currentIndex = @(i);
        
        [iterations[i] execute:context atTime:time];
    }
}

- (void) setValue:(id)value forInputKey:(NSString *)key
{
    [super setValue:value forInputKey:key];
    
    for (JKPatch *patch in iterations) {
        [patch setValue:value forInputKey:key];
    }
}

@end
