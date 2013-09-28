//
//  JKJavaScript.m
//  QCDemos
//
//  Created by Joris Kluivers on 9/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKJavaScript.h"

@import JavaScriptCore;

@interface JKJavaScript ()
@property(nonatomic, strong) JSContext *context;
@property(nonatomic, strong) NSArray *argumentNames;
@end

@implementation JKJavaScript

/*!
 * One virtual machine, assuming JKJavaScript always on the same
 * thread.
 */
+ (JSVirtualMachine *) virtualMachine
{
    static JSVirtualMachine *machine = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        machine = [[JSVirtualMachine alloc] init];
    });
    
    return machine;
}

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        NSLog(@"Dict: %@", dict);
        
        // TODO: remove type annotations from javascript main function
        
        
        NSDictionary *state = dict[@"state"];
        NSString *script = state[@"script"];
        
        // Quartz Composer supports input/output variable annotations. These cannot be
        // parsed by JavaScriptCore
        NSString *cleanScript = [self preprocessScript:script];
        NSLog(@"Clean script: %@", cleanScript);
        
        self.context = [[JSContext alloc] initWithVirtualMachine:[JKJavaScript virtualMachine]];
        [self.context evaluateScript:cleanScript];
        
        JSValue *mainFunction = self.context[@"main"];
        if ([mainFunction isUndefined]) {
            NSLog(@"Failed to evaluate script");
        }
    }
    
    return self;
}

- (NSString *) cleanInputArguments:(NSString *)inputArguments
{
    NSString *newString = inputArguments;
    NSArray *annotations = @[@"__boolean", @"__index", @"__number", @"__string", @"__image", @"__structure", @"__virtual"];
    
    for (NSString *key in annotations) {
        newString = [newString stringByReplacingOccurrencesOfString:key withString:@""];
    }
    
    return newString;
}

- (NSArray *) mainArgumentNames:(NSString *)arguments
{
    NSMutableArray *names = [NSMutableArray array];
    
    NSArray *splits = [arguments componentsSeparatedByString:@","];
    
    for (NSString *argument in splits) {
        NSString *argumentName = [argument stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // TODO: what if the argument is an array?
        
        [names addObject:argumentName];
    }
    
    return names;
}

- (NSString *) preprocessScript:(NSString *)script
{
    NSLog(@"Process script: %@", script);
    
    NSString *cleanScript = script;
    NSScanner *scanner = [NSScanner scannerWithString:script];
    
    // TODO: loop over all occurences of a function
    
    while ([scanner scanUpToString:@"function" intoString:NULL]) {
        [scanner scanString:@"function" intoString:NULL];
        
        NSRange outputAnnotationRange;
        NSRange inputAnnotationRange;
        
        // optional output annotation
        if ([scanner scanString:@"(" intoString:NULL]) {
            outputAnnotationRange.location = [scanner scanLocation] - 1;
            
            NSString *outputArguments = nil;
            [scanner scanUpToString:@")" intoString:&outputArguments];
            [scanner scanString:@")" intoString:NULL];
            
            outputAnnotationRange.length = [scanner scanLocation] - outputAnnotationRange.location;
            
            NSLog(@"Output annotation: %@", outputArguments);
            
        }
        
        // 'main' function name + arguments
        if ([scanner scanString:@"main" intoString:NULL]) {
            // found main without output annotation
            [scanner scanString:@"(" intoString:NULL];
            
            inputAnnotationRange.location = [scanner scanLocation];
            
            NSString *inputArguments = nil;
            [scanner scanUpToString:@")" intoString:&inputArguments];
            
            inputAnnotationRange.length = [scanner scanLocation] - inputAnnotationRange.location;
            
            if (inputArguments) {
                NSString *cleanInputArguments = [self cleanInputArguments:inputArguments];
                
                self.argumentNames = [self mainArgumentNames:cleanInputArguments];
                
                // remove annotations from input arguments
                cleanScript = [cleanScript stringByReplacingCharactersInRange:inputAnnotationRange withString:cleanInputArguments];
            }
            
            // replace optional output annotation with empty string
            cleanScript = [cleanScript stringByReplacingCharactersInRange:outputAnnotationRange withString:@""];
            
            break;
        }
    }
    
    return cleanScript;
}

- (NSArray *) argumentsForMain
{
    NSMutableArray *arguments = nil;
    
    if ([self.argumentNames count] > 0) {
        arguments = [NSMutableArray array];
        
        for (NSString *argumentName in self.argumentNames) {
            // TODO: see if argument is array type ([])
            
            id value = [self valueForInputKey:argumentName];
            
            if (!value) {
                [arguments addObject:[NSNull null]];
            } else {
                [arguments addObject:[self valueForInputKey:argumentName]];
            }
        }
    }
    
    return arguments;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    JSValue *main = self.context[@"main"];
    
    NSArray *arguments = [self argumentsForMain];
    
    JSValue *jsResult = [main callWithArguments:arguments];
    NSDictionary *dictionaryResult = [jsResult toDictionary];
    
    for (NSString *key in dictionaryResult) {
        [self setValue:dictionaryResult[key] forOutputKey:key];
    }
}

@end
