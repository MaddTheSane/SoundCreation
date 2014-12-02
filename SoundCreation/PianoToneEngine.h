//
//  PianoToneEngine.h
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#ifndef __SoundCreation__PianoToneEngine__
#define __SoundCreation__PianoToneEngine__

#include "AudioEngine.h"
#include "Common.h"

class PianoToneEngine: public AudioEngine {
	
public:
	virtual double ProcessAudio(double theta);
};

#endif /* defined(__SoundCreation__PianoToneEngine__) */
