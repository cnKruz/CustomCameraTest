//
//  ViewController.m
//  CustomCameraTest
//
//  Created by Eduardo on 6/29/16.
//  Copyright © 2016 Eduardo. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>


@interface ViewController ()
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _session= [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *cptrdvc = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    
    NSError *error;
    
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:cptrdvc error:&error];
    if(error == nil && [_session canAddInput:input]){
        [_session addInput:input];
        
        //output
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [_stillImageOutput setOutputSettings:[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil]];
       
        
        if([_session canAddOutput:_stillImageOutput]){
             [_session addOutput:_stillImageOutput];
            
            //livePreview
            
            _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
            [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
            [[_videoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
            [[_previewView layer] addSublayer: _videoPreviewLayer];
            
            [_session startRunning];
            
            
        }
    
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    _videoPreviewLayer.frame= _previewView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTakePhoto:(id)sender{
    
    AVCaptureConnection *videoConnection = nil;
    for( AVCaptureConnection *connection in _stillImageOutput.connections){
        for (AVCaptureInputPort *port in [ connection inputPorts] ) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection){ break;}
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary , NULL);
        
        if (exifAttachments)
        {
            // Do something with the attachments.
            NSLog(@"attachements: %@", exifAttachments);
        }
        else
            NSLog(@"no attachments");
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        _captureImageView.image = image;
    }];
    
}

@end
