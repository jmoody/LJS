#import "LjsGooglePlace.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleAttribution.h"
#import "LjsGooglePlaceType.h"
#import "NSDate+LjsAdditions.h"
#import "LjsGooglePlacesDetails.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


//@implementation LjsGoogleComparablePlace 
//
//@synthesize distance;
//@synthesize place;
//
//- (id) initWithPlace:(LjsGooglePlace *) aPlace
//            location:(LjsLocation) aLocation {
//  self = [super init];
//  if (self != nil) {
//    self.place = aPlace;
//    self.distance = [[LjsDn dnWithFloat:[aPlace metersFromLocation:aLocation]] dnByRoundingAsLocation];
//    DDLogDebug(@"location:  %@", NSStringFromLjsLocation(aLocation));
//    DDLogDebug(@"  float:  %.5f", [aPlace metersFromLocation:aLocation]);
//    DDLogDebug(@"     dn:  %@", [LjsDn dnWithFloat:[aPlace metersFromLocation:aLocation]]);
//    DDLogDebug(@"  round:  %@", self.distance);
//    
//    
//  }
//  return self;
//}
//
//
//@end

//@interface LjsGooglePlaceLocation ()
//
//- (id) initWithPlace:(LjsGooglePlace *) aPlace;
//@property (nonatomic, assign) LjsLocation loc;
//@end
//
//@implementation LjsGooglePlaceLocation
//@synthesize loc;
//- (id) initWithPlace:(LjsGooglePlace *)aPlace {
//  self = [super init];
//  if (self != nil) {
//    self.loc = [aPlace location];
//  }
//  return self;
//}
//
//- (LjsLocation) location {
//  return self.loc;
//}
//@end

@implementation LjsGooglePlace


+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext {
  NSString *entityName = [NSString stringWithFormat:@"%@", [self class]];
  LjsGooglePlace *place;
  place = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                        inManagedObjectContext:aContext];
  place.dateAdded = [NSDate date];
  place.dateModified = [NSDate LjsDateNotFound];
  
  place.formattedAddress = aDetails.formattedAddress;
  place.formattedPhone = aDetails.formattedPhoneNumber;
  place.iconUrl = aDetails.icon;
  place.internationalPhone = aDetails.internationalPhoneNumber;

  
  [place setLatitude:aDetails.location.x];
  [place setLongitude:aDetails.location.y];
  
  place.mapUrl = aDetails.mapUrl;
  place.name = aDetails.name;
  [place setRating:aDetails.rating];
  
  place.referenceId = aDetails.searchReferenceId;
  place.stableId = aDetails.stablePlaceId;
  
  place.vicinity = aDetails.vicinity;
  
  for (LjsGoogleNmoAddressComponent *comp in aDetails.addressComponents) {
    [LjsGoogleAddressComponent initWithComponent:comp
                                           place:place
                                         context:aContext];
  }
   
  for (LjsGooglePlacesNmoAttribution *attribution in aDetails.attributions) {
    [LjsGoogleAttribution findOrCreateWithAtribution:attribution
                                               place:place
                                             context:aContext];
  }
  
  for (NSString *typeStr in aDetails.types) {
    [LjsGooglePlaceType findOrCreateWithName:typeStr
                                       place:place
                                     context:aContext];
  }
  
  return place;
}



- (CGFloat) rating {
  return [self.ratingNumber doubleValue];
}

- (void) setRating:(CGFloat) aValue {
  self.ratingNumber = [NSNumber numberWithDouble:aValue];
}

- (CGFloat) orderValue {
  return [self.orderValueNumber doubleValue];
}

- (void) setOrderValue:(CGFloat) aValue {
  self.orderValueNumber = [NSNumber numberWithDouble:aValue];
}


- (NSString *) shortId {
  return [self.stableId substringToIndex:5];
}

//- (LjsLocation) location {
//  return LjslocationMake([self.location latitude], [self.location longitude]);
//}
//
//- (NSString *) locationStr {
//  return NSStringFromLjsLocation([self location]);
//}
//
//- (NSString *) latitudeString {
//  return [NSString stringWithFormat:@"%.5f", [self.location latitude]];
//}
//
//- (NSString *) longitudeString {
//  return [NSString stringWithFormat:@"%.5f", [self.location longitude]];
//}
//
//- (NSDecimalNumber *) latitudeDN {
//  return [[LjsDn dnWithNumber:self.location.latitudeNumber] dnByRoundingAsLocation];
//}
//
//- (NSDecimalNumber *) longitudeDN {
//  return [[LjsDn dnWithNumber:self.location.longitudeNumber] dnByRoundingAsLocation];
//}
//


//- (NSString *) description {
//  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
//          self.name, self.formattedAddress, [self locationStr]];
//}
//
//
//- (NSString *) debugDescription {
//  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
//          self.name, self.formattedAddress, [self locationStr]];
//}


@end
