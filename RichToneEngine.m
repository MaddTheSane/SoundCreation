#import "RichToneEngine.h"

@implementation RichToneEngine

- (double)processAudio:(double)theta {
    return (sin(theta)+sin(theta * 2)+sin(theta * 3)+sin(theta * 4)) * 0.25;
}

@end