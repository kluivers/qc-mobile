//
//  JKCamera.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/2/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKCamera.h"
#import "JKContext.h"

@implementation JKCamera {
    GLKMatrix4 _transform;
}

@dynamic inputOriginX, inputOriginY, inputOriginZ;
@dynamic inputRotateX, inputRotateY, inputRotateZ;
@dynamic inputTranslateX, inputTranslateY, inputTranslateZ;
@dynamic inputScaleX, inputScaleY, inputScaleZ;

- (BOOL) isRenderer
{
    return YES;
}

- (GLKMatrix4) transform
{
    return _transform;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (![self._enable boolValue]) {
        return;
    }
    
    GLKMatrix4 translate = GLKMatrix4MakeTranslation([self.inputTranslateX floatValue], [self.inputTranslateY floatValue], [self.inputTranslateZ floatValue]);
    
    GLKMatrix4 transform = translate;
    _transform = GLKMatrix4Multiply([self.parent transform], transform);
    
    [super execute:context atTime:time];
}

@end
