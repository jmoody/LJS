#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark Memory Management

- (void) dealloc {
  DDLogDebug(@"deallocating ___FILEBASENAMEASIDENTIFIER___");
  [super dealloc];
}

- (id) initWithFrame:(NSRect) frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code here.
  }
  return self;
}


#pragma mark Drawing

- (void) drawRect:(NSRect) dirtyRect {
  // Drawing code here.
}

@end
