#import "ViewController.h"
#import "PureToneEngine.h"

@implementation ViewController {
    NSInteger _currentTag;
}
@synthesize engine = _engine;

#pragma mark - Life cycle

- (void)setEngine:(AudioEngine *)engine
{
	if (_engine) {
		delete _engine;
	}
	
	if (engine) {
		_engine = engine;
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 1000;
    _stopButton.enabled = NO;
    
    _engine = new PureToneEngine();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions
- (IBAction)playNote:(id)sender {
    _stopButton.enabled = YES;
    _currentTag = ((UIButton *)sender).tag;
	_engine->Play(_currentTag);
}

- (IBAction)stop:(id)sender {
    _stopButton.enabled = NO;
	_engine->Stop();
}

- (void)dealloc
{
	self.engine = NULL;
}

@end









