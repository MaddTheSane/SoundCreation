//
//  RichToneEngine.cpp
//  SoundCreation
//
//  Created by C.W. Betts on 12/2/14.
//
//

#include "RichToneEngine.h"

double RichToneEngine::ProcessAudio(double thetaa) {
	return (sin(thetaa)+sin(thetaa * 2)+sin(thetaa * 3)+sin(thetaa * 4)) * 0.25;
}
