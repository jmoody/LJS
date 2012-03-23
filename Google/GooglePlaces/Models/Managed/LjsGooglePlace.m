#import "LjsGooglePlace.h"
#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleAttribution.h"
#import "LjsGooglePlaceType.h"
#import "NSDate+LjsAdditions.h"
#import "LjsGooglePlacesDetails.h"


@implementation LjsGooglePlace

@dynamic dateAdded;
@dynamic dateModified;
@dynamic formattedAddress;
@dynamic formattedPhone;
@dynamic iconUrl;
@dynamic internationalPhone;
@dynamic latitudeNumber;
@dynamic longitudeNumber;
@dynamic mapUrl;
@dynamic name;
@dynamic ratingNumber;
@dynamic referenceId;
@dynamic stableId;
@dynamic vicinity;
@dynamic website;
@dynamic addressComponents;
@dynamic attributions;
@dynamic types;
@dynamic orderValueNumber;

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
  place.stableId = aDetails.searchReferenceId;
  
  place.vicinity = aDetails.vicinity;
  
  for (LjsGooglePlacesNmoAddressComponent *comp in aDetails.addressComponents) {
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



@end
