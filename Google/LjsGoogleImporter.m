#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleImporter.h"
#import "Lumberjack.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "NSMutableArray+LjsAdditions.h"
#import "LjsLocationManager.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "LjsDn.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleImporter



#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}


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

- (CGPoint) pointForLocationWithDictionary:(NSDictionary *) aDictionary {
  CGPoint location;
  NSDictionary *geometry = [aDictionary objectForKey:@"geometry"];
  if (geometry == nil) {
    location = CGPointMake(LjsLocationDegreesNotFound, LjsLocationDegreesNotFound);
  } else {
    NSDictionary *locDict = [geometry objectForKey:@"location"];
    if (locDict == nil) {
      location = CGPointMake(LjsLocationDegreesNotFound, LjsLocationDegreesNotFound);
    } else {
      location = [self pointWithLatLonDictionary:locDict];
    }
  }
  return location;
}

- (CGPoint) pointWithLatLonDictionary:(NSDictionary *) aLatLonDict {
  DDLogDebug(@"a lat long dict = %@", aLatLonDict);
  NSNumber *latNum = [aLatLonDict objectForKey:@"lat"];
  NSNumber *longNum = [aLatLonDict objectForKey:@"lng"];
  return CGPointMake([latNum doubleValue], [longNum doubleValue]);
}



@end
