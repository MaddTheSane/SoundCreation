#import "AudioEngine.h"

OSStatus render(void *inRefCon,
                AudioUnitRenderActionFlags *ioActionFlags,
                const AudioTimeStamp *inTimeStamp,
                UInt32 inBusNumber,
                UInt32 inNumberFrames,
                AudioBufferList *ioData) {
    
    AudioEngine *engine = (__bridge AudioEngine *)inRefCon;
    
    const double amplitude = 0.25; // Lower amplitude means lower volume
    const double theta_increment = ((M_PI_X_2 * engine.frequency) / kSample_Rate); // Split the frequency up into even samples
    
    double theta = engine.theta;
    
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = amplitude * sin(theta);
        theta += theta_increment;
        if (theta > M_PI_X_2)
            theta -= M_PI_X_2;
        
    }
    
    engine.theta = theta;
    
    return noErr;
}

static AudioEngine *inst = nil;

@implementation AudioEngine {
    AudioComponentInstance _audioUnit;
}

#pragma mark - Singleton
+ (AudioEngine *)sharedEngine {
    if (!inst)
        inst = [[AudioEngine alloc] init];
    return inst;
}

#pragma mark - Audio control
#define MIDDLE_C 261.63

- (void)play:(int)step {
    if (_audioUnit)
        [self stop];
    
    _frequency = changeFrequencyBySteps(MIDDLE_C, step, YES);
    
    [self createAudioUnit];
    
    OSErr err = AudioUnitInitialize(_audioUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
    
    err = AudioOutputUnitStart(_audioUnit);
    NSAssert1(err == noErr, @"Error starting unit: %hd", err);
}

- (void)stop {
    AudioOutputUnitStop(_audioUnit);
    AudioUnitUninitialize(_audioUnit);
    AudioComponentInstanceDispose(_audioUnit);
    _audioUnit = nil;
}

#pragma mark - Audio unit
- (void)createAudioUnit {
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output");
    
    OSErr err = AudioComponentInstanceNew(defaultOutput, &_audioUnit);
    NSAssert1(_audioUnit, @"Error creating unint: %hd", err);
    
    AURenderCallbackStruct input;
    input.inputProc = render;
    input.inputProcRefCon = (__bridge void *)(self);
    err = AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
    NSAssert1(err == noErr, @"Error setting callbackL %hd", err);
    
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte  = 8;
    
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = kSample_Rate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = (kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved);
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    err = AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat,
                               sizeof(AudioStreamBasicDescription));
    NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}

@end
