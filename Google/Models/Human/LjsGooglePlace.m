#import "LjsGooglePlace.h"
#import "LjsLocationManager.h"

@implementation LjsGooglePlace

- (LjsLocation *) locationWithScale:(NSUInteger) aScale {
  return [LjsLocation locationWithLocation:self.location
                                     scale:aScale];
}

@end
