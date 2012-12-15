//
//  SoundPickerViewController.m
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SoundPicker.h"

@interface SoundPicker (){
    NSOperationQueue *opQueue;
}
- (void)start;
- (void)fire;
//@property (retain,nonatomic) NSThread* thread;
@end

@implementation SoundPicker

-(void) awake{
    NSLog(@"MIC awake!");
    _Volume = -0.2f;
    _Interval = 0.3;
    
    [self start];

}

-(BOOL)canBeThread{
    return YES;
}

-(void) main{
    opQueue = [[NSOperationQueue alloc]init];
    [opQueue addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(awake) object:nil]];
    
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
    
    while(1){
        [self updateVolume];
        [NSThread sleepForTimeInterval:0.5];
    }
}

- (void)updateVolume {
    AudioQueueLevelMeterState levelMeter;
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue,kAudioQueueProperty_CurrentLevelMeterDB,&levelMeter,&levelMeterSize);
    
    //NSLog(@"mPeakPower=%0.9f", levelMeter.mPeakPower);
    //NSLog(@"mAveragePower=%0.9f", levelMeter.mAveragePower);
    
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
    
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"Recording!");

}

-(void) stop{
    
}


@end
