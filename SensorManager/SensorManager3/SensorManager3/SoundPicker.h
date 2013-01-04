//
//  SoundPickerViewController.h
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import "Set_ViewController.h"
#import "AbstractSensors.h"


#define NUM_OF_BUFFERS 3
#define SOUND_PACKS 5
#define REWIND_TIME_IN_MSECONDS 10000
#define RAWAUDIO_PATH @"tmp"

@interface SoundPicker : AbstractSensors{
    AudioFileID audioFile;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[NUM_OF_BUFFERS];
    AudioTimeStamp back;
    CFURLRef fileURL;
    SInt64 currentPacket;
    Float32 passedPeakPower;
    
    BOOL isRecording;
    
}

@property float Volume_delta;
@property float Interval;

@property AudioTimeStamp back;
@property Float32 passedPeakPower;
@property AudioQueueRef queue;
@property AudioFileID audioFile;
@property SInt64 currentPacket;
@property BOOL isRecording;

-(BOOL) canBeThread;
-(void) start;
-(void) main;
-(void) stop;

-(void) startRecording;
-(void) stopRecording;

//-(void) _startTimeQueue:(UInt8)passedTime:(AudioQueueRef)audioQRef;

void AudioInputCallback(    void* inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inBuffer,
                               const AudioTimeStamp* inStartTime,
                               UInt32 inNumberPacketDescriptions,
                               const AudioStreamPacketDescription* inPacketDescs
                               );

@end
