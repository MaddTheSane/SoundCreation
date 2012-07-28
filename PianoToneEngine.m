#import "PianoToneEngine.h"

@implementation PianoToneEngine

- (double)processAudio:(double)theta {
    return (sin(theta) * 1.0) + (sin(theta * 2) * 0.5) + (sin(theta * 3) * 0.25) + (sin(theta * 4) * 0.1125);
}

@end
