#import "ViewController.h"
#import "PureToneEngine.h"

@implementation ViewController {
    int _currentTag;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 1000;
    _stopButton.enabled = NO;
    
    _engine = [[PureToneEngine alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions
- (IBAction)playNote:(id)sender {
    _stopButton.enabled = YES;
    _currentTag = ((UIButton *)sender).tag;
    [_engine play:_currentTag];
}

- (IBAction)stop:(id)sender {
    _stopButton.enabled = NO;
    [_engine stop];
}
@end









