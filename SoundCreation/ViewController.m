#import "ViewController.h"

OSStatus RenderTone(void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData)
{
    ViewController *viewController = (__bridge ViewController *)inRefCon;
    
    const double amplitude = 0.25; // Lower amplitude means lower volume
//    const double frequency = 440;  // 440hz = A4
    const double samplingRate = 44100; // 44.1khz is a common sampling rate
    const double theta_increment = ((M_PI_X_2 * viewController.frequency) / samplingRate); // Split the frequency up into even samples
    
    double theta = viewController.theta;
    
//    NSLog(@"theta: %.3f",theta);
    
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = amplitude * sin(theta);
        theta += theta_increment;
        if (theta > M_PI_X_2)
            theta -= M_PI_X_2;
        
    }
    
    viewController.theta = theta;
    return noErr;
}

@implementation ViewController {
    AudioComponentInstance _toneUnit;
    double _sampleRate;
    int _currentTag;
}
@synthesize stopButton = _stopButton;

#pragma mark - Life cycle
#define MIDDLE_C 261.63

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _frequency = MIDDLE_C;
    _sampleRate = 44100;
    
    _currentTag = 1000;
    
    _stopButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions
- (IBAction)playNote:(id)sender {
    if (_toneUnit)
        [self stop:nil];
    
    _currentTag = ((UIButton *)sender).tag;
    
    // Button tag corresponds to number of steps from c
    _frequency = changeFrequencyBySteps(MIDDLE_C, _currentTag, YES);
    
    [self createAudioUnit];
    
    OSErr err = AudioUnitInitialize(_toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
    
    err = AudioOutputUnitStart(_toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %hd", err);
    
    _stopButton.enabled = YES;
}

- (IBAction)stop:(id)sender {
    AudioOutputUnitStop(_toneUnit);
    AudioUnitUninitialize(_toneUnit);
    AudioComponentInstanceDispose(_toneUnit);
    _toneUnit = nil;
    
    _stopButton.enabled = NO;
}

#pragma mark - Audio Unit
- (void)createAudioUnit {
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output");
    
    OSErr err = AudioComponentInstanceNew(defaultOutput, &_toneUnit);
    NSAssert1(_toneUnit, @"Error creating unint: %hd", err);
    
    AURenderCallbackStruct input;
    input.inputProc = RenderTone;
    input.inputProcRefCon = (__bridge void *)(self);
    err = AudioUnitSetProperty(_toneUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
    NSAssert1(err == noErr, @"Error setting callbackL %hd", err);
    
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte  = 8;
    
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = _sampleRate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = (kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved);
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    err = AudioUnitSetProperty(_toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat,
                               sizeof(AudioStreamBasicDescription));
    NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}
@end









