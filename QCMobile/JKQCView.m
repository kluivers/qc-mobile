//
//  JKQCView.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKQCView.h"
#import "JKComposition.h"


@implementation JKQCView {
    GLKBaseEffect *_baseEffect;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _baseEffect = [[GLKBaseEffect alloc] init];
        
        // TODO: update on resize
        
        
        //GLKMatrix4 modelview = GLKMatrix4MakeTranslation(0, 0, -10.0f);
        // _baseEffect.transform.modelviewMatrix = modelview;
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [_baseEffect prepareToDraw];
    
    [self.composition render];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // TODO: figure out correct translation
    GLKMatrix4 lookAt = GLKMatrix4MakeLookAt(0, 0, -1.9, 0, 0, 0, 0, 1, 0);
    _baseEffect.transform.modelviewMatrix = lookAt;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat ratio = width / height;
    
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), ratio, .01f, 100.0f);
    _baseEffect.transform.projectionMatrix = projection;
    
    [self setNeedsDisplay];
}

@end
