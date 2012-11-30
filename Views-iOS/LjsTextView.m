#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTextView.h"
#import "Lumberjack.h"
#import "LjsLabelAttributes.h"
#import "LjsCategories.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

- (void) registerForNotifications;

@end

@implementation LjsTextView
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize placeHolderLabel;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setPlaceholder:@""];
  [self setPlaceholderColor:[UIColor colorWithR:128 g:128 b:128]];
  [self registerForNotifications];
  
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self awakeFromNib];
  }
  return self;
}

- (void) registerForNotifications {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self 
         selector:@selector(textDidChange:) 
             name:UITextViewTextDidChangeNotification 
           object:nil];
  
  [nc addObserver:self 
         selector:@selector(textDidChange:) 
             name:UITextViewTextDidBeginEditingNotification
           object:nil];
}

- (void) textDidChange:(NSNotification *) notification {
  if ([self.placeholder length] == 0) {
    return;
  }
  CGFloat alpha = ([self.text length] == 0) ? 1 : 0;
  [self.placeHolderLabel setAlpha:alpha];
}

- (void)setText:(NSString *)text {
  [super setText:text];
  [self textDidChange:nil];
}

- (void)drawRect:(CGRect)rect {
  BOOL hasPlaceholder = [self.placeholder length] > 0;
  if (hasPlaceholder == YES) {
    if (self.placeHolderLabel == nil) {

      
      // the trick here (and i do not have it right yet) is that
      // the content inset applies only to the placeholder label and
      // not to where the cursor appears in the view.

      // also, setting the context insets affects whether or not the
      // text view horizontally scrolls (we do not want horizontal scrolling)
    
      // CGFloat x = self.contentInset.left;
      // CGFloat y = self.contentInset.top;
      CGFloat w = self.bounds.size.width; //- (x * 2);
      LjsLabelAttributes *attrs = [[LjsLabelAttributes alloc]
                                   initWithString:self.placeholder
                                   font:self.font
                                   labelWidth:w];
      CGFloat h = attrs.labelHeight;
      self.placeHolderLabel = [attrs labelWithFrame:CGRectMake(8, 8, w, h)
                                          alignment:UITextAlignmentRight
                                          textColor:self.placeholderColor
                                     highlightColor:self.placeholderColor
                                    backgroundColor:[UIColor clearColor]];
      self.placeHolderLabel.userInteractionEnabled = NO;
      self.placeHolderLabel.alpha = 0;
      [self addSubview:placeHolderLabel];
      self.placeHolderLabel.accessibilityIdentifier = @"text view placeholder";
    }    
    placeHolderLabel.text = self.placeholder;
    [placeHolderLabel sizeToFit];
    [self sendSubviewToBack:placeHolderLabel];
  }
  
  BOOL hasText = [self.text length] != 0;
  
  if (hasText == NO && hasPlaceholder == YES) {
    self.placeHolderLabel.alpha = 1.0;
  }
  
  [super drawRect:rect];
}

- (void)paste:(id)sender { 
  [super paste:sender]; 
  [self textDidChange:nil]; 
}

@end

