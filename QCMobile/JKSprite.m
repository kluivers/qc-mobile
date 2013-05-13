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

@implementation JKSprite {
    BOOL _didSetup;
    GLuint _textureFramebuffer;
    GLuint _sourceTexture;
    NSUInteger _antialiasing;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
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
    
    [EAGLContext setCurrentContext:context.glContext];
    [self setupCoreImageFramebuffer];
    
    _didSetup = YES;
}

- (void) execute:(id<JKContext>)qcContext atTime:(NSTimeInterval)time
{
    if (![self._enable boolValue]) {
        return;
    }
    
//    GLKBaseEffect *effect = qcContext.effect;
    // TODO: reusing the same effect messes up the color on vertices
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(self.inputX, self.inputY, self.inputZ);
    
    GLKMatrix4 rotateX = GLKMatrix4MakeXRotation(GLKMathDegreesToRadians(self.inputRX));
    GLKMatrix4 rotateY = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians(self.inputRY));
    GLKMatrix4 rotateZ = GLKMatrix4MakeZRotation(GLKMathDegreesToRadians(self.inputRZ));
    
    GLKMatrix4 rotation = GLKMatrix4Multiply(GLKMatrix4Multiply(rotateX, rotateY), rotateZ);
    
    CGFloat ratio = qcContext.size.width / qcContext.size.height;
    GLKMatrix4 scale = GLKMatrix4MakeScale(1.0, ratio, 1.0);
    
    GLKMatrix4 transform = GLKMatrix4Multiply(GLKMatrix4Multiply(translate, scale), rotation);
    
    effect.transform.modelviewMatrix = transform;
    // effect.transform.projectionMatrix = qcContext.projectionMatrix;
    
    if (self.inputImage && [self didValueForInputKeyChange:@"inputImage"]) {
        // only redraws image when image actually changed
        
        GLint oldFramebuffer = 0;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _textureFramebuffer);
        
        [qcContext.ciContext drawImage:self.inputImage inRect:CGRectMake(0, 0, 256, 256) fromRect:self.inputImage.extent];
        
        glBindFramebuffer(GL_FRAMEBUFFER, oldFramebuffer);
        
        GLenum error = glGetError();
        if (error != GL_NO_ERROR) {
            NSLog(@"error = %d", error);
        }
    }
    
    if (self.inputImage) {
        effect.texture2d0.envMode = GLKTextureEnvModeModulate;
        effect.texture2d0.target = GLKTextureTarget2D;
        effect.texture2d0.name = _sourceTexture;
    }
    
    //effect.useConstantColor = YES;
    //effect.constantColor = GLKVector4Make(0.0, self.inputColor.green, self.inputColor.blue, self.inputColor.alpha);
    
    [effect prepareToDraw];
    
    UIColor *whiteColor = [UIColor whiteColor];
    CGFloat r, g, b, a;
    [whiteColor getRed:&r green:&g blue:&b alpha:&a];
    
    GLKVector4 color = GLKVector4Make(self.inputColor.red, self.inputColor.green, self.inputColor.blue, self.inputColor.alpha);
    GLKVector4 colors[4] = {
        color, color, color, color
    };
    
    GLfloat vertices[12] = {
        -self.inputWidth/2, -self.inputHeight/2, 0,
        self.inputWidth/2, -self.inputHeight/2, 0,
        -self.inputWidth/2, self.inputHeight/2, 0,
        self.inputWidth/2, self.inputHeight/2, 0
    };
    
    if (self.inputImage) {
        GLKVector2 textureCoords[4] = {
            GLKVector2Make(0, 0),
            GLKVector2Make(1.0, 0),
            GLKVector2Make(0, 1.0),
            GLKVector2Make(1.0, 1.0)
        };
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureCoords);
    }
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisable(GL_BLEND);
    
    if (self.inputImage) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (void) setupCoreImageFramebuffer
{
    /*
        OpenGL framebuffer for CIImage drawing
        from: https://github.com/bdudney/Experiments/blob/200d71a5c903fe20eac8a56d338cd409ccd83aab/AVCoreImageIntegration/AVCoreImageIntegration/GFSViewController.m
    */
    
    NSLog(@"%s", __func__);
    
    GLenum error = GL_NO_ERROR;
    GLint oldFramebuffer = 0;
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFramebuffer);
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"Error = %d", error);
    }
    
    glGenBuffers(1, &_textureFramebuffer);
    NSLog(@"Generated buffer: %d", _textureFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _textureFramebuffer);
    glViewport(0, 0, 512, 512);
    
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    // create & attach texture
    
    glGenTextures(1, &_sourceTexture);
    NSLog(@"Generated texture: %d", _sourceTexture);
    
    glBindTexture(GL_TEXTURE_2D, _sourceTexture);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
  
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _sourceTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"ERROR: could not create framebuffer.");
        NSLog(@"ERROR CODE: 0x%2x", status);
    }
    
    // clear to pink (testing)
//    glClearColor(1.0, 0.0, 1.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
    
    // unbind the _sourceTexture
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // now that we are setup and the new framebuffer is configured we can switch back
    glBindFramebuffer(GL_FRAMEBUFFER, oldFramebuffer);
    
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    // bind _sourceTexture to texture 1
    //glActiveTexture(GL_TEXTURE1);
    //glBindTexture(GL_TEXTURE_2D, _sourceTexture);
}

@end
