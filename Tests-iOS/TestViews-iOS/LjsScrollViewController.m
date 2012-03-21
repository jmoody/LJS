#import "LjsScrollViewController.h"
#import "Lumberjack.h"
#import "LjsCategories.h"
#import <QuartzCore/QuartzCore.h>
#import "LjsVariates.h"
#import "LjsScrollView.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsScrollViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;


@end

@implementation LjsScrollViewController
@synthesize scrollView;
@synthesize label;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Fourth", @"Fourth");
    self.tabBarItem.image = [UIImage imageNamed:@"fourth.png"];
  }
  return self;
}
							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [self setScrollView:nil];
  [self setLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.scrollView.contentSize = self.scrollView.frame.size;
  
}

#pragma mark Button Actions

#pragma mark Handling Gestures 


#pragma mark - View Lifecycle


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

@end
