#import "LjsValidator.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsValidator

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating LjsValidator");
  [super dealloc];
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  self = [super init];
  return nil;
}


+ (BOOL) stringContainsOnlyNumbers:(NSString *) string {
  BOOL result = NO;
  if (string != nil && [string length] > 0) {
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inverted = [decimalSet invertedSet];
    NSArray *array = [string componentsSeparatedByCharactersInSet:inverted];
    result = [array count] == 1;
  }
  return result;
}

+ (BOOL) isDictionary:(id) value {
  return [value respondsToSelector:@selector(objectForKey:)];
}

+ (BOOL) isArray:(id)value {
  return [value respondsToSelector:@selector(objectAtIndex:)];
}

+ (BOOL) isString:(id) value {
  return [value respondsToSelector:@selector(componentsSeparatedByString:)];
}

+ (BOOL) dictionary:(NSDictionary *) dictionary containsKey:(NSString *) key {
  return [dictionary objectForKey:key] != nil;
}


@end
