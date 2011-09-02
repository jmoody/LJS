
#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Initialization code here.
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}


@end
