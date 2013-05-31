//
//  JKConnection.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKConnection : NSObject

@property(nonatomic, readonly) NSString *key;
@property(nonatomic, readonly) NSString *destinationNode;
@property(nonatomic, readonly) NSString *destinationPort;
@property(nonatomic, readonly) NSString *sourceNode;
@property(nonatomic, readonly) NSString *sourcePort;

- (id) initWithKey:(NSString *)key ports:(NSDictionary *)ports;
+ (id) connectionWithKey:(NSString *)key ports:(NSDictionary *)ports;

@end
