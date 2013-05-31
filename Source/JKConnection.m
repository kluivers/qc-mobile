//
//  JKConnection.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKConnection.h"

@implementation JKConnection

- (id) initWithKey:(NSString *)key ports:(NSDictionary *)ports
{
    self = [super init];
    if (self) {
        _key = key;
        
        _destinationNode = ports[@"destinationNode"];
        _destinationPort = ports[@"destinationPort"];
        _sourceNode = ports[@"sourceNode"];
        _sourcePort = ports[@"sourcePort"];
    }
    return self;
}

+ (id) connectionWithKey:(NSString *)key ports:(NSDictionary *)ports
{
    return [[self alloc] initWithKey:key ports:ports];
}

@end
