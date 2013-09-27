//
//  JKImageCoreProvider.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/23/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageCoreProvider.h"

@implementation JKImageCoreProvider {
    CIImage *_image;
    CIContext *_context;
    
    GLuint _textureName;
    GLuint _textureFramebuffer;
}

- (id) initWithCIImage:(CIImage *)image context:(CIContext *)context
{
    self = [super init];
    
    if (self) {
        _image = image;
        _context = context;
    }
    
    return self;
}

- (CIImage *) ciImage
{
    return _image;
}

- (void) setupCoreImageFramebuffer {
    /*
     OpenGL framebuffer for CIImage drawing
     from: https://github.com/bdudney/Experiments/blob/200d71a5c903fe20eac8a56d338cd409ccd83aab/AVCoreImageIntegration/AVCoreImageIntegration/GFSViewController.m
     */
    
    GLenum error = GL_NO_ERROR;
    GLint oldFramebuffer = 0;
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFramebuffer);
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    glGenBuffers(1, &_textureFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _textureFramebuffer);
    glViewport(0, 0, 256, 256);
    
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    // create and attach the texture
    glGenTextures(1, &_textureName);
    glBindTexture(GL_TEXTURE_2D, _textureName);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _textureName, 0);
    
    // check framebuffer status
	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
	if (status != GL_FRAMEBUFFER_COMPLETE) {
		printf("ERROR: Could not create framebuffer.\n");
		printf("ERROR CODE: 0x%2x\n", status);
	}
    
    // now that the framebuffer is complet clear it to pink
    glClearColor(1.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // unbind the _sourceTexture
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // now that we are setup and the new framebuffer is configured we can switch back
    glBindFramebuffer(GL_FRAMEBUFFER, oldFramebuffer);
    
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    // bind _sourceTexgture to texture 1
    //glActiveTexture(GL_TEXTURE1);
    //glBindTexture(GL_TEXTURE_2D, _textureName);
}

- (GLuint) textureName
{
    if (_textureName > 0) {
        return _textureName;
    }
    
    [self setupCoreImageFramebuffer];
    
    NSLog(@"Image size: %@", NSStringFromCGRect(_image.extent));
    
    /*
     OpenGL framebuffer for CIImage drawing
     from: https://github.com/bdudney/Experiments/blob/200d71a5c903fe20eac8a56d338cd409ccd83aab/AVCoreImageIntegration/AVCoreImageIntegration/GFSViewController.m
     */
    
    GLint oldFramebuffer = 0;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFramebuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _textureFramebuffer);
    
    [_context drawImage:_image inRect:CGRectMake(0, 0, 256, 256) fromRect:_image.extent];
    
    glBindFramebuffer(GL_FRAMEBUFFER, oldFramebuffer);
    
    GLenum error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    return _textureName;
}

- (CGSize) size
{
    return _image.extent.size;
}

@end
