//
//  NSString+LowercaseFirst.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "NSString+LowercaseFirst.h"

@implementation NSString (LowercaseFirst)

- (NSString *) lowercaseFirstString
{
    if ([self length] < 1) {
        return self;
    }
    
    NSString *lowercaseFirstChar = [[self substringWithRange:NSMakeRange(0, 1)] lowercaseString];
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
}

@end
