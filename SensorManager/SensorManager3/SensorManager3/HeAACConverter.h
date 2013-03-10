//
//  HeAACConverter.h
//  SensorManager3
//
//  Created by Set on 2013/01/04.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "AbstractSensors.h"

enum {
    AACAudioConverterFileError,
    AACAudioConverterFormatError,
    AACAudioConverterUnrecoverableInterrupt,
    AACAudioConverterInitialisationError
};

@protocol AACAudioConverterDelegate;
@protocol AACAudioConverterDataSource;


#define checkResult(result,operation) (_checkResultLite((result),(operation),__FILE__,__LINE__))
static inline BOOL _checkResultLite(OSStatus result,const char* operation,const char* file,int line){
    if(result != noErr){
        NSLog(@" %s:%d: %s result %d %08X %4.4s¥n",file, line, operation, (int)result, (int)result, (char*)&result);
        return NO;
    }
    return YES;
}


@interface HeAACConverter: AbstractSensors{
    BOOL    _processing;
    BOOL    _cancelled;
    BOOL    _interrupted;
    NSCondition*    _condition;
    UInt32  _priorMixOverrideValue;
}
@property   (nonatomic,readwrite,retain)    NSString* source;
@property   (nonatomic,readwrite,retain)    NSString* destination;
@property   (nonatomic,readonly)    AudioStreamBasicDescription audioFormat;
@property   (nonatomic,assign)  id<AACAudioConverterDelegate> delegate;
@property   (nonatomic,assign)  id<AACAudioConverterDataSource> dataSource;

+(BOOL) AACConverterAvailable;
-(id)initWithDelegate:(id<AACAudioConverterDelegate>)delegate source:(NSString*)sourcePath destination:(NSString*)destinationPath;
-(id)initWithDelegate:(id<AACAudioConverterDelegate>)delegate dataSource:(id<AACAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat destination:(NSString *)destinationPath;

-(void)start;
-(void)cancel;

-(void)interrupt;
-(void)resume;

-(void)breakWorking;
-(void)stop;
@end

@protocol AACAudioConverterDelegate <NSObject>
-(void)DidFinishConversion:(HeAACConverter*)converter;
-(void)HeAACConverter:(HeAACConverter*)converter didFailWithError:(NSError*)error;
@optional
-(void)HeAACConverter:(HeAACConverter *)converter didMakeProgress:(CGFloat)progress;
@end

@protocol AACAudioConverterDataSource <NSObject>
-(void)HeAACConverter:(HeAACConverter*)converter nextBytes:(char*)bytes length:(NSUInteger*)length;
@optional
-(void)HeAACConverter:(HeAACConverter *)converter seekToPosition:(NSUInteger)position;
@end

