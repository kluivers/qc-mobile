//
//  JKSprite.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <CoreImage/CoreImage.h>

#import "JKContext.h"
#import "JKSprite.h"
#import "JKImage.h"

@implementation JKSprite {
    BOOL _didSetup;
//    GLuint _textureFramebuffer;
//    GLuint _sourceTexture;
    NSUInteger _antialiasing;
}

@dynamic inputColor, inputHeight, inputWidth;
@dynamic inputY, inputX, inputZ;
@dynamic inputRX, inputRY, inputRZ;
@dynamic inputCulling, inputBlending, inputZBuffer;
@dynamic inputImage;

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *)key
{
    if ([key hasPrefix:@"inputColor"]) {
        return @{ JKPortAttributeTypeKey: JKPortTypeColor };
    }
    
    return nil;
}

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _antialiasing = [state[@"antialiasing"] unsignedIntegerValue];
        _didSetup = NO;
    }
    return self;
}

- (BOOL) isRenderer
{
    return YES;
}

- (void) startExecuting:(id<JKContext>)context
{
    [super startExecuting:context];
    
    if (_didSetup) {
        return;
    }
    
    //[EAGLContext setCurrentContext:context.glContext];
    //[self setupCoreImageFramebuffer];
    
    _didSetup = YES;
}

- (void) execute:(id<JKContext>)qcContext atTime:(NSTimeInterval)time
{
    if (![self._enable boolValue]) {
        return;
    }
    
    GLKBaseEffect *effect = qcContext.effect;
    effect.transform.projectionMatrix = qcContext.projectionMatrix;
    
    GLKMatrix4 translate = GLKMatrix4MakeTranslation([self.inputX floatValue], [self.inputY floatValue], [self.inputZ floatValue]);
    
    GLKMatrix4 rotateX = GLKMatrix4MakeXRotation(GLKMathDegreesToRadians([self.inputRX floatValue]));
    GLKMatrix4 rotateY = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians([self.inputRY floatValue]));
    GLKMatrix4 rotateZ = GLKMatrix4MakeZRotation(GLKMathDegreesToRadians([self.inputRZ floatValue]));
    
    GLKMatrix4 rotation = GLKMatrix4Multiply(GLKMatrix4Multiply(rotateX, rotateY), rotateZ);
    
    GLKMatrix4 scale = GLKMatrix4MakeScale(1.0, 1.0f, 1.0);
    
    GLKMatrix4 transform = GLKMatrix4Multiply(GLKMatrix4Multiply(translate, scale), rotation);
    
    effect.transform.modelviewMatrix = GLKMatrix4Multiply([self transform], transform);
    
    if (self.inputImage) {
        effect.texture2d0.enabled = GL_TRUE;
        effect.texture2d0.envMode = GLKTextureEnvModeModulate;
        effect.texture2d0.target = GLKTextureTarget2D;
        effect.texture2d0.name = [self.inputImage textureName];
    } else {
        effect.texture2d0.enabled = GL_FALSE;
    }

    [effect prepareToDraw];
    
    GLKVector4 color = GLKVector4Make(self.inputColor.red, self.inputColor.green, self.inputColor.blue, self.inputColor.alpha);
    GLKVector4 colors[4] = {
        color, color, color, color
    };
    
    GLfloat vertices[12] = {
        -[self.inputWidth floatValue]/2, -[self.inputHeight floatValue]/2, 0,
        [self.inputWidth floatValue]/2, -[self.inputHeight floatValue]/2, 0,
        -[self.inputWidth floatValue]/2, [self.inputHeight floatValue]/2, 0,
        [self.inputWidth floatValue]/2, [self.inputHeight floatValue]/2, 0
    };
    
    if (self.inputImage) {
        GLKVector2 textureCoords[4] = {
            // reversed for UIImage data
            GLKVector2Make(0, 1),
            GLKVector2Make(1, 1),
            GLKVector2Make(0, 0),
            GLKVector2Make(1, 0)
            
//            GLKVector2Make(0, 0),
//            GLKVector2Make(1.0, 0),
//            GLKVector2Make(0, 1.0),
//            GLKVector2Make(1.0, 1.0)
        };
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureCoords);
    }
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
    
//    glDisable(GL_ALPHA_TEST);
    
    //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisable(GL_BLEND);
    
    if (self.inputImage) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

@end
