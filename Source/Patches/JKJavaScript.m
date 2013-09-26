//
//  JKJavaScript.m
//  QCDemos
//
//  Created by Joris Kluivers on 9/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKJavaScript.h"

@implementation JKJavaScript

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
    }
    
    return self;
}

- (NSString *) preprocessScript:(NSString *)script
{
    NSLog(@"Process script: %@", script);
    
    NSScanner *scanner = [NSScanner scannerWithString:script];
    
    // TODO: loop over all occurences of a function
    
    while ([scanner scanUpToString:@"function" intoString:NULL]) {
        [scanner scanString:@"function" intoString:NULL];
        
        // optional output annotation
        if ([scanner scanString:@"(" intoString:NULL]) {
            [scanner scanString:@"(" intoString:NULL];
            
            NSString *outputArguments = nil;
            [scanner scanUpToString:@")" intoString:&outputArguments];
            [scanner scanString:@")" intoString:NULL];
            
            NSLog(@"Output annotation: %@", outputArguments);
            
        }
        
        // 'main' function name + arguments
        if ([scanner scanString:@"main" intoString:NULL]) {
            // found main without output annotation
            [scanner scanString:@"(" intoString:NULL];
            
            NSString *inputArguments = nil;
            [scanner scanUpToString:@")" intoString:&inputArguments];
            
            NSLog(@"Input annotations: %@", inputArguments);
            
            break;
        }
    }
    
    return script;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    NSDictionary *result = @{ @"items": @[@{@"title": @"Test title"}] };
    
    for (NSString *key in result) {
        [self setValue:result[key] forOutputKey:key];
    }
}

@end
