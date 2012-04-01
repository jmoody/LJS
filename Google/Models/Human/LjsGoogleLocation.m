#import "LjsGoogleLocation.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "LjsGoogleThing.h"

@implementation LjsGoogleLocation

+ (LjsGoogleLocation *) initWithPoint:(CGPoint) aPoint
                                 type:(NSString *) aType
                                thing:(LjsGoogleThing *) aThing
                              context:(NSManagedObjectContext *) aContext {
  
  LjsGoogleLocation *location = [LjsGoogleLocation insertInManagedObjectContext:aContext];
  [location setLatitude:aPoint.x];
  [location setLongitude:aPoint.y];
  location.type = aType;
  location.thing = aThing;
  return location;
}


- (CGFloat) latitude {
  return [self.latitudeNumber doubleValue];
}

- (void) setLatitude:(CGFloat) aValue {
  self.latitudeNumber = [NSNumber numberWithDouble:aValue];
}

- (CGFloat) longitude {
  return [self.longitudeNumber doubleValue];
}

- (void) setLongitude:(CGFloat) aValue {
  self.longitudeNumber = [NSNumber numberWithDouble:aValue];
}

- (LjsLocation) location {
  return LjslocationMake([self latitude], [self longitude]);
}

- (NSString *) locationString {
  return NSStringFromLjsLocation([self location]);
}

- (NSString *) latitudeStringWithScale:(NSUInteger) aScale {
  return [[self latitudeDnWithScale:aScale] stringValue];
}

- (NSString *) longitudeStringWithScale:(NSUInteger) aScale {
  return [[self longitudeDnWithScale:aScale] stringValue];
}

- (NSDecimalNumber *) latitudeDnWithScale:(NSUInteger) aScale {
  return [[LjsDn dnWithNumber:self.latitudeNumber] dnByRoundingWithScale:aScale];
}

- (NSDecimalNumber *) longitudeDnWithScale:(NSUInteger) aScale {
  return [[LjsDn dnWithNumber:self.longitudeNumber] dnByRoundingWithScale:aScale];
}

- (NSDecimalNumber *) latitudeDN {
  return [[LjsDn dnWithNumber:self.latitudeNumber] dnByRoundingAsLocation];
}

- (NSDecimalNumber *) longitudeDN {
  return [[LjsDn dnWithNumber:self.longitudeNumber] dnByRoundingAsLocation];
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
