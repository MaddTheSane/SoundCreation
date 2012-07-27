#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioEngine : NSObject

@property (nonatomic) double theta;
@property (nonatomic) double frequency;

#pragma mark - Singleton
+(AudioEngine *)sharedEngine;

#pragma mark - Audio processing
-(double)processAudio:(double)theta;

#pragma mark - Audio control
-(void)play:(int)step;
-(void)stop;
@end