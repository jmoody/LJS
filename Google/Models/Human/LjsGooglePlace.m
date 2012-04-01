#import "LjsGooglePlace.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleAttribution.h"
#import "LjsGooglePlaceType.h"
#import "LjsGoogleLocation.h"
#import "NSDate+LjsAdditions.h"
#import "LjsGooglePlacesDetails.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGooglePlace


+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext {
  LjsGooglePlace *place;
  place = [LjsGooglePlace insertInManagedObjectContext:aContext];
  place.dateAdded = [NSDate date];
  place.dateModified = [NSDate LjsDateNotFound];
  
  place.formattedAddress = aDetails.formattedAddress;
  place.formattedPhone = aDetails.formattedPhoneNumber;
  place.iconUrl = aDetails.icon;
  place.internationalPhone = aDetails.internationalPhoneNumber;


  CGPoint loc = aDetails.location;
  // sets the relationship
  [LjsGoogleLocation initWithPoint:loc
                              type:nil
                             thing:place
                           context:aContext];
  

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

- (NSString *) shortId {
  return [self.stableId substringToIndex:5];
}



- (NSString *) description {
  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
          self.name, self.formattedAddress, [self locationString]];
}


- (NSString *) debugDescription {
  return [NSString stringWithFormat:@"#<Place: %@: %@ %@>",
          self.name, self.formattedAddress, [self locationString]];
}


@end
