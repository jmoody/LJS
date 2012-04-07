#import "LjsGoogleBounds.h"
#import "Lumberjack.h"
#import "LjsGoogleReverseGeocode.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsGoogleBounds

+ (LjsGoogleBounds *) initWithDictionary:(NSDictionary *) aDictionary
                          reverseGeocode:(LjsGoogleReverseGeocode *) aGeocode
                                 context:(NSManagedObjectContext *) aContext {
  LjsGoogleBounds *bounds = [LjsGoogleBounds insertInManagedObjectContext:aContext];
  bounds.northeast = [aDictionary objectForKey:@"northeast"];
  bounds.southwest = [aDictionary objectForKey:@"southwest"];
  bounds.reverseGeocode = aGeocode;
  return bounds;
}

@end
