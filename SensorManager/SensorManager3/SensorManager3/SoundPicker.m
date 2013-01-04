//
//  SoundPickerViewController.m
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SoundPicker.h"

#import <mach/mach_time.h>

@implementation SoundPicker

@synthesize queue,currentPacket,audioFile,isRecording,back,passedPeakPower;

-(void) awake{
    NSLog(@"MIC awake!");
    _Volume_delta = 20.0f;
    _Interval = 0.5;
    [self initAudioQueue];
    [self start];
}

-(BOOL)canBeThread{
    return [super canBeThread];
}

-(void) main{
    [super main];

}

-(void) initAudioQueue{
    isRecording = NO;
    dataFormat.mSampleRate = 44100.0f;
    dataFormat.mFormatID = kAudioFormatLinearPCM;//kAudioFormatMPEG4AAC_HE
    dataFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian|kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mBytesPerPacket = 2;
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mBytesPerFrame = 2 ;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBitsPerChannel = 16;
    
    dataFormat.mReserved = 0;
    
    AudioQueueNewInput(&dataFormat,AudioInputCallback,(__bridge void *)(self),NULL,kCFRunLoopCommonModes,0,&queue);
    
    UInt64 theTime = mach_absolute_time();
    Float64 sFreq = 0;
    UInt32 sToNanosNumerator = 0;
    UInt32 sToNanosDenominator = 0;
    passedPeakPower = 0;
    
    struct mach_timebase_info theTimeBaseInfo;
    mach_timebase_info(&theTimeBaseInfo);
    
    sToNanosNumerator = theTimeBaseInfo.numer;
    sToNanosDenominator = theTimeBaseInfo.denom;
    
    sFreq = (Float64)(sToNanosDenominator)/(Float64)sToNanosNumerator;
    sFreq *= 1000000000.0;
    
    [self resetAudioTimeStamp:back];
    UInt8 theSecondsInThePassed = REWIND_TIME_IN_MSECONDS;
    
    UInt64 startHostTime = theTime - (theSecondsInThePassed * sFreq);
    back.mFlags = kAudioTimeStampHostTimeValid;
    back.mHostTime = startHostTime;
    
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(queue,kAudioQueueProperty_EnableLevelMetering,
                          &enabledLevelMeter,sizeof(UInt32));
}

-(void)resetAudioTimeStamp:(AudioTimeStamp)ts{
    ts.mFlags = 0;
    ts.mHostTime = 0;
    ts.mRateScalar = 0;
    ts.mReserved = 0;
    ts.mSampleTime = 0;
    
    ts.mSMPTETime.mCounter = 0;
    ts.mSMPTETime.mFlags = 0;
    ts.mSMPTETime.mFrames = 0;
    ts.mSMPTETime.mHours = 0;
    ts.mSMPTETime.mMinutes = 0;
    ts.mSMPTETime.mSeconds = 0;
    ts.mSMPTETime.mSubframeDivisor = 0;
    ts.mSMPTETime.mSubframes = 0;
    
    ts.mWordClockTime = 0;
}
- (void)start {
    
    AudioQueueStart(queue, &back);
    //[self startRecording];
    
    while(1){
        [self updateVolume];
        [NSThread sleepForTimeInterval:_Interval];
    }
    
}

/*
-(void) _startTimeQueue:(UInt8)passedTime:(AudioQueueRef)audioQRef{
    UInt64 theTime = mach_absolute_time();
    Float64 sFreq = 0;
    UInt32 sToNanosNumerator = 0;
    UInt32 sToNanosDenominator = 0;
    
    struct mach_timebase_info theTimeBaseInfo;
    mach_timebase_info(&theTimeBaseInfo);
    
    sToNanosNumerator = theTimeBaseInfo.numer;
    sToNanosDenominator = theTimeBaseInfo.denom;
    
    sFreq = (Float64)(sToNanosDenominator)/(Float64)sToNanosNumerator;
    sFreq *= 1000000000.0;
    
    AudioTimeStamp passedTimeStamp = {0};
    UInt8 theSecondsInThePassed = passedTime;
    
    UInt64 startHostTime = theTime - (theSecondsInThePassed * sFreq);
    passedTimeStamp.mFlags = kAudioTimeStampHostTimeValid;
    passedTimeStamp.mHostTime = startHostTime;
    AudioQueueStart(audioQRef, &passedTimeStamp);
}
*/

