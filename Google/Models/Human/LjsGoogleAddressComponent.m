#import "LjsGoogleAddressComponent.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponentType.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleAddressComponent


- (BOOL) hasTypeWithName:(NSString *) aName {
  NSArray *types = [self.types allObjects];
  NSUInteger index;
  index = [types indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    LjsGoogleAddressComponentType *type = (LjsGoogleAddressComponentType *) obj;
    return [type.name isEqualToString:aName];
  }];
  return index != NSNotFound;
}


@end
