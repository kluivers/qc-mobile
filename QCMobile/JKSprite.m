//
//  JKSprite.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "JKContext.h"
#import "JKSprite.h"

@implementation JKSprite

- (BOOL) isRenderer
{
    return YES;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 transform = GLKMatrix4MakeTranslation(self.inputX, self.inputY, self.inputZ);
    
    GLKMatrix4 rotateX = GLKMatrix4MakeXRotation(GLKMathDegreesToRadians(self.inputRX));
    GLKMatrix4 rotateY = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians(self.inputRY));
    GLKMatrix4 rotateZ = GLKMatrix4MakeZRotation(GLKMathDegreesToRadians(self.inputRZ));
    
    GLKMatrix4 rotation = GLKMatrix4Multiply(GLKMatrix4Multiply(rotateX, rotateY), rotateZ);
    
    CGFloat ratio = context.size.width / context.size.height;
    GLKMatrix4 scale = GLKMatrix4MakeScale(1.0, ratio, 1.0);
    
    effect.transform.modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4Multiply(transform, scale), rotation);
    
    [effect prepareToDraw];
    
    
    GLfloat vertices[12] = {
        -0.5, -0.5, 0,
        0.5, -0.5, 0,
        -0.5, 0.5, 0,
        0.5, 0.5, 0
    };
    
    GLfloat colors[16];
    
    GLfloat red, green, blue, alpha;
    [self.inputColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    for (int i=0; i<4; i++) {
        int n = i*4;
        colors[n+0] = red;
        colors[n+1] = green;
        colors[n+2] = blue;
        colors[n+3] = alpha;
    }
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_TRUE, 0, colors);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

@end
