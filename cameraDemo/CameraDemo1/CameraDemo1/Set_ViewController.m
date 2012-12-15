//
//  Set_ViewController.m
//  CameraDemo1
//
//  Created by Set on 2012/12/12.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_ViewController.h"

@interface Set_ViewController ()

@end

@implementation Set_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // カメラデバイスの初期化
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVAssetExportPresetMediumQuality];
    
    // 入力の初期化
    NSError *error = nil;
    AVCaptureInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice
                                                                         error:&error];
    
    //if (!captureInput) {
    //    NSLog(@"ERROR:%@", error);
    //    return;
    //}
    
    // セッション初期化
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:captureInput];
    [captureSession beginConfiguration];
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    [captureSession commitConfiguration];
    
    // プレビュー表示
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.automaticallyAdjustsMirroring = NO;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
    [self.presentedViewController.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 出力の初期化
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    [captureSession addOutput:self.imageOutput];
    
    // セッション開始
    [captureSession startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
