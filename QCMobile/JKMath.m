//
//  JKMath.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKMath.h"

@implementation JKMath

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _numberOfOperations = [state[@"numberOfOperations"] integerValue];
    }
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    CGFloat total = self.inputValue;
    
    for (int i=1; i<=self.numberOfOperations; i++) {
        NSString *operandPortName = [NSString stringWithFormat:@"operand_%d", i];
        NSString *operationPortName = [NSString stringWithFormat:@"operation_%d", i];
        
        // TODO: make handling of customInputPortStates nicer
        NSInteger operation = [[self.customInputPorts objectForKey:operationPortName][@"value"] integerValue];
        CGFloat operand = [[self.customInputPorts objectForKey:operandPortName][@"value"] floatValue];
        
        switch (operation) {
            case 0:
                total += operand;
                break;
            case 1:
                total -= operand;
                break;
            case 2:
                total *= operand;
                break;
            case 3:
                total /= operand;
                break;
            case 4:
                total = fmodf(total, operand);
                break;
            case 5:
                total = pow(total, operand);
                break;
            case 6:
                total = fminf(total, operand);
                break;
            case 7:
                total = fmaxf(total, operand);
                break;
        }
    }
    
    _outputValue = total;
}

@end
