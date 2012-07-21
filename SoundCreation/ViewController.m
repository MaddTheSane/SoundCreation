#import "ViewController.h"
#import "AudioEngine.h"

@implementation ViewController {
    int _currentTag;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 1000;
    _stopButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions
- (IBAction)playNote:(id)sender {
    _stopButton.enabled = YES;
    _currentTag = ((UIButton *)sender).tag;
    [[AudioEngine sharedEngine] play:_currentTag];
}

- (IBAction)stop:(id)sender {
    _stopButton.enabled = NO;
    [[AudioEngine sharedEngine] stop];
}
@end









