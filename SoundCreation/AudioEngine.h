//
//  AudioEngine.h
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#ifndef __SoundCreation__AudioEngine__
#define __SoundCreation__AudioEngine__

#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>

#include <stdio.h>

/*
 * The point of this class is to due all of the crazy stuff
 * involved in audio.
 * The eventual idea is to have a set of 'instruments' you can
 * choose from in this class.
 * Also there should be simple ways to play intervals and chords.
 * SUBCLASSING: You may override the processAudio: method to
 * do your own audio editing.
 */

#pragma mark - Helpers
/*
 * Frequency ratio between notes tuned in '12 equal temperament'
 * the ratio to the 12th power is equal to 2, which when
 * multiplied by a frequency gives a sound one octave higher
 */
#define kFrequency_Ratio 1.05946

/*
 * Standard sample rate
 * 44.1 khz
 */
#define kSample_Rate     44100

__BEGIN_DECLS

/*
 * Returns the frequency of the note that is a whole step higher
 * or lower than the frequency you give
 * NOTE: Set the 2nd parameter to YES to step up, NO to step down
 */
double changeFrequencyByWholeStep(double, bool);

/*
 * Same as above but for half step
 */
double changeFrequencyByHalfStep(double, bool);

/*
 * Same as above except you set how many steps to take
 * The 2nd parameter sets how many half steps to take
 * NOTE: passing 0 in for the 2nd param will return the given
 * frequency
 */
double changeFrequencyBySteps(double, long, bool);

__END_DECLS


#ifdef __cplusplus

class AudioEngine {
	AudioComponentInstance _audioUnit;
	AUGraph _audioGraph;
	static OSStatus render(void *inRefCon, // Pointer to an object to pass in parameters
						   AudioUnitRenderActionFlags *ioActionFlags, // Special states
						   const AudioTimeStamp *inTimeStamp, // Use to sync multiple sources
						   UInt32 inBusNumber, // The bus of the audio unit
						   UInt32 inNumberFrames, // Number of frames of sample data that will be passed in
						   AudioBufferList *ioData);
	
	void CreateOutputAudioUnit();


protected:
	 double theta;
	 double frequency;
	
public:
	
	//Needed because C++ doesn't blank the values.
	AudioEngine();
	virtual double ProcessAudio(double theta);
	void Play(long step);
	void Stop();
	
	OSStatus InitializeAudioGraph();
	OSStatus StartAUGraph();
	OSStatus StopAUGraph();
	
	//getters/setters
	inline double GetTheta() { return theta; }
	inline void SetTheta(double aTheta) { theta = aTheta; }
	
	inline double GetFrequency() { return frequency; }
	inline void SetFrequency(double aFreq) { frequency = aFreq; }
};

#endif


#endif /* defined(__SoundCreation__AudioEngine__) */
