//
//  SoundPickerViewController.m
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SoundPicker.h"


@implementation SoundPicker

@synthesize queue,currentPacket,audioFile,isRecording;

-(void) awake{
    NSLog(@"MIC awake!");
    _Volume = 5.0f;
    _Interval = 0.5;
    _peakMeterBootupTime = 1;
    
    [self start];
}

-(BOOL)canBeThread{
    return [super canBeThread];
}

-(void) main{
    [super main];

}



- (void)start {
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
    AudioQueueStart(queue, NULL);
    
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(queue,kAudioQueueProperty_EnableLevelMetering,
                        &enabledLevelMeter,sizeof(UInt32));
    BOOL isFirstTime = YES;
    while(1){
        [self updateVolume:isFirstTime];
        if(isFirstTime){[NSThread sleepForTimeInterval:_peakMeterBootupTime];
        }else{[NSThread sleepForTimeInterval:_Interval];}
        isFirstTime = NO;
    }
}

- (void)updateVolume:(BOOL)isFirstTime {
    AudioQueueLevelMeterState levelMeter;
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue,kAudioQueueProperty_CurrentLevelMeterDB,&levelMeter,&levelMeterSize);
    
    NSLog(@"mPeakPower=%0.3f", levelMeter.mPeakPower);
    NSLog(@"mAveragePower=%0.3f", levelMeter.mAveragePower);

    
    if(!isFirstTime&&(levelMeter.mPeakPower > _Volume)) {
        [self startRecording];
        [NSThread sleepForTimeInterval:SOUND_PACKS];
        [self stopRecording];
    }

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
    NSString* filePath = [NSString stringWithFormat:@"%@/hoge.aiff",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
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

void AudioInputCallback2(       void* inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp *inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription *inPacketDescs) {
    NSLog(@"AudioInputCallback is called!");
}

@end
