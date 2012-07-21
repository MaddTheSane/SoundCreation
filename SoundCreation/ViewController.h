#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController

@property (nonatomic) double frequency;
@property (nonatomic) double theta;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

#pragma mark - Actions
- (IBAction)playNote:(id)sender;
- (IBAction)stop:(id)sender;

@end