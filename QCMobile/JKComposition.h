//
//  JKComposition.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKComposition : NSObject

@property(readonly) NSString *frameworkVersion;
@property(readonly) NSString *compositionDescription;

- (id) initWithPath:(NSString *)path;

- (void) renderAtTime:(NSTimeInterval)timeInterval;


@end
