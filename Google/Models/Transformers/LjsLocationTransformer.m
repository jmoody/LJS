#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsLocationTransformer.h"
#import "Lumberjack.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "LjsLocationManager.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsLocationTransformer


#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}


+ (BOOL) allowsReverseTransformation {
  return YES;
}

+ (Class) transformedValueClass {
  return [NSData class];
}

- (id)transformedValue:(id)value {
  NSData *result = nil;
  if (value != nil) {
    if ([value isKindOfClass:[NSData class]]) {
      result = value;
    } else {
      result = [NSKeyedArchiver archivedDataWithRootObject:(LjsLocation *) value];
    }
  }
  return result;
}

- (id)reverseTransformedValue:(id)value {
  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
