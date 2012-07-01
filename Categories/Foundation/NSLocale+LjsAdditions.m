#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSLocale (NSLocale_LjsAdditions)


+ (NSLocale *) localeForEnglishUS {
  return [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
}

- (BOOL) localeUses24HourClock {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:self];
  [formatter setDateStyle:NSDateFormatterNoStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  NSString *dateString = [formatter stringFromDate:[NSDate date]];
  NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
  NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
  BOOL is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
  return is24Hour;
}

@end
