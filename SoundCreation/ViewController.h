#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController

@property (nonatomic) double theta;

#pragma mark - Actions
- (IBAction)togglePlay:(id)sender;


@end