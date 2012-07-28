#import "PianoViewController.h"
#import "PianoToneEngine.h"

@implementation PianoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.engine = [[PianoToneEngine alloc] init];
}
@end