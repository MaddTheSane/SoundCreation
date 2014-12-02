//
//  RichToneEngine.h
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#ifndef __SoundCreation__RichToneEngine__
#define __SoundCreation__RichToneEngine__

#include "AudioEngine.h"
#include "Common.h"

class RichToneEngine: public AudioEngine {
	
public:
	virtual double ProcessAudio(double theta);
};

#endif /* defined(__SoundCreation__RichToneEngine__) */
