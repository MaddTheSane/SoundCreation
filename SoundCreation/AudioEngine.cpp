//
//  AudioEngine.cpp
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#include "AudioEngine.h"
#include "Common.h"

#define MIDDLE_C 261.63

AudioEngine::AudioEngine()
{
	_audioUnit = NULL;
	_audioGraph = NULL;
	theta = 0;
	frequency = 0;

}

double changeFrequencyByWholeStep(double frequency, bool stepUp) {
	if (stepUp)
		return (frequency * pow(kFrequency_Ratio, 2));
	else
		return (frequency / pow(kFrequency_Ratio, 2));
}

double changeFrequencyByHalfStep(double frequency, bool stepUp) {
	if (stepUp)
		return (frequency * kFrequency_Ratio);
	else
		return (frequency / kFrequency_Ratio);
}

double changeFrequencyBySteps(double frequency, long steps, bool stepUp) {
	if (stepUp)
		return (frequency * pow(kFrequency_Ratio, steps));
	else
		return (frequency / pow(kFrequency_Ratio, steps));
}

#pragma mark - sample rendering
// Audio render callback
OSStatus AudioEngine::render(void *inRefCon, // Pointer to an object to pass in parameters
				AudioUnitRenderActionFlags *ioActionFlags, // Special states
				const AudioTimeStamp *inTimeStamp, // Use to sync multiple sources
				UInt32 inBusNumber, // The bus of the audio unit
				UInt32 inNumberFrames, // Number of frames of sample data that will be passed in
				AudioBufferList *ioData) // Struct containing an array of buffers, representing sample data, and a count of buffers
{
	
	AudioEngine *engine = (AudioEngine *)inRefCon;
	
	//    const double amplitude = 0.25; // Lower amplitude means lower volume
	const double theta_increment = ((M_PI_X_2 * engine->frequency) / kSample_Rate); // Split the frequency up into even samples
	
	double theta = engine->GetTheta();
	
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	//    dbgLog(@"%i",(Float32 *)ioData->mNumberBuffers);
	//    dbgLog(@"%i",inNumberFrames);
	//    dbgLog(@"%i",inBusNumber);
	
	// Fill the buffer with audio samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
		double audioSample;
		audioSample = engine->ProcessAudio(theta);
		buffer[frame] = audioSample;
		theta += theta_increment;
		if (theta > M_PI_X_2)
			theta -= M_PI_X_2;
		
	}
	
	engine->theta = theta;
	
	return noErr;
}

double AudioEngine::ProcessAudio(double thetaa) {
	// Returns a pure tone by default
	return sin(theta) * 2.25;
}

void AudioEngine::Play(long step) {
	if (_audioUnit) {
		Stop();
	}
	
	frequency = changeFrequencyBySteps(MIDDLE_C, step, true);
	
	CreateOutputAudioUnit();
	AudioUnitInitialize(_audioUnit);
	AudioOutputUnitStart(_audioUnit);
}

void AudioEngine::Stop() {
	AudioOutputUnitStop(_audioUnit);
	AudioUnitUninitialize(_audioUnit);
	AudioComponentInstanceDispose(_audioUnit);
	_audioUnit = NULL;
}

void AudioEngine::CreateOutputAudioUnit() {
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
	input.inputProcRefCon = (void *)(this);
	
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

// TODO: FIGURE OUT IF THIS IS USEFUL; THEN FINISH
#pragma mark - Audio graph
OSStatus AudioEngine::InitializeAudioGraph() {
	
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

OSStatus AudioEngine::StartAUGraph() {
	return AUGraphStart(_audioGraph);
}

OSStatus AudioEngine::StopAUGraph() {
	Boolean isRunning;
	AUGraphIsRunning(_audioGraph, &isRunning);
	
	if (isRunning)
		return AUGraphStop(_audioGraph);
	return noErr;
}
