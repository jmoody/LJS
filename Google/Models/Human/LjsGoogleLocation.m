#import "LjsGoogleLocation.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "LjsGoogWithLoc.h"

@implementation LjsGoogleLocation

+ (LjsGoogleLocation *) initWithLocation:(LjsLocation *)aLocation
                                    type:(NSString *) aType
                                  owner:(LjsGoogWithLoc *) aOwner
                                 context:(NSManagedObjectContext *) aContext {
  
  LjsGoogleLocation *location = [LjsGoogleLocation insertInManagedObjectContext:aContext];
  location.latitude = aLocation.latitude;
  location.longitude = aLocation.longitude;
  
  location.latitude100km = [location latitudeWithScale:0];
  location.latitude10km = [location latitudeWithScale:1];
  location.latitude1km = [location latitudeWithScale:2];
  location.latitude100m = [location latitudeWithScale:3];
  location.latitude10m = [location latitudeWithScale:4];
  location.latitude1m = [location latitudeWithScale:5];
  
  location.longitude100km = [location longitudeWithScale:0];
  location.longitude10km = [location longitudeWithScale:1];
  location.longitude1km = [location longitudeWithScale:2];
  location.longitude100m = [location longitudeWithScale:3];
  location.longitude10m = [location longitudeWithScale:4];
  location.longitude1m = [location longitudeWithScale:5];


  location.type = aType;
  location.owner = aOwner;
  return location;
}


- (NSString *) locationString {
  return [NSString stringWithFormat:@"(%@, %@)", self.latitude, self.longitude];
}

- (NSString *) latitudeStringWithScale:(NSUInteger) aScale {
  return [[self latitudeWithScale:aScale] stringValue];
}

- (NSString *) longitudeStringWithScale:(NSUInteger) aScale {
  return [[self longitudeWithScale:aScale] stringValue];
}

- (NSDecimalNumber *) latitudeWithScale:(NSUInteger) aScale {
  return [[LjsDn dnWithNumber:self.latitude] dnByRoundingWithScale:aScale];
}

- (NSDecimalNumber *) longitudeWithScale:(NSUInteger) aScale {
  return [[LjsDn dnWithNumber:self.longitude] dnByRoundingWithScale:aScale];
}

- (NSString *) description {
  if (self.type == nil) {
    return [NSString stringWithFormat:@"#<Location %@>", [self locationString]];
  } else {
    return [NSString stringWithFormat:@"#<Location %@ %@>", [self locationString],
            self.type];
  }
}

- (NSString *) debugDescription {
  if (self.type == nil) {
    return [NSString stringWithFormat:@"#<Location %@>", [self locationString]];
  } else {
    return [NSString stringWithFormat:@"#<Location %@ %@>", [self locationString],
            self.type];
  }
}


@end
