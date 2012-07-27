#import "AudioEngine.h"

// Audio render callback
OSStatus render(void *inRefCon, // Pointer to an object to pass in parameters
                AudioUnitRenderActionFlags *ioActionFlags, // Special states
                const AudioTimeStamp *inTimeStamp, // Use to sync multiple sources
                UInt32 inBusNumber, // The bus of the audio unit
                UInt32 inNumberFrames, // Number of frames of sample data that will be passed in
                AudioBufferList *ioData) // Struct containing an array of buffers, representing sample data, and a count of buffers
{
    
    AudioEngine *engine = (__bridge AudioEngine *)inRefCon;
    
//    const double amplitude = 0.25; // Lower amplitude means lower volume
    const double theta_increment = ((M_PI_X_2 * engine.frequency) / kSample_Rate); // Split the frequency up into even samples
    
    double theta = engine.theta;
    
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
//    dbgLog(@"%i",(Float32 *)ioData->mNumberBuffers);
//    dbgLog(@"%i",inNumberFrames);
//    dbgLog(@"%i",inBusNumber);
    
    // Fill the buffer with audio samples
    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        double audioSample;
        audioSample = [engine processAudio:theta];
        buffer[frame] = audioSample;
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
    AUGraph _audioGraph;
}

#pragma mark - Singleton
+ (AudioEngine *)sharedEngine {
    if (!inst)
        inst = [[AudioEngine alloc] init];
    return inst;
}

#pragma mark - Audio processing
- (double)processAudio:(double)theta {
    // Returns a pure tone by default
    return sin(theta) * 2.25;
}

#pragma mark - Audio control
#define MIDDLE_C 261.63

- (void)play:(int)step {
    if (_audioUnit)
        [self stop];
    
    _frequency = changeFrequencyBySteps(MIDDLE_C, step, YES);
    [self createAudioUnit];
    AudioUnitInitialize(_audioUnit);
    AudioOutputUnitStart(_audioUnit);
}

- (void)stop {
    AudioOutputUnitStop(_audioUnit);
    AudioUnitUninitialize(_audioUnit);
    AudioComponentInstanceDispose(_audioUnit);
    _audioUnit = nil;
}

#pragma mark - Audio unit
- (void)createAudioUnit {
    
    // output component description
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    
    // Create an audio unit with our current description
    AudioComponent outputComponent = AudioComponentFindNext(NULL, &defaultOutputDescription);
    OSErr err = AudioComponentInstanceNew(outputComponent, &_audioUnit);
    
    // Setup render callback
    // Calls our render function which provides a buffer of audio samples
    AURenderCallbackStruct input;
    input.inputProc = &render;
    input.inputProcRefCon = (__bridge void *)(self);
    
    // Set the callback struct to our audio unit
    err = AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
    
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte  = 8;
    
    // Specify the format for the audio stream
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = kSample_Rate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = (kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved);
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    
    // Set the audio stream to the audio unit
    err = AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat,
                               sizeof(AudioStreamBasicDescription));
}


// TODO: FIGURE OUT HOW IF THIS IS USEFUL; THEN FINISH
#pragma mark - Audio graph
- (OSStatus)initializeAudioGraph {
    
    // Create a new AUGraph
    NewAUGraph(&_audioGraph);
    
    // Create an AUNode
    // Nodes represent audio units on the graph
    AUNode someNode;
    
    // Create audio component descriptions
    AudioComponentDescription someOutputDescription;
    someOutputDescription.componentType = kAudioUnitType_Output;
    someOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    someOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    someOutputDescription.componentFlags = 0;
    someOutputDescription.componentFlagsMask = 0;
    
    // Add node to the graph
    AUGraphAddNode(_audioGraph, &someOutputDescription, &someNode);
    
    AUGraphOpen(_audioGraph);
    
    AUGraphNodeInfo(_audioGraph, someNode, NULL, &_audioUnit);
    
    
    
    // Initialize the audio graph
    AUGraphInitialize(_audioGraph);
    
    return noErr;
}

- (OSStatus)startAUGraph {
    return AUGraphStart(_audioGraph);
}

- (OSStatus)stopAUGraph {
    Boolean isRunning;
    AUGraphIsRunning(_audioGraph, &isRunning);

    if (isRunning)
        return AUGraphStop(_audioGraph);
    return NO;
}

@end
