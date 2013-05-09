//
//  JKQCView.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class JKComposition;

@interface JKQCView : GLKView

@property(nonatomic, strong) JKComposition *composition;

- (void) startAnimation;
- (void) stopAnimation;
- (BOOL) isAnimating;

@end
