//
//  JKImage.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/3/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImage.h"

@interface JKImage ()
@property(nonatomic, strong) CIImage *CIImage;
@end

@implementation JKImage {
    GLuint _textureName;
    GLuint _textureFramebuffer;
    
    GLKTextureInfo *texture;
    
    CGSize _imageSize;
}

- (id) initWithData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        UIImage *image = [UIImage imageWithData:data];
        _imageSize = image.size;
        
        NSError *error = nil;
        
        texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
        if (!texture) {
            NSLog(@"Error creating texture from data");
        }
    }
    
    return self;
}

- (id) initWithCIImage:(CIImage *)image
{
    self = [super init];
    
    if (self) {
        _CIImage = image;
    }
    
    return self;
}

- (GLuint) textureWithContext:(id<JKContext>)context
{
    if (texture) {
        return texture.name;
    }
    
    return 0;
}

- (CGSize) size
{
    return _imageSize;
}

#pragma mark - GL texture

- (void) setupCoreImageFramebufferWithImageContext:(CIContext *)context
{
    /*
     OpenGL framebuffer for CIImage drawing
     from: https://github.com/bdudney/Experiments/blob/200d71a5c903fe20eac8a56d338cd409ccd83aab/AVCoreImageIntegration/AVCoreImageIntegration/GFSViewController.m
     */
    
    GLenum error = GL_NO_ERROR;
    GLint oldFramebuffer = 0;
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFramebuffer);
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"Error = %d", error);
    }
    
    glGenBuffers(1, &_textureFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _textureFramebuffer);
    glViewport(0, 0, 256, 256);
    
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    // create & attach texture
    
    glGenTextures(1, &_textureName);
    
    glBindTexture(GL_TEXTURE_2D, _textureName);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _textureName, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"ERROR: could not create framebuffer.");
        NSLog(@"ERROR CODE: 0x%2x", status);
    }
    
    glClearColor(1, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [context drawImage:self.CIImage inRect:CGRectMake(0, 0, 256, 256) fromRect:self.CIImage.extent];
    
    // unbind the _sourceTexture
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // now that we are setup and the new framebuffer is configured we can switch back
    glBindFramebuffer(GL_FRAMEBUFFER, oldFramebuffer);
    
    error = glGetError();
    if(error != GL_NO_ERROR) {
        NSLog(@"error = %d", error);
    }
}


@end
