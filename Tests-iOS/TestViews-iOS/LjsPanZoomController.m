#import "LjsPanZoomController.h"
#import "Lumberjack.h"
#import "LoremIpsum.h"
#import "LjsLabelAttributes.h"
#import "LjsGlassView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+LjsAdditions.h"
#import "LjsGradientView.h"
#import "UIView+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsPanZoomController

@synthesize panAndZoom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Third", @"Third");
    self.tabBarItem.image = [UIImage imageNamed:@"third.png"];
  }
  return self;
}
							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  CGRect frame = CGRectMake(0, 0, 320, 460);
  self.panAndZoom = [[LjsPanAndZoomImageView alloc]
                     initWithFrame:frame
                     leftSwipeHandler:nil
                     rightSwipeHandler:nil
                     swipeHandlerTarget:nil
                     image:nil];
}


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
