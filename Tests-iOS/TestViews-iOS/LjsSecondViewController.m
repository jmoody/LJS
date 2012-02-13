#import "LjsSecondViewController.h"
#import "Lumberjack.h"
#import "LoremIpsum.h"
#import "LjsTextAndFont.h"

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
  DDLogDebug(@"height of tv = %f", height);
  [self.view addSubview:tv];
  height = tv.contentSize.height;
  DDLogDebug(@"height of tv = %f", height);

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
