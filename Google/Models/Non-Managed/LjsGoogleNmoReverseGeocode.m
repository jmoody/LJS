#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleNmoReverseGeocode.h"
#import "Lumberjack.h"
#import "LjsGoogleImporter.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGoogleNmoReverseGeocode ()

@property (nonatomic, strong) LjsGoogleImporter *importer;
- (NSDictionary *) viewportOrBoundsWithDictionary:(NSDictionary *) aDictionary;

@end

@implementation LjsGoogleNmoReverseGeocode

@synthesize types;
@synthesize formattedAddress;
@synthesize addressComponents;
@synthesize location;
@synthesize locationType;
@synthesize viewport;
@synthesize bounds;
@synthesize importer;

#pragma mark Memory Management

- (id) initWithDictionary:(NSDictionary *) aDictionary {
  self = [super init];
  if (self) {
    self.importer = [[LjsGoogleImporter alloc] init];
    self.types = [aDictionary objectForKey:@"types"];
    self.formattedAddress = [aDictionary objectForKey:@"formatted_address"];
    self.addressComponents = [self.importer addressComponentsWithDictionary:aDictionary];
    self.location = [self.importer locationWithDictionary:aDictionary];
    NSDictionary *geometry = [aDictionary objectForKey:@"geometry"];
    self.locationType = [geometry objectForKey:@"location_type"];
    NSDictionary *vpd = [geometry objectForKey:@"viewport"];
    self.viewport = [self viewportOrBoundsWithDictionary:vpd];
    
    NSDictionary *bd = [geometry objectForKey:@"bounds"];
    if (bd == nil) {
      self.bounds = nil;
    } else {
      self.bounds = [self viewportOrBoundsWithDictionary:bd];
    }
  }
  return self;
}


- (NSDictionary *) viewportOrBoundsWithDictionary:(NSDictionary *) aDictionary {
  NSDictionary *sw = [aDictionary objectForKey:@"southwest"];
  LjsLocation *swp = [self.importer locationWithLatLonDictionary:sw];
  NSDictionary *nw = [aDictionary objectForKey:@"northeast"];
  LjsLocation *nep = [self.importer locationWithLatLonDictionary:nw];
  NSArray *points = [NSArray arrayWithObjects:swp, nep, nil];
  NSArray *keys = [NSArray arrayWithObjects:
                   @"southwest", @"northeast", nil];
  
  return [NSDictionary dictionaryWithObjects:points
                                     forKeys:keys];
}

- (NSString *) description {
  return [NSString stringWithFormat:@"<Reverse Geo Reply: %@ : %@ - has bounds: %d>",
          self.formattedAddress, self.location, 
          self.bounds != nil];
}

@end
