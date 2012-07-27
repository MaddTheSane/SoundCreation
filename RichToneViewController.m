#import "RichToneViewController.h"
#import "RichToneEngine.h"

@implementation RichToneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.engine = [[RichToneEngine alloc] init];
}

@end
