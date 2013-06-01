//
//  JKLogic.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKLogic.h"

typedef NS_ENUM(NSUInteger, JKLogicOperation) {
    JKLogicAND,
    JKLogicOR,
    JKLogicXOR,
    JKLogicNOT,
    JKLogicNAND,
    JKLogicNOR,
    JKLogicNXOR
};

@interface JKLogic ()
@property(nonatomic, strong) NSNumber *outputResult;
@end

@implementation JKLogic

@dynamic inputValue1, inputValue2, inputOperation;
@dynamic outputResult;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    NSUInteger operation = [self.inputOperation unsignedIntegerValue];
    
    BOOL value1 = [self.inputValue1 boolValue];
    BOOL value2 = [self.inputValue2 boolValue];
    
    BOOL result = NO;
    
    switch (operation) {
        case JKLogicAND:
            result = value1 && value2;
            break;
        case JKLogicOR:
            result = value1 || value2;
            break;
        case JKLogicXOR:
            result = value1 != value2;
            break;
        case JKLogicNOT:
            result = !value1;
            break;
        case JKLogicNAND:
            result = !(value1 && value2);
            break;
        case JKLogicNOR:
            result = !(value1 || value2);
            break;
        case JKLogicNXOR:
            result = !(value1 != value2);
            break;
    }
    
    self.outputResult = @(result);
}

@end
