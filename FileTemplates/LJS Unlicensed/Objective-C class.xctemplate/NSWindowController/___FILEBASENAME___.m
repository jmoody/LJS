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

- (id) initWithWindow:(NSWindow *)window {
  self = [super initWithWindow:window];
  if (self) {
    // Initialization code here.
  }
  return self;
}


- (void) windowDidLoad {
  [super windowDidLoad];
  
  // Implement this method to handle any initialization after your window
  // controller's window has been loaded from its nib file.
}

@end
