//
//  JKVideoInput.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "JKVideoInput.h"

@interface JKVideoInput () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property(nonatomic, strong) CIImage *outputImage;

@property(nonatomic, strong) CIImage *latestFrame;
@end

@implementation JKVideoInput {
    dispatch_queue_t videoQueue;
    
    AVCaptureSession *session;
}

@dynamic inputCapture, outputImage;

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        videoQueue = dispatch_queue_create("nl.kluivers.joris.VideoQueue", 0);
        
        session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetMedium;
        
        AVCaptureDevice *device = [AVCaptureDevice
                                   defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [session addInput:input];
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:videoQueue];
        
        output.videoSettings = @{
            (id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
        };
        
        [session addOutput:output];
    }
    return self;
}

- (void) startExecuting:(id<JKContext>)context
{
    [session startRunning];
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    __block CIImage *videoImage = nil;
    dispatch_sync(videoQueue, ^{
        videoImage = self.latestFrame;
    });
    self.outputImage = videoImage;
}

#pragma mark - Video handling

- (CGAffineTransform) transformForCurrentInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGAffineTransformMakeRotation(-M_PI_2);
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *frame = [CIImage imageWithCVPixelBuffer:imageBuffer];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    self.latestFrame = [frame imageByApplyingTransform:[self transformForCurrentInterfaceOrientation:orientation]];
}

@end
