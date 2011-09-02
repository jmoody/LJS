
#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

// Disallow the normal default initializer for instances
//- (id)init {
//  [self doesNotRecognizeSelector:_cmd];
//  return nil;
//}

- (id) init {
  self = [super init];
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
