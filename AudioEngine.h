#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioEngine : NSObject

@property (nonatomic) double theta;
@property (nonatomic, readonly) double frequency;

#pragma mark - Singleton
+(AudioEngine *)sharedEngine;

#pragma mark - Audio control
-(void)play:(int)step;
-(void)stop;
@end