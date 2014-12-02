//
//  SquareWaveAudioEngine.h
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#ifndef __SoundCreation__SquareWaveAudioEngine__
#define __SoundCreation__SquareWaveAudioEngine__

#include "AudioEngine.h"
#include "Common.h"

class SquareWaveEngine: public AudioEngine {
	
public:
	virtual double ProcessAudio(double theta);
};

#endif /* defined(__SoundCreation__SquareWaveAudioEngine__) */
