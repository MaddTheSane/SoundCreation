//
//  PianoToneEngine.cpp
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#include "PianoToneEngine.h"

double PianoToneEngine::ProcessAudio(double thetaa) {
	return (sin(thetaa) * 1.0) + (sin(thetaa * 2) * 0.5) + (sin(thetaa * 3) * 0.25) + (sin(thetaa * 4) * 0.1125);
}
