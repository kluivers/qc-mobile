//
//  JKUnimplementedPatch.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKUnimplementedPatch.h"

@implementation JKUnimplementedPatch

- (id) initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        NSLog(@"UNIMPLEMENTED PATCH: %@", name);
    }
    
    return self;
}

@end