- (void)updateVolume {
    AudioQueueLevelMeterState levelMeter;
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue,kAudioQueueProperty_CurrentLevelMeterDB,&levelMeter,&levelMeterSize);
    
    NSLog(@"mPeakPower=%0.3f", levelMeter.mPeakPower);
    //NSLog(@"mAveragePower=%0.3f", levelMeter.mAveragePower);

    if(((levelMeter.mPeakPower - passedPeakPower) > _Volume_delta)) {
        [self startRecording];
        [NSThread sleepForTimeInterval:SOUND_PACKS];
        [self stopRecording];
    }
    passedPeakPower = levelMeter.mPeakPower;
}

- (void)startRecording {
/*    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I can hear you..."
                                                    message:@"Recording!!"
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
  */
    NSDateFormatter *dateForm = [[NSDateFormatter alloc]init];
    [dateForm setDateFormat:@"Y-M-d_H-m-s"];
    NSString *dateString = [dateForm stringFromDate:[NSDate date]];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.aiff",[NSHomeDirectory() stringByAppendingPathComponent:RAWAUDIO_PATH],dateString];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL, (const UInt8*)[filePath UTF8String], [filePath length], NO);
    NSLog(@"%@%@",@"Start Recording! :",filePath);
    currentPacket = 0;
    isRecording = YES;
    /*
    AudioQueueNewInput(&dataFormat,AudioInputCallback, (__bridge void *)(self),
                       NULL,
                       kCFRunLoopCommonModes, 0, &queue);*/

    AudioFileCreateWithURL(fileURL, kAudioFileAIFFType, &dataFormat,
                           kAudioFileFlags_EraseFile, &audioFile);
    
   /* UInt32 cookieSize;
    
   OSStatus o = AudioQueueGetPropertySize(queue,
                            kAudioQueueProperty_MagicCookie,
                             &cookieSize);
        char* magicCookie = (char*) malloc(cookieSize);
        o = AudioQueueGetProperty(queue, kAudioQueueProperty_MagicCookie
                              , magicCookie, &cookieSize) ;
           o = AudioFileSetProperty(audioFile,kAudioFilePropertyMagicCookieData,cookieSize,magicCookie);
        free(magicCookie);
    //}
    */
    for(int i = 0; i< NUM_OF_BUFFERS; i++){
        AudioQueueAllocateBuffer(queue,
                                 (dataFormat.mSampleRate/10.0f)*dataFormat.mBytesPerFrame,
                                 &buffers[i]);
        AudioQueueEnqueueBuffer(queue,buffers[i],0,nil);
    }
    //AudioQueueStart(queue,NULL);
}



-(void) stopRecording{
    isRecording = NO;
    AudioQueueFlush(queue);
    AudioQueueStop(queue, NO);
    
    for(int i = 0;i < NUM_OF_BUFFERS; i++){
        AudioQueueFreeBuffer(queue, buffers[i]);
    }
    
    AudioQueueDispose(queue,YES);
    AudioFileClose(audioFile);
    [self initAudioQueue];
    [self start];
    NSLog(@"Stop Recording!");
}

-(void) stop{

}

-(void) stop:(NSTimer*)timer{
    [self stopRecording];
}

-(void) nop:(int) n {
    for(int i = 0;i < n;i++){
        for(int j = 0 ; j < 100; j++){
            
        }
    }
}

void AudioInputCallback(       void* inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inBuffer,
                               const AudioTimeStamp *inStartTime,
                               UInt32 inNumberPacketDescriptions,
                               const AudioStreamPacketDescription *inPacketDescs) {
    NSLog(@"AudioInputCallback is called!");
    SoundPicker* recorder = (__bridge SoundPicker*) inUserData;

    OSStatus status = AudioFileWritePackets(recorder.audioFile, YES, inBuffer->mAudioDataByteSize,
                                            inPacketDescs, recorder.currentPacket,
                                            &inNumberPacketDescriptions, inBuffer->mAudioData);
    
    if(status == noErr){
        recorder.currentPacket += inNumberPacketDescriptions;
        AudioQueueEnqueueBuffer(recorder.queue, inBuffer, 0, nil);
    }
}

@end
