//
//  SoundPickerViewController.m
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SoundPickerViewController.h"

@interface SoundPickerViewController ()
- (void)start;
- (void)fire;
@end

@implementation SoundPickerViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    _Volume = -0.2f;
    _Interval = 0.3;
    [self start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self start];
}

static void AudioInputCallback(
                               void* inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inBuffer,
                               const AudioTimeStamp *inStartTime,
                               UInt32 inNumberPacketDescriptions,
                               const AudioStreamPacketDescription *inPacketDescs) {
}

- (void)start {
    AudioStreamBasicDescription dataFormat;
    dataFormat.mSampleRate = 44100.0f;
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mBytesPerPacket = 2;
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mBytesPerFrame = 2;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mReserved = 0;
    
    AudioQueueNewInput(&dataFormat,AudioInputCallback,(__bridge void *)(self),CFRunLoopGetCurrent(),kCFRunLoopCommonModes,0,&queue);
    AudioQueueStart(queue, NULL);
    
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(queue,kAudioQueueProperty_EnableLevelMetering,&enabledLevelMeter,sizeof(UInt32));
    
    [NSTimer scheduledTimerWithTimeInterval:_Interval
                                    target:self
                                    selector:@selector(updateVolume:)
                                    userInfo:nil
                                    repeats:YES];
}

- (void)updateVolume:(NSTimer *)timer {
    AudioQueueLevelMeterState levelMeter;
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue,kAudioQueueProperty_CurrentLevelMeterDB,&levelMeter,&levelMeterSize);
    
    NSLog(@"mPeakPower=%0.9f", levelMeter.mPeakPower);
    NSLog(@"mAveragePower=%0.9f", levelMeter.mAveragePower);
    
    if (levelMeter.mPeakPower >= _Volume) {
        [self fire];
    }
}

- (void)fire {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I can hear you..."
                                                    message:@"Recording!!"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"Recording!");

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
