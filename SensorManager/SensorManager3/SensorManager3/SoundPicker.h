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
#import "HeAACConverter.h"
#import "AbstractSensors.h"
#import "SensorManager.h"
#import "LOGGER.h"

#import "Set_AppDelegate.h"

#define __DEBUG__

#define NUM_OF_BUFFERS 3
#define SOUND_PACKS 5
#define REWIND_TIME_IN_MSECONDS 10000
#define RAWAUDIO_PATH @"tmp"
#define COOKEDAUDIO_PATH @"PeekaBoo"

@interface SoundPicker : AbstractSensors{
    AudioFileID audioFile;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[NUM_OF_BUFFERS];
    AudioTimeStamp back;
    CFURLRef fileURL;
    SInt64 currentPacket;
    Float32 passedPeakPower;
    
    NSString* sourcePath;
    NSString* destinationPath;
    HeAACConverter* converter;
    
    
    BOOL isRecording;
    NSCondition* _recording;
    
}

@property (nonatomic,readonly)float Volume_delta;
@property (nonatomic,readwrite)float Interval;

@property (nonatomic,readwrite) AudioTimeStamp back;
@property (nonatomic,readwrite)Float32 passedPeakPower;
@property (nonatomic,readwrite)AudioQueueRef queue;
@property (nonatomic,readwrite)AudioFileID audioFile;
@property (nonatomic,readwrite)SInt64 currentPacket;
@property (nonatomic,readwrite)BOOL isRecording;

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
