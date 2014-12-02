#import <UIKit/UIKit.h>

class AudioEngine;

@interface ViewController : UIViewController

@property (nonatomic) AudioEngine *engine;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

#pragma mark - Actions
- (IBAction)playNote:(id)sender;
- (IBAction)stop:(id)sender;

@end