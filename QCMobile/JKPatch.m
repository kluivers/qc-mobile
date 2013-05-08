//
//  JKPatch.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"
#import "JKUnimplementedPatch.h"

@interface NSUnarchiver : NSCoder
+(id)unarchiveObjectWithData:(id)data;
@end

@interface JKPatch ()
@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSDictionary *userInfo;
@end

@implementation JKPatch

- (id) initWithState:(NSDictionary *)state
{
    self = [super init];
    
    if (self) {
        NSLog(@"Patch: %@", state);
        
        NSData *userInfoData = state[@"userInfo"];
        if (userInfoData) {
            // TODO: Stop using private API
#pragma message "This uses undocumented private API"
            _userInfo = [NSUnarchiver unarchiveObjectWithData:userInfoData];
            NSLog(@"Unarchived userInfo: %@", _userInfo);
        }
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (NSDictionary *node in state[@"nodes"]) {
            [nodes addObject:[JKPatch patchWithDictionary:node]];
        }
        _nodes = [NSArray arrayWithArray:nodes];
    }
    
    return self;
}

+ (instancetype) patchWithDictionary:(NSDictionary *)dict
{
    NSString *patchClassName = [dict[@"class"] stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"JK"];
    
    Class patchClass = NSClassFromString(patchClassName);
    if (!patchClass) {
        return [[JKUnimplementedPatch alloc] initWithName:patchClassName];
    }
    
    return [[patchClass alloc] initWithState:dict[@"state"]];
}

- (BOOL) isRenderer
{
    return NO;
}

- (void) render
{
    if ([self.nodes count] < 1) {
        return;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRenderer = %@", @YES];

    // render each rendering patch in order found in document
    NSArray *renderers = [self.nodes filteredArrayUsingPredicate:predicate];
    for (JKPatch *patch in renderers) {
        NSLog(@"Render: %@", patch);
    }
}

@end
