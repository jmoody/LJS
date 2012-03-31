#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleRgReply.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleRgReply


#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
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
