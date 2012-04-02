#import "LjsGoogleReverseGeocode.h"
#import "Lumberjack.h"
#import "LjsGoogleNmoReverseGeocode.h"
#import "LjsLocationManager.h"
#import "LjsGoogleBounds.h"
#import "LjsGoogleViewport.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "LjsGoogleAddressComponentGeocode.h"
#import "LjsGoogleReverseGeocodeType.h"
#import "NSDate+LjsAdditions.h"
#import "LjsDn.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsLocation (LjsLocation_LjsReverseGeocodeAdditions)

- (NSString *) key {
  LjsLocation *loc = [LjsLocation locationWithLocation:self scale:[LjsLocation scale1m]];
  return [NSString stringWithFormat:@"%@,%@", loc.latitude, loc.longitude];
}

@end

@implementation LjsGoogleReverseGeocode

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                             context:(NSManagedObjectContext *) aContext {
  LjsGoogleReverseGeocode *result;
  result = [LjsGoogleReverseGeocode insertInManagedObjectContext:aContext];
  result.formattedAddress = aGeocode.formattedAddress;
  result.dateAdded = [NSDate date];
  result.dateModified = [NSDate LjsDateNotFound];
  result.orderValue = [LjsDn zero];
  
  result.location = aGeocode.location;
  LjsLocation *location100m = [LjsLocation locationWithLocation:aGeocode.location
                                                          scale:[LjsLocation scale100m]];
  result.location100m = location100m;
  result.latitude100m = location100m.latitude;
  result.longitude100m = location100m.longitude;
  
  result.key = [aGeocode.location key];
  
  LjsLocation *location1k = [LjsLocation locationWithLocation:aGeocode.location
                                                        scale:[LjsLocation scale1km]];
  result.latitude1km = location1k.latitude;
  result.longitude1km = location1k.longitude;
  
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
    [LjsGoogleAddressComponentGeocode initWithComponent:comp
                                                 gecode:result
                                                context:aContext];
  }
  
  for (NSString *typeStr in aGeocode.types) {
    [LjsGoogleReverseGeocodeType findOrCreateWithName:typeStr
                                              geocode:result
                                              context:aContext];
  }

  return result;
}



- (NSString *) description {
  return [NSString stringWithFormat:@"#<Geocode: %@ %@ %@>",
          self.location100m, self.formattedAddress, self.locationType];
}

- (NSString *) debugDescription {
  return [NSString stringWithFormat:@"#<Geocode: %@ %@ %@>",
          self.location100m, self.formattedAddress, self.locationType];  
}
@end
