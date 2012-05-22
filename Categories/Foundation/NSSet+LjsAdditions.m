#import "NSSet+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSSet (NSSet_LjsAdditions)

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter {
  NSArray *array = [NSArray arrayWithObject:aSorter];
  return [self sortedArrayUsingDescriptors:array];
}

- (BOOL) emptyp {
  return [self count] == 0;
}

+ (BOOL) setIsEmptyP:(NSSet *) aSet {
  return (aSet == nil) ? YES : [aSet emptyp];
}


@end
