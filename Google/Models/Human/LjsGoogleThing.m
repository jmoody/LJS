#import "LjsGoogleThing.h"
#import "LjsGoogleLocation.h"

@implementation LjsGoogleThing


- (CGFloat) orderValue {
  return [self.orderValueNumber doubleValue];
}

- (void) setOrderValue:(CGFloat) aValue {
  self.orderValueNumber = [NSNumber numberWithDouble:aValue];
}

- (LjsLocation) location {
  return [self.locationEnity location];
}

- (NSString *) latitudeStringWithScale:(NSUInteger) aScale {
  return [[self latitudeDnWithScale:aScale] stringValue];
}

- (NSString *) longitudeStringWithScale:(NSUInteger) aScale {
  return [[self longitudeDnWithScale:aScale] stringValue];
}

- (NSDecimalNumber *) latitudeDnWithScale:(NSUInteger) aScale {
  return [self.locationEnity latitudeDnWithScale:aScale];
}

- (NSDecimalNumber *) longitudeDnWithScale:(NSUInteger) aScale {
  return [self.locationEnity longitudeDnWithScale:aScale];
}

- (NSDecimalNumber *) latitudeDN {
  return [self.locationEnity latitudeDN];
}

- (NSDecimalNumber *) longitudeDN {
  return [self.locationEnity longitudeDN];
}

- (NSString *) locationString {
  return [self.locationEnity locationString];
}


@end
