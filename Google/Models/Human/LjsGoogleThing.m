#import "LjsGoogleThing.h"
#import "LjsGoogleLocation.h"
#import "LjsLocationManager.h"

@implementation LjsGoogleThing


- (NSString *) latitudeStringWithScale:(NSUInteger) aScale {
  return [[self latitudeWithScale:aScale] stringValue];
}

- (NSString *) longitudeStringWithScale:(NSUInteger) aScale {
  return [[self longitudeWithScale:aScale] stringValue];
}

- (NSDecimalNumber *) latitudeWithScale:(NSUInteger) aScale {
  return [self.locationEnity latitudeWithScale:aScale];
}

- (NSDecimalNumber *) longitudeWithScale:(NSUInteger) aScale {
  return [self.locationEnity longitudeWithScale:aScale];
}

- (NSDecimalNumber *) latitude {
  return [self.locationEnity latitude];
}

- (NSDecimalNumber *) longitude {
  return [self.locationEnity longitude];
}

- (NSString *) locationString {
  return [self.locationEnity locationString];
}

- (LjsLocation *) location {
  return [[LjsLocation alloc]
          initWithLatitude:self.locationEnity.latitude
          longitude:self.locationEnity.longitude];
}

@end
