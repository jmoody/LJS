#import "LjsGooglePlaceDetails.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponentPlace.h"
#import "LjsGoogleAttribution.h"
#import "LjsGooglePlaceDetailsType.h"
#import "NSDate+LjsAdditions.h"
#import "LjsGooglePlacesNmoDetails.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "LjsLocationManager.h"
#import "LjsGoogleNmoAddressComponent.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGooglePlaceDetails

+ (LjsGooglePlaceDetails *) initWithDetails:(LjsGooglePlacesNmoDetails *) aDetails
                                    context:(NSManagedObjectContext *) aContext {
  LjsGooglePlaceDetails *place;
  place = [LjsGooglePlaceDetails insertInManagedObjectContext:aContext];
  place.dateAdded = [NSDate date];
  place.dateModified = [NSDate LjsDateNotFound];
  place.orderValue = [NSDecimalNumber zero];
  
  place.formattedAddress = aDetails.formattedAddress;
  place.formattedPhone = aDetails.formattedPhoneNumber;
  place.iconUrl = aDetails.icon;
  place.internationalPhone = aDetails.internationalPhoneNumber;
  
  place.location = aDetails.location;
  
  
  place.mapUrl = aDetails.mapUrl;
  place.name = aDetails.name;
  place.rating = aDetails.rating;
  
  
  place.referenceId = aDetails.searchReferenceId;
  place.stableId = aDetails.stablePlaceId;
  
  place.vicinity = aDetails.vicinity;
  
  for (LjsGoogleNmoAddressComponent *comp in aDetails.addressComponents) {
    [LjsGoogleAddressComponentPlace initWithComponent:comp
                                                place:place
                                              context:aContext];
  }
  
  for (LjsGooglePlacesNmoAttribution *attribution in aDetails.attributions) {
    [LjsGoogleAttribution findOrCreateWithAtribution:attribution
                                               place:place
                                             context:aContext];
  }
  
  for (NSString *typeStr in aDetails.types) {
    [LjsGooglePlaceDetailsType findOrCreateWithName:typeStr
                                              place:place
                                            context:aContext];
  }
  
  return place;
}

- (NSString *) shortId {
  return [self.stableId substringToIndex:5];
}


- (NSString *) description {
  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
          self.name, self.formattedAddress, self.location];
}


- (NSString *) debugDescription {
  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
          self.name, self.formattedAddress, self.location];
}

@end
