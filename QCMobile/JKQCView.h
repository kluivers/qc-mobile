//
//  JKQCView.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "JKContext.h"

@class JKComposition;

@interface JKQCView : GLKView <JKContext>

@property(nonatomic, strong) JKComposition *composition;

@property(nonatomic, readonly) CGFloat frameRate;

- (void) startAnimation;
- (void) stopAnimation;
- (BOOL) isAnimating;

- (void) setValue:(id)value forInputKey:(NSString *)key;

@end
