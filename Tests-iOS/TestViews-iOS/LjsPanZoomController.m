#import "LjsPanZoomController.h"
#import "Lumberjack.h"
#import <QuartzCore/QuartzCore.h>


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsPanZoomController ()

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation LjsPanZoomController

@synthesize panAndZoom;
@synthesize currentIndex;
@synthesize imageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Third", @"Third");
    self.tabBarItem.image = [UIImage imageNamed:@"third.png"];
    self.imageArray = [NSArray arrayWithObjects:
                       @"body-tat.png",
                       @"brad-pit.png",
                       @"cilo.png",
                       @"double-rainbow.png",
                       @"gameofthrones.png",
                       @"guyfawkes.png",
                       @"seed-balls.png",
                       @"stream-in-flood.png",
                       nil];
    self.currentIndex = 0;
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
  CGFloat tabH = self.tabBarController.tabBar.frame.size.height;
  CGRect frame = CGRectMake(0, 0, 320, 460 - tabH);
  UIImage *image = [UIImage imageNamed:@"bamboo-green-320x411.png"];
  self.panAndZoom = [[LjsPanAndZoomImageView alloc]
                     initWithFrame:frame
                     leftSwipeHandler:@selector(handleLeftSwipe:)
                     rightSwipeHandler:@selector(handleRightSwipe:)
                     swipeHandlerTarget:self
                     image:image];
  [self.view addSubview:self.panAndZoom];
  
  frame = CGRectMake(280, 10, 30, 30);
  UIButton *buttonResetTo1x = [[UIButton alloc] initWithFrame:frame];
  buttonResetTo1x.showsTouchWhenHighlighted = YES;
  buttonResetTo1x.layer.borderWidth = 1;
  buttonResetTo1x.layer.cornerRadius = 30/2;
  buttonResetTo1x.layer.borderColor = [UIColor darkGrayColor].CGColor;
  buttonResetTo1x.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
  [buttonResetTo1x setTitle:@"1x" forState:UIControlStateNormal];
  [buttonResetTo1x setTitleColor:[UIColor colorWithR:115
                                                   g:115
                                                   b:140] 
                        forState:UIControlStateNormal];
  [buttonResetTo1x addTarget:self 
                      action:@selector(buttonTouchedResetTo1x:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:buttonResetTo1x];
}

- (void) configureViewForCurrentIndex {
  NSString *name = [self.imageArray nth:self.currentIndex];
  UIImage *image = [UIImage imageNamed:name];
  [self.panAndZoom updateWithImage:image];
}

#pragma mark Button Actions

- (void) buttonTouchedResetTo1x:(id) sender {
  DDLogDebug(@"reset to 1x button touched");
  [self.panAndZoom zoomTo1x];
}



#pragma mark Handling Gestures 

- (void) handleRightSwipe:(UISwipeGestureRecognizer *) aRecognizer {
  if ([self.panAndZoom isAt1xZoom] == YES) {
    if (self.currentIndex == 0) {
      self.currentIndex = [self.imageArray count] - 1;
    } else {
      self.currentIndex = self.currentIndex - 1;
    }
    [self configureViewForCurrentIndex];
  }
}

- (void) handleLeftSwipe:(UISwipeGestureRecognizer *) aRecognizer {
  if ([self.panAndZoom isAt1xZoom] == YES) {
    if (self.currentIndex >= [self.imageArray count] - 1) {
      self.currentIndex = 0;
    } else {
      self.currentIndex = self.currentIndex + 1;
    }
    [self configureViewForCurrentIndex];
  }
}



#pragma mark - View Lifecycle


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //  [self.panAndZoom 
  [self.panAndZoom configureScrollViewScales];
  [self.panAndZoom centerScrollViewContents];
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
