//
//  JKComposition.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKComposition.h"

#import "JKContext.h"
#import "JKPatch.h"

@interface JKComposition ()
@property(nonatomic, strong) NSString *path;
@property(nonatomic, assign) NSString *frameworkVersion;
@property(nonatomic, strong) JKPatch *rootPatch;
@end

@implementation JKComposition

- (id) initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        _path = path;
        
        NSData *pData = [NSData dataWithContentsOfFile:path];
        
        
        NSError *readError = nil;
        NSPropertyListFormat format = 0;
        NSDictionary *composition = [NSPropertyListSerialization propertyListWithData:pData options:NSPropertyListImmutable format:&format error:&readError];
        
        if (!composition) {
            NSLog(@"Error reading composition");
            NSLog(@"%@", readError);
        }
        
        NSLog(@"Compostion: %@", composition);
        
        _frameworkVersion = composition[@"frameworkVersion"];
        _compositionDescription = composition[@"description"];
        
        _rootPatch = [JKPatch patchWithDictionary:composition[@"rootPatch"]];
    }
    
    return self;
}

- (void) renderInContext:(id<JKContext>)context atTime:(NSTimeInterval)timeInterval
{
    [self.rootPatch execute:context atTime:timeInterval];
}

@end
