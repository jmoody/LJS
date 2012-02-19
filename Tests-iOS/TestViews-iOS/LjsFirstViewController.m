#import "LjsFirstViewController.h"
#import "Lumberjack.h"
#import "UIColor+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsFirstViewController

@synthesize picker;
@synthesize pickerDelegate;
@synthesize progress;
@synthesize label;
@synthesize glass;
@synthesize ljs;


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
  

  
  [self.glass setHighColor:[UIColor colorWithR:80 g:100 b:244]];
  [self.glass setLowColor:[UIColor colorWithR:58 g:41 b:73]];

  
  [self.ljs setHighColor:[UIColor colorWithR:80 g:100 b:244]];
  [self.ljs setLowColor:[UIColor colorWithR:58 g:41 b:73]];
  
  UIImage *image = [UIImage imageNamed:@"white-channel-300x24.png"];
  UIColor *texture = [UIColor colorWithPatternImage:image];
  self.progress.backgroundColor = texture;
//  self.progress.backgroundColor = [UIColor clearColor];
  
  self.progress.lowColor = [UIColor colorWithR:0 g:0 b:127];
  self.progress.highColor = [UIColor colorWithR:72 g:146 b:255];
  self.progress.middleColor = [UIColor colorWithR:11 g:84 b:235];
  [[self.progress layer] setNeedsDisplay];
  self.progress.gradientLayer.bounds = CGRectZero;
  self.progress.gradientLayer.position = CGPointMake(0, 12);
  
//  CGRect frame = CGRectMake(10, 145, 300, 20);
//  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame
//                                                  cornerRadius:6];
//  [[UIColor blackColor] setStroke];
//  [[UIColor redColor] setFill];
//  [path fill];
//  [path stroke];
  
}

- (void)viewDidUnload {
  [self setProgress:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


#pragma mark LJS Numeric Picker View Callback Delegate

- (void) pickerView:(UIPickerView *)pickerView didChangeString:(NSString *)newString didChangeInteger:(NSUInteger)newInteger {
  self.label.text = newString;
}


- (IBAction)progressTouched:(id)sender {
  DDLogDebug(@"progress button touched");
  CGRect bounds = self.progress.gradientLayer.bounds;
  CGFloat x = bounds.origin.x;
  CGFloat y = bounds.origin.y;
  CGFloat w = bounds.size.width + 30;
  CGFloat h = self.progress.frame.size.height;
  CGRect newBounds = CGRectMake(x, y, w, h);
  self.progress.gradientLayer.bounds = newBounds;
  self.progress.gradientLayer.position = CGPointMake(w/2, h/2);
  [[self.progress layer] setNeedsDisplay];

//  CGFloat width = (bounds.size.width + 30)/2;
//  CGFloat height = 24/2;
//  CGRect newBounds = CGRectMake(bounds.origin.x, 
//                                bounds.origin.y, 
//                                bounds.size.width + 30,
//                                24);
//  self.progress.gradientLayer.bounds = newBounds;
//  [self.progress.gradientLayer setPosition:CGPointMake(width, height)];
//  [[self.progress layer] setNeedsDisplay];
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
