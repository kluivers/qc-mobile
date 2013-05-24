//
//  JKMultiplexer.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/24/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKMultiplexer.h"

@interface JKPatch (PrivateAPI)
- (id) convertValue:(id)value toType:(NSString *)type;
@end

@interface JKMultiplexer ()
@property(nonatomic, strong) id output;
@end

@implementation JKMultiplexer

@dynamic inputIndex;
@dynamic output;

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _inputCount = state[@"inputCount"];
        if (state[@"portClass"]) {
            _portClass = [state[@"portClass"] stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"JK"];
        }
    }
    
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    NSInteger index = [self.inputIndex integerValue];
    
    NSString *sourceKey = [NSString stringWithFormat:@"source_%d", index];
    
    id selectedValue = [self valueForInputKey:sourceKey];
    if (self.portClass) {
        selectedValue = [self convertValue:selectedValue toType:self.portClass];
    }
    
    self.output = selectedValue;
}

@end
