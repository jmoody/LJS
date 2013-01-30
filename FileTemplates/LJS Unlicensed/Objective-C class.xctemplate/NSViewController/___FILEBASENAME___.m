#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
  DDLogWarn(@"received memory warning");
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  DDLogDebug(@"view did load");
  //  [tableView release];
  //  [navBar release];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Initialization code here.
  }
  return self;
}

#pragma mark View Life Cycle

- (void) awakeFromNib {
  DDLogDebug(@"waking from nib");
}

- (void) viewDidLoad {
  [super viewDidLoad];  
  DDLogDebug(@"view did load");
}

#pragma mark View Events 


– (void) viewWillAppear:(BOOL) animated {
  DDLogDebug(@"view will appear");
}

– (void) viewDidAppear:(BOOL) animated {
  DDLogDebug(@"view did appear");
}

– (void) viewWillDisappear:(BOOL) animated {
  DDLogDebug(@"view did disappear");
}

– (void) viewDidDisappear:(BOOL) animated {
  DDLogDebug(@"view will disappear");
}

@end