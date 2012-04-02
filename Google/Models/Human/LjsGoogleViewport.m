#import "LjsGoogleViewport.h"
#import "Lumberjack.h"
#import "LjsGoogleReverseGeocode.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleViewport

+ (LjsGoogleViewport *) initWithDictionary:(NSDictionary *) aDictionary
                            reverseGeocode:(LjsGoogleReverseGeocode *) aGeocode
                                   context:(NSManagedObjectContext *) aContext {
  LjsGoogleViewport *viewport = [LjsGoogleViewport insertInManagedObjectContext:aContext];
  viewport.northeast = [aDictionary objectForKey:@"northeast"];
  viewport.southwest = [aDictionary objectForKey:@"southwest"];
  viewport.reverseGeocode = aGeocode;
  return viewport;
}

@end
