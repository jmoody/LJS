#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleImporter.h"
#import "Lumberjack.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "LjsLocationManager.h"
#import "NSMutableArray+LjsAdditions.h"
#import "NSDecimalNumber+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleImporter



#pragma mark Memory Management



- (NSArray *) addressComponentsWithDictionary:(NSDictionary *) aDictionary {
  NSArray *components = [aDictionary objectForKey:@"address_components"];
  NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[components count]];
  LjsGoogleNmoAddressComponent *comp;
  for (NSDictionary *compDict in components) {
    comp = [[LjsGoogleNmoAddressComponent alloc]
            initWithDictionary:compDict];
    [marray nappend:comp];
  }
  return [NSArray arrayWithArray:marray];
}

- (LjsLocation *)  locationWithDictionary:(NSDictionary *) aDictionary {
  LjsLocation *location = [[LjsLocation alloc] 
                           initWithLatitude:[LjsDn nan]
                           longitude:[LjsDn nan]];
                                  
  NSDictionary *geometry = [aDictionary objectForKey:@"geometry"];
  if (geometry == nil) {
    // nop
  } else {
    NSDictionary *locDict = [geometry objectForKey:@"location"];
    if (locDict == nil) {
      // nop
    } else {
      location = [self locationWithLatLonDictionary:locDict];
    }
  }
  return location;
}

- (LjsLocation *) locationWithLatLonDictionary:(NSDictionary *) aLatLonDict {
  NSNumber *latNum = [aLatLonDict objectForKey:@"lat"];
  NSNumber *longNum = [aLatLonDict objectForKey:@"lng"];
  return [[LjsLocation alloc] initWithLatitudeNumber:latNum 
                                            longitudeNumber:longNum];
}



@end
