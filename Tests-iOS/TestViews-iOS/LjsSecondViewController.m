#import "LjsSecondViewController.h"
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

@implementation LjsSecondViewController
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = NSLocalizedString(@"Second", @"Second");
    self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  LoremIpsum *li = [[LoremIpsum alloc] init];
  NSString *text = [li characters:164];
  DDLogDebug(@"text = %@", text);
  UIFont *font = [UIFont fontWithName:@"ArialMT" size:14]; 
  CGFloat labelWidth = 250;
  //UIFont *font = [UIFont systemFontOfSize:14];
  LjsLabelAttributes *attrs = [[LjsLabelAttributes alloc]
                               initWithString:text
                               font:font
                               labelWidth:labelWidth];
  DDLogDebug(@"attributes = %@", attrs);
  CGRect frame = CGRectMake(0, 0, labelWidth, attrs.labelHeight);
  self.label.text = text;
  self.label.frame = frame;
  self.label.font = font;
  self.label.lineBreakMode = UILineBreakModeWordWrap;
  self.label.textAlignment = UITextAlignmentLeft;
  self.label.numberOfLines = attrs.numberOfLines;
    
  frame = CGRectMake(0, 0, labelWidth, 0);
  UITextView *tv = [[UITextView alloc] initWithFrame:frame];
  tv.text = text;
  tv.font = font;
  tv.alpha = 0;
  [tv sizeToFit];
  CGFloat height = tv.contentSize.height;
  DDLogDebug(@"content height: %f frame height: %f", height,
             tv.frame.size.height);
  [self.view addSubview:tv];
  height = tv.contentSize.height;
  DDLogDebug(@"content height: %f frame height: %f", height,
             tv.frame.size.height);
  
  DDLogDebug(@"%@", [self.label frameToString]);
  
  NSUInteger accumulator = 0;
  NSUInteger max = 0;
  NSUInteger runs = 1000;
  font = [UIFont fontWithName:@"ArialMT" size:18]; 
  tv.font = font;
  frame = CGRectMake(0, 0, 290, 0);
  tv.frame = frame;
  
  UIEdgeInsets existing = tv.contentInset;
  
  UIEdgeInsets insets = UIEdgeInsetsMake(12, 12, existing.bottom, existing.right);
  
  for (NSInteger index = 0;  index < runs; index++) {
    text = [li characters:150];
    tv = [[UITextView alloc] initWithFrame:frame];
    tv.font = font;
    tv.text = text;
    tv.contentInset = insets;
    [tv sizeToFit];
    height = tv.contentSize.height;
    accumulator = accumulator + height;
    
    max = MAX(max, height);
  }
  
  DDLogDebug(@"mean = %.2f", accumulator/(1.0 * runs));
  DDLogDebug(@"max = %d", max);
  
//  UIColor *highColor = [UIColor colorWithR:80 g:100 b:244];
//  UIColor *lowColor = [UIColor colorWithR:58 g:41 b:73];
  
//  LjsGradientView *top = [[LjsGradientView alloc] initWithFrame:CGRectMake(0, 202, 320, 104)];
//  [top setHighColor:highColor lowColor:lowColor];
//  [top setBorderColor:[UIColor clearColor] borderWidth:0 cornerRadius:0];
//  [self.view addSubview:top];
  
  LjsGlassView *transport = [[LjsGlassView alloc] initWithFrame:CGRectMake(0, 308, 320, 103)];
//  UIColor *highColor = [UIColor colorWithR:80 g:100 b:244];
//  UIColor *lowColor = [UIColor colorWithR:58 g:41 b:73];
//
  //  CAGradientLayer *gradient = [CAGradientLayer layer];
//  gradient.frame = transport.bounds;
//  gradient.colors = [NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil];
//  [transport.layer insertSublayer:gradient atIndex:0];
//  
//  transport.backgroundColor = [UIColor blueColor];
  [self.view addSubview:transport];
  CGFloat y = (103/4) - (44/2);
  CGFloat x = (320/2) - (44/2);
  UIButton *middle = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 44, 44)];
  [middle setBackgroundColor:[UIColor whiteColor]];
  [transport addSubview:middle];

  x = ((320/4) * 3) - (44/2);
  UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 44, 44)];
  [right setBackgroundColor:[UIColor whiteColor]];
  [transport addSubview:right];
  
  x = (320/4) - (44/2);
  UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 44, 44)];
  [left setBackgroundColor:[UIColor whiteColor]];
  [transport addSubview:left];
  
  x = 20;
  y = ((103/4) * 3) - (23 /2);
  UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(x, y, 280, 23)];
  [transport addSubview:slider];
                
  font = [UIFont systemFontOfSize:14];
  UIColor *textColor = [UIColor whiteColor];
  text = @"00:00:00";
  CGSize labelSize = [text sizeWithFont:font];
  CGFloat w = labelSize.width;
  CGFloat h = labelSize.height;
  x = 20;
  //y = ((103/8) * 7) - (h / 2);
  y = (103/8) * 7;
  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
  leftLabel.backgroundColor = [UIColor clearColor];
  leftLabel.text = text;
  leftLabel.font = font;
  leftLabel.textColor = textColor;
  leftLabel.textAlignment = UITextAlignmentLeft;
  [transport addSubview:leftLabel];
  
  x = 320 - (w + 20);
  UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
  rightLabel.backgroundColor = [UIColor clearColor];
  rightLabel.text = text;
  rightLabel.font = font;
  rightLabel.textColor = textColor;
  rightLabel.textAlignment = UITextAlignmentRight;
  [transport addSubview:rightLabel];

  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
