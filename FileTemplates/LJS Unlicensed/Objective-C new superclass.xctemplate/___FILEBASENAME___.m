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

- (id) init {
  //  [self doesNotRecognizeSelector:_cmd];
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

@end
