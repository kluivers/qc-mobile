//
//  JKStructureMember.m
//  QCDemos
//
//  Created by Joris Kluivers on 9/26/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKStructureMember.h"

@interface JKStructureMember ()
@property(nonatomic, strong) NSObject *outputMember;
@end

@implementation JKStructureMember

@dynamic inputStructure;
@dynamic outputMember;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if ([self.identifier isEqualToString:@"key"]) {
        self.outputMember = [(NSDictionary *)self.inputStructure objectForKey:[self valueForInputKey:@"inputKey"]];
    } else if ([self.identifier isEqualToString:@"index"]) {
        self.outputMember = [(NSArray *)self.inputStructure objectAtIndex:[[self valueForInputKey:@"inputIndex"] integerValue]];
    }
}

@end
