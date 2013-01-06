//
//  HeAACConverter.m
//  SensorManager3
//
//  Created by Set on 2013/01/04.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//

#import "HeAACConverter.h"
#import "SoundPicker.h"

@implementation HeAACConverter
@synthesize source = _source, destination = _destination;

+(BOOL)AACConverterAvailable{
#ifdef TARGET_IPHONE_SIMULATOR
    return YES;
#else
    static BOOL available;
    static BOOL available_set = NO;
    
    if(available_set)return available;
    
    UInt32 encoderSpecifier = kAudioFormatMPEG4AAC;
    UInt32 size;
    
    if(!checkResult(AudioFormatGetPropertyInfo(kAudioProperty_Encoders,sizeof(encoderSpecifier),&encoderSpecifier,&size), "AudioFormatGetPropertyInfo(kAudioProperty_Encoders)"))return NO;
    
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription encoderDescriptions[numEncoders];
    
    if(!checkResult(AudioFormatGetProperty(kAudioProperty_Encoders,sizeof(encoderSpecifier),&encoderSpecifier,&size,encoderDescriptions),"AudioFormatGetPropertyInfo(kAudioProperty_Encoders)")){
        available_set = YES;
        available = NO;
        return NO;
    }
    
    for(UInt32 i = 0; i < numEncoders; ++i){
        if(encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC && encoderDescriptons[i].mManufacturer == kAppleHardwareAudioCodecManufacturer){
            available_set = YES;
            available = YES;
            return YES;
        }
    }
    
    available_set = YES;
    available = NO;

    return NO;
#endif
}

-(id)initWithDelegate:(id<AACAudioConverterDelegate>)delegate source:(NSString *)sourcePath destination:(NSString *)destinationPath{
    
    if(!(self= [super init]))return nil;
    
    self.delegate = delegate;
    self.source = sourcePath;
    self.destination = destinationPath;
    _condition = [[NSCondition alloc]init];
    
    return self;
}

-(id)initWithDelegate:(id<AACAudioConverterDelegate>)delegate dataSource:(id<AACAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat destination:(NSString *)destinationPath{
    
    if(!(self = [super init])) return nil;
    
    self.delegate = delegate;
    self.dataSource = dataSource;
    self.destination = destinationPath;
    _audioFormat = audioFormat;
    _condition = [[NSCondition alloc]init];
    
    return self;
}

-(void)dealloc{
    //[_condition release];
    self.source = nil;
    self.destination = nil;
    self.delegate = nil;
    self.dataSource = nil;
    //[super dealloc];
}

-(void)start{
    UInt32 size = sizeof(_priorMixOverrideValue);
    checkResult(AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers,&size, &_priorMixOverrideValue), "AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers)");
    
    if (_priorMixOverrideValue != NO) {
        UInt32 allowMixing = NO;
        checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing), "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers");
    }
    
    _cancelled = NO;
    _processing = YES;
//    [self retain];
    [self performSelectorInBackground:@selector(processingThread) withObject:nil];
}

-(void)cancel{
    _cancelled = YES;
    while (_processing) {
        [NSThread sleepForTimeInterval:0.01];
    }
    if (_priorMixOverrideValue != NO){
        UInt32 allowMixing = _priorMixOverrideValue;
        checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing), "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers");
    }
}

-(void)interrupt{
    [_condition lock];
    _interrupted = YES;
    [_condition unlock];
}

-(void)resume{
    [_condition lock];
    _interrupted = NO;
    [_condition signal];
    [_condition unlock];
}

-(void)reportProgress:(NSNumber*)progress{
    if (_cancelled)return;
    [_delegate HeAACConverter:self didMakeProgress:[progress floatValue]];
}

-(void)reportCompletion {
    if (_cancelled)return;
    [_delegate DidFinishConversion:self];
    if (_priorMixOverrideValue != NO) {
        UInt32 allowMixing = _priorMixOverrideValue;
        checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing), "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers");
    }
}

-(void)reportErrorAndCleanup:(NSError*)error{
    if (_cancelled)return;
    [[NSFileManager defaultManager]removeItemAtPath:_destination error:NULL];
    
    if (_priorMixOverrideValue != NO) {
        UInt32 allowMixing = _priorMixOverrideValue;
        checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing), "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers");
    }
    
    [_delegate HeAACConverter:self didFailWithError:error];
}

