#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGooglePlaceDistancer.h"
#import "Lumberjack.h"
#import "LjsGooglePlaceDetails.h"
#import "LjsLocationManager.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGooglePlaceDistancer ()

@property (nonatomic, strong) LjsLocationManager *lm;

@end

@implementation LjsGooglePlaceDistancer
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

- (NSDecimalNumber *) metersBetweenPlace:(LjsGooglePlaceDetails *) aPlace 
                             andLocation:(LjsLocation *) aLocation {
  return [self.lm metersBetweenA:[aPlace location]
                               b:aLocation];
}


- (NSDecimalNumber *) metersBetweenA:(LjsGooglePlaceDetails *) a
                                   b:(LjsGooglePlaceDetails *) b {
  return [self.lm metersBetweenA:[a location]
                               b:[b location]];
}

- (NSDecimalNumber *) kilometersBetweenA:(LjsGooglePlaceDetails *) a
                                       b:(LjsGooglePlaceDetails *) b {
  return [self.lm kilometersBetweenA:[a location]
                                   b:[b location]];
}

- (NSDecimalNumber *) feetBetweenA:(LjsGooglePlaceDetails *) a 
                                 b:(LjsGooglePlaceDetails *) b {
  return [self.lm feetBetweenA:[a location]
                             b:[b location]];
}

- (NSDecimalNumber *) milesBetweenA:(LjsGooglePlaceDetails *) a
                                  b:(LjsGooglePlaceDetails *) b {
  return [self.lm milesBetweenA:[a location]
                              b:[b location]];
}

- (NSComparisonResult) compareDistanceFrom:(LjsLocation *) aLocation
                                       toA:(LjsGooglePlaceDetails *) a
                                       toB:(LjsGooglePlaceDetails *) b {
  NSDecimalNumber *fromA = [self.lm metersBetweenA:aLocation
                                                 b:[a location]];
  NSDecimalNumber *fromB = [self.lm metersBetweenA:aLocation
                                                 b:[b location]];
  
  return [fromA compare:fromB];

}
@end
