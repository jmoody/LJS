
#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

- (id) initWithWindow:(NSWindow *)window {
  self = [super initWithWindow:window];
  if (self) {
    // Initialization code here.
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (NSString *) description {
  NSSTring *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}

- (void) windowDidLoad {
  [super windowDidLoad];
  
  // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
