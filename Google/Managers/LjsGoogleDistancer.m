#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleDistancer.h"
#import "Lumberjack.h"
#import "LjsGooglePlace.h"
#import "LjsLocationManager.h"
#import "LjsGoogleReverseGeocode.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGoogleDistancer ()

@property (nonatomic, strong) LjsLocationManager *lm;

@end

@implementation LjsGoogleDistancer
@synthesize lm;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithLocationManager:(LjsLocationManager *) aManager {
  self = [super init];
  if (self != nil) {
    self.lm = aManager;
  }
  return self;
}

- (NSDecimalNumber *) metersBetweenPlace:(LjsGooglePlace *) aPlace 
                             andLocation:(LjsLocation *) aLocation {
  return [self.lm metersBetweenA:[aPlace location]
                               b:aLocation];
}


- (NSDecimalNumber *) metersBetweenPlaceA:(LjsGooglePlace *) a
                                   placeB:(LjsGooglePlace *) b {
  return [self.lm metersBetweenA:[a location]
                               b:[b location]];
}

- (NSDecimalNumber *) kilometersBetweenPlaceA:(LjsGooglePlace *) a
                                       placeB:(LjsGooglePlace *) b {
  return [self.lm kilometersBetweenA:[a location]
                                   b:[b location]];
}

- (NSDecimalNumber *) feetBetweenPlaceA:(LjsGooglePlace *) a 
                                 placeB:(LjsGooglePlace *) b {
  return [self.lm feetBetweenA:[a location]
                             b:[b location]];
}

- (NSDecimalNumber *) milesBetweenPlaceA:(LjsGooglePlace *) a
                                  placeB:(LjsGooglePlace *) b {
  return [self.lm milesBetweenA:[a location]
                              b:[b location]];
}

- (NSComparisonResult) compareDistanceFromLocation:(LjsLocation *) aLocation
                                       toPlaceA:(LjsGooglePlace *) a
                                       toPlaceB:(LjsGooglePlace *) b {
  NSDecimalNumber *fromA = [self.lm metersBetweenA:aLocation
                                                 b:[a location]];
  NSDecimalNumber *fromB = [self.lm metersBetweenA:aLocation
                                                 b:[b location]];
  
  return [fromA compare:fromB];

}

- (NSComparisonResult) compareDistanceFromLocation:(LjsLocation *) aLocation
                                        toGeocodeA:(LjsGoogleReverseGeocode *) a
                                        toGeocodeB:(LjsGoogleReverseGeocode *) b {
  
  NSDecimalNumber *fromA = [self.lm metersBetweenA:aLocation
                                                 b:[a location]];
  NSDecimalNumber *fromB = [self.lm metersBetweenA:aLocation
                                                 b:[b location]];
  return [fromA compare:fromB];
}

@end