-(void)processingThread{
    [[NSThread currentThread]setThreadPriority:0.9];
    
    ExtAudioFileRef sourceFile = NULL;
    AudioStreamBasicDescription sourceFormat;
    
    if (_source) {
        if (!checkResult(ExtAudioFileOpenURL((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:_source]), &sourceFile), "ExtAudioFileOpenURL")) {
            [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:)
                                   withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain" code:AACAudioConverterFormatError userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Couldn't read the source file", @"Error message") forKey:NSLocalizedDescriptionKey]] waitUntilDone:NO];
            _processing = NO;
            return;
        }
    }else{
        sourceFormat = _audioFormat;
    }
    
    AudioStreamBasicDescription destinationFormat;
    memset(&destinationFormat,0,sizeof(destinationFormat));
    destinationFormat.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
    
    destinationFormat.mFormatID = kAudioFormatMPEG4AAC_HE_V2;
    
    UInt32 size = sizeof(destinationFormat);
    if (!checkResult(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo,0, NULL, &size, &destinationFormat), "AudioFormatGetProperty(kAudioFormatProperty_FormatInfo")) {
        [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:) withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain" code:AACAudioConverterFormatError userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Couldn't setup destination format",@"Error message") forKey:NSLocalizedDescriptionKey]] waitUntilDone:NO];
        _processing = NO;
        return;
    }
    ExtAudioFileRef destinationFile;
    if (!checkResult(ExtAudioFileCreateWithURL((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:_destination]), kAudioFileM4AType, &destinationFormat, NULL, kAudioFileFlags_EraseFile, &destinationFile), "ExtAudioFileCreateWithURL((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:_destination])")) {
        [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:)
                               withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain" code:AACAudioConverterFormatError userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Couldn't open the sourceFile",@"Error message") forKey:NSLocalizedDescriptionKey]] waitUntilDone:NO];
        _processing = NO;
        return;
    }
    
    AudioStreamBasicDescription clientFormat;
    if (sourceFormat.mFormatID == kAudioFormatLinearPCM) {
        clientFormat = sourceFormat;
    }else{
        memset(&clientFormat, 0, sizeof(clientFormat));
        int sampleSize = sizeof(AudioSampleType);
        clientFormat.mFormatID = kAudioFormatLinearPCM;
        clientFormat.mFormatFlags = kAudioFormatFlagsCanonical;
        clientFormat.mBitsPerChannel = 8 * sampleSize;
        clientFormat.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
        clientFormat.mFramesPerPacket = 1;
        clientFormat.mBytesPerPacket = clientFormat.mBytesPerFrame = sourceFormat.mChannelsPerFrame * sampleSize;
        clientFormat.mSampleRate = sourceFormat.mSampleRate;
    }
    
    size = sizeof(clientFormat);
    if((sourceFile && !checkResult(ExtAudioFileSetProperty(sourceFile,kExtAudioFileProperty_ClientDataFormat,size,&clientFormat),"ExtAudioFileSetProperty(sourceFile,kExtAudioFileProperty_ClientDataFormat)"))||
       !checkResult(ExtAudioFileSetProperty(destinationFile,kExtAudioFileProperty_ClientDataFormat,size,&clientFormat),"ExtAudioFileSetProperty(destinationFile,kExtAudioFileProperty_ClientDataFormat)")){
        if (sourceFile) {
            ExtAudioFileDispose(sourceFile);
        }
        ExtAudioFileDispose(destinationFile);
        [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:)
                               withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain"
                                                              code:AACAudioConverterFormatError
                                                          userInfo:[NSDictionary  dictionaryWithObject:NSLocalizedString(@"Couldn't setup intermediate conversion format",@"Error message") forKey:NSLocalizedDescriptionKey]]
                                                     waitUntilDone:NO];
         _processing = NO;
         return;
    }
    
    BOOL canResumeFromInterruption = YES;
    AudioConverterRef converter;
    size = sizeof(converter);
    if (checkResult(ExtAudioFileGetProperty(destinationFile, kExtAudioFileProperty_AudioConverter, &size, &converter),"ExtAudioFileGetProperty(destinationFile)")) {
        UInt32 canResume = 0;
        size = sizeof(canResume);
        if (checkResult(AudioConverterGetProperty(converter, kAudioConverterPropertyCanResumeFromInterruption, &size, &canResume), "AudioConverterGetProperty(converter, kAudioConverterPropertyCanResumeFromInterruption)")) {
            canResumeFromInterruption = (BOOL)canResume;
        }
    }
    
    SInt64 lengthInFrames = 0;
    if(sourceFile){
        size = sizeof(lengthInFrames);
        ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileLengthFrames, &size, &lengthInFrames);
    }
    
    UInt32 bufferByteSize = 32768;
    char srcBuffer[bufferByteSize];
    SInt64 sourceFrameOffset = 0;
        
    BOOL reportProgress = lengthInFrames > 0 && [_delegate respondsToSelector:@selector(HeAACConverter:didMakeProgress:)];
    NSTimeInterval lastProgressReport = [NSDate timeIntervalSinceReferenceDate];
        
    while (!_cancelled) {
        AudioBufferList fillBufList;
        fillBufList.mNumberBuffers = 1;
        fillBufList.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
        fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
        fillBufList.mBuffers[0].mData = srcBuffer;
            
        UInt32 numFrames = bufferByteSize / clientFormat.mBytesPerFrame;
        if(sourceFile){
            if(!checkResult(ExtAudioFileRead(sourceFile, &numFrames, &fillBufList),"ExtAudioFileRead")){
                ExtAudioFileDispose(sourceFile);
                ExtAudioFileDispose(destinationFile);
                [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:) withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain"
                                                                                                               code:AACAudioConverterFormatError
                                                                                                           userInfo:[NSDictionary  dictionaryWithObject:NSLocalizedString(@"Error reading the source file",@"Error message") forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
                _processing = NO;
                return;
            }
        }else{
            NSUInteger length = bufferByteSize;
            [_dataSource HeAACConverter:self nextBytes:srcBuffer length:&length];
            numFrames = length / clientFormat.mBytesPerFrame;
            fillBufList.mBuffers[0].mDataByteSize = length;
        }
        
        if (!numFrames) {
            break;
        }
        
        sourceFrameOffset += numFrames;
        
        [_condition lock];
        BOOL wasInterRrupted = _interrupted;
        while (_interrupted) {
            [_condition wait];
        }
        [_condition unlock];
        
        if (wasInterRrupted && !canResumeFromInterruption) {
            if (sourceFile) ExtAudioFileDispose(sourceFile);
            ExtAudioFileDispose(destinationFile);
            [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:) withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain"
                                                                code:AACAudioConverterFormatError
                                                                                                           userInfo:[NSDictionary  dictionaryWithObject:NSLocalizedString(@"Interrupted",@"Error message") forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
        
        OSStatus status = ExtAudioFileWrite(destinationFile, numFrames, &fillBufList);
        
        if (status == kExtAudioFileError_CodecUnavailableInputConsumed) {
            
        }else if(status == kExtAudioFileError_CodecUnavailableInputNotConsumed){
            sourceFrameOffset -= numFrames;
            if(sourceFile){
                checkResult(ExtAudioFileSeek(sourceFile, sourceFrameOffset), "ExtAudioFileSeek");
            }else if( [_dataSource respondsToSelector:@selector(HeAACConverter:seekToPosition:)]){
                [_dataSource HeAACConverter:self seekToPosition:sourceFrameOffset * clientFormat.mBytesPerFrame];
            }
        }else if (!checkResult(status, "ExtAudioFileWrite")){
            if (sourceFile) ExtAudioFileDispose(sourceFile);
            ExtAudioFileDispose(destinationFile);
            [self performSelectorOnMainThread:@selector(reportErrorAndCleanup:) withObject:[NSError errorWithDomain:@"HeAACConverterErrorDomain"
                                                                                                               code:AACAudioConverterFormatError
                                                                                                           userInfo:[NSDictionary  dictionaryWithObject:NSLocalizedString(@"Error writing the destination file",@"Error message") forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
        
        if (reportProgress && [NSDate timeIntervalSinceReferenceDate]-lastProgressReport > 0.1) {
            lastProgressReport = [NSDate timeIntervalSinceReferenceDate];
            [self performSelectorOnMainThread:@selector(reportProgress:) withObject:[NSNumber numberWithFloat:(double)sourceFrameOffset / lengthInFrames ]
                                waitUntilDone:NO];
        }
    }
    
    if (sourceFile) ExtAudioFileDispose(sourceFile);
    ExtAudioFileDispose(destinationFile);

    if (_cancelled){
        [[NSFileManager defaultManager]removeItemAtPath:_destination error:NULL];
    }else{
        [self performSelectorOnMainThread:@selector(reportCompletion) withObject:nil waitUntilDone:NO];
    }

    _processing = NO;

}

-(void)stop{
    
}

-(void)breakWorking{
    
}
@end
