#import "LjsFirstViewController.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsFirstViewController

@synthesize picker;
@synthesize pickerDelegate;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"First", @"First");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSUInteger min, max, current;
  min = 1;
  max = 99999;
  current = 1234;
  
  self.pickerDelegate = [[LjsNumericPickerDelegate alloc]
                         initWithCallbackDelegate:self
                         startingValue:current
                         minValue:min
                         maxValue:max];
  
  self.label.text = 
  [NSString stringWithFormat:self.pickerDelegate.conversionFormatString,
   current];
  [self.picker setDelegate:self.pickerDelegate];
  [self.picker setDataSource:self.pickerDelegate];
  [self.pickerDelegate pickerView:self.picker setSelectedWithInteger:current];
  
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


#pragma mark LJS Numeric Picker View Callback Delegate

- (void) pickerView:(UIPickerView *)pickerView didChangeString:(NSString *)newString didChangeInteger:(NSUInteger)newInteger {
  self.label.text = newString;
}
@end


#pragma mark DEAD SEA
//- (void)viewWillAppear:(BOOL)animated {
//  [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//  [super viewDidAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//	[super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//	[super viewDidDisappear:animated];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//  // Return YES for supported orientations
//  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
