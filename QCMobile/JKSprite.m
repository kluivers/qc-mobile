//
//  JKSprite.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "JKSprite.h"

@implementation JKSprite

- (BOOL) isRenderer
{
    return YES;
}

- (void) executeAtTime:(NSTimeInterval)time
{
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 transform = GLKMatrix4MakeTranslation(self.inputX, self.inputY, self.inputZ);
    
    effect.transform.modelviewMatrix = transform;
    
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
