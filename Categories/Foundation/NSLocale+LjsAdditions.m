#import "NSLocale+LjsAdditions.h"
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

@end
