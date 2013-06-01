//
//  JKExpression.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKExpression.h"

#import "DDExpression.h"

@interface JKExpression ()

@property(nonatomic, readonly) DDExpression *mathExpression;
@property(nonatomic, readonly) NSArray *variables;

@property(nonatomic, strong) NSNumber *outputResult;

@end

@implementation JKExpression

@dynamic outputResult;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    if (self) {
        NSDictionary *state = dict[@"state"];
        _expression = state[@"expression"];
        NSLog(@"Original expression: %@", _expression);
        
        // TODO: support variables that start with numbers
        [self parseExpression];
    }
    return self;
}

- (void) parseExpression
{
    NSString *exp = self.expression;
    
    NSMutableCharacterSet *variableCharacters = [NSMutableCharacterSet letterCharacterSet];
    [variableCharacters addCharactersInString:@"_"];
    
    NSMutableArray *variables = [NSMutableArray array];
    NSMutableString *internalExpression = [NSMutableString string];
    NSMutableString *currentVariable = [NSMutableString string];
    
    BOOL inVariable = NO;
    for (NSUInteger i=0; i<[exp length]; i++) {
        char c = [exp characterAtIndex:i];
        NSString *characterString = [NSString stringWithFormat:@"%c", c];
        
        if ([variableCharacters characterIsMember:c]) {
            if (!inVariable) {
                [internalExpression appendString:@"$"];
                inVariable = YES;
            }
            
            [currentVariable appendString:characterString];
        } else {
            if (inVariable) {
                [variables addObject:[NSString stringWithString:currentVariable]];
                [currentVariable deleteCharactersInRange:NSMakeRange(0, [currentVariable length])];
            }
            inVariable = NO;
        }
        
        [internalExpression appendString:characterString];
    }
    
    if (inVariable) {
        // cleanup last variable
        [variables addObject:[NSString stringWithString:currentVariable]];
    }
    
    _variables = [NSArray arrayWithArray:variables];
    
    NSError *parseError = nil;
    _mathExpression = [DDExpression expressionFromString:internalExpression error:&parseError];
    
    NSLog(@"Math expression %@", _mathExpression);
    
    if (!_mathExpression) {
        NSLog(@"Error parsing expression: %@ (as %@)", _expression, internalExpression);
        return;
    }
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self didValuesForInputKeysChange]) {
        return;
    }
    
    NSMutableDictionary *substitutions = [NSMutableDictionary dictionary];
    
    for (NSString *variable in self.variables) {
        NSNumber *value = [self valueForInputKey:variable];
        if (!value) {
            value = @0;
        }
        [substitutions setObject:value forKey:variable];
    }
    
    NSError *evalError = nil;
    self.outputResult = [self.mathExpression evaluateWithSubstitutions:substitutions evaluator:nil error:&evalError];
    
    if (!self.outputResult) {
        NSLog(@"Evaluation error: %@", evalError);
    }
}

@end
