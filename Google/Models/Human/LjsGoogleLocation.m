#import "LjsGoogleLocation.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"

@implementation LjsGoogleLocation

+ (LjsLocation *) initWithPoint:(CGPoint) aPoint
                          thing:(LjsGoogleThing *) aThing
                        context:(NSManagedObjectContext *) aContext {

  LjsGooglePlace *place;
  place = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                        inManagedObjectContext:aContext];
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

- (NSString *) locationStr {
  return NSStringFromLjsLocation([self location]);
}

- (NSString *) latitudeString {
  return [NSString stringWithFormat:@"%.5f", [self latitude]];
}

- (NSString *) longitudeString {
  return [NSString stringWithFormat:@"%.5f", [self longitude]];
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





@end
