//
//  JKComposition.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKContext;
@class JKPatch;

@interface JKComposition : NSObject

@property(readonly) NSString *frameworkVersion;
@property(readonly) NSString *compositionDescription;
@property(nonatomic, readonly) JKPatch *rootPatch;

- (id) initWithPath:(NSString *)path;

- (void) renderInContext:(id<JKContext>)context atTime:(NSTimeInterval)timeInterval;


@end
