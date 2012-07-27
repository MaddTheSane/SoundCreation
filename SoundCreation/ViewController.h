#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) id engine;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

#pragma mark - Actions
- (IBAction)playNote:(id)sender;
- (IBAction)stop:(id)sender;

@end