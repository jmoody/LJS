#import "LjsGoogleReverseGeocode.h"
#import "Lumberjack.h"
#import "LjsGoogleNmoReverseGeocode.h"
#import "LjsLocationManager.h"
#import "LjsGoogleBounds.h"
#import "LjsGoogleViewport.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleReverseGeocodeType.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleReverseGeocode

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                             context:(NSManagedObjectContext *) aContext {
  LjsGoogleReverseGeocode *result;
  result = [LjsGoogleReverseGeocode insertInManagedObjectContext:aContext];
  result.formattedAddress = aGeocode.formattedAddress;
  result.location = aGeocode.location;
  result.location100m = [LjsLocation locationWithLocation:aGeocode.location
                                                    scale:[LjsLocation scale100m]];
  result.locationType = aGeocode.locationType;
  
  NSDictionary *boundsDict = aGeocode.bounds;
  if (boundsDict == nil) {
    result.bounds = nil;
  } else {
    result.bounds = [LjsGoogleBounds initWithDictionary:boundsDict
                                         reverseGeocode:result
                                                context:aContext];
  }
  
  result.viewport = [LjsGoogleViewport initWithDictionary:aGeocode.viewport
                                           reverseGeocode:result
                                                  context:aContext];

  for (LjsGoogleNmoAddressComponent *comp in aGeocode.addressComponents) {
    [LjsGoogleAddressComponent initWithComponent:comp
                                           place:result
                                         context:aContext];
  }
  
  for (NSString *typeStr in aGeocode.types) {
    [LjsGoogleReverseGeocodeType findOrCreateWithName:typeStr
                                              geocode:result
                                              context:aContext];
  }

  return result;
}


@end
