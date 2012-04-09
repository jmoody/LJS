#import "LjsGoogleReverseGeocode.h"
#import "Lumberjack.h"
#import "LjsGoogleNmoReverseGeocode.h"
#import "LjsLocationManager.h"
#import "LjsGoogleBounds.h"
#import "LjsGoogleViewport.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "LjsGoogleAddressComponentGeocode.h"
#import "LjsGoogleReverseGeocodeType.h"
#import "NSDate+LjsAdditions.h"
#import "LjsDn.h"
#import "NSArray+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsLocation (LjsLocation_LjsReverseGeocodeAdditions)

- (NSString *) key {
  LjsLocation *loc = [LjsLocation locationWithLocation:self scale:[LjsLocation scale1m]];
  return [NSString stringWithFormat:@"%@,%@", loc.latitude, loc.longitude];
}

@end

@implementation LjsGoogleReverseGeocode

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                             context:(NSManagedObjectContext *) aContext {
  LjsGoogleReverseGeocode *result;
  result = [LjsGoogleReverseGeocode insertInManagedObjectContext:aContext];
  result.formattedAddress = aGeocode.formattedAddress;
  result.dateAdded = [NSDate date];
  result.dateModified = [NSDate LjsDateNotFound];
  result.orderValue = [LjsDn zero];
  
  result.location = aGeocode.location;
  LjsLocation *location100m = [LjsLocation locationWithLocation:aGeocode.location
                                                          scale:[LjsLocation scale100m]];
  result.location100m = location100m;
  result.latitude100m = location100m.latitude;
  result.longitude100m = location100m.longitude;
  
  LjsLocation *location10m = [LjsLocation locationWithLocation:aGeocode.location
                                                         scale:[LjsLocation scale10m]];
  result.location10m = location10m;
  result.latitude10m = location10m.latitude;
  result.location10m = location10m.longitude;
  
  LjsLocation *location1m = [LjsLocation locationWithLocation:aGeocode.location
                                                        scale:[LjsLocation scale1m]];
  result.location1m = location1m;
  result.latitude1m = location1m.latitude;
  result.location1m = location1m.longitude;
  
  result.key = [aGeocode.location key];
  
  LjsLocation *location1k = [LjsLocation locationWithLocation:aGeocode.location
                                                        scale:[LjsLocation scale1km]];
  result.latitude1km = location1k.latitude;
  result.longitude1km = location1k.longitude;
  
  result.locationType = aGeocode.locationType;
  
  NSDictionary *boundsDict = aGeocode.bounds;
  if (boundsDict == nil) {
    result.bounds = nil;
  } else {
    result.bounds = [LjsGoogleBounds initWithDictionary:boundsDict
                                         reverseGeocode:result
                                                context:aContext];
  }
  
  result.viewport = [LjsGoogleViewport initWithDictionary:aGeocode.viewport
                                           reverseGeocode:result
                                                  context:aContext];

  for (LjsGoogleNmoAddressComponent *comp in aGeocode.addressComponents) {
    [LjsGoogleAddressComponentGeocode initWithComponent:comp
                                                 gecode:result
                                                context:aContext];
  }
  
  for (NSString *typeStr in aGeocode.types) {
    [LjsGoogleReverseGeocodeType findOrCreateWithName:typeStr
                                              geocode:result
                                              context:aContext];
  }

  return result;
}


- (NSString *) description {
  return [NSString stringWithFormat:@"#<Geocode: %@ %@ %@>",
          self.location100m, self.formattedAddress, self.locationType];
}

- (NSString *) debugDescription {
  return [NSString stringWithFormat:@"#<Geocode: %@ %@ %@>",
          self.location100m, self.formattedAddress, self.locationType];  
}
@end

//- (BOOL) hasTypeWithName:(NSString *) aName {
//  NSArray *types = [self.types allObjects];
//  NSUInteger index;
//  index = [types indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    LjsGoogleReverseGeocodeType *type = (LjsGoogleReverseGeocodeType *) obj;
//    return [type.name isEqualToString:aName];
//  }];
//  return index != NSNotFound;
//}
//
//- (BOOL) isSublocality {
//  return [self hasTypeWithName:@"sublocality"];
//}
//
//- (BOOL) isLocality {
//  return [self hasTypeWithName:@"locality"];
//}
//
//- (BOOL) isStreetAddress {
//  return [self hasTypeWithName:@"street_address"];
//}
//
//
//- (NSUInteger) indexOfAddrCompInArray:(NSArray *) aArray
//                             withType:(NSString *) aType {
//  NSUInteger index;
//  index = [aArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    LjsGoogleAddressComponent *comp = (LjsGoogleAddressComponent *) obj;
//    return [comp hasTypeWithName:aType];
//  }];
//  return index;
//}
//
//- (NSUInteger) indexOfAddrCompInArray:(NSArray *) aArray
//                             withType:(NSString *) aType
//                         longNameLike:(NSString *) aString {
//  NSPredicate *predicate;
//  NSPredicate *typePred = [NSPredicate predicateWithFormat:@"ANY types.name == %@",
//                           aType];
//  NSPredicate *strPred = [NSPredicate predicateWithFormat:@"longName CONTAINS[cd] %@",
//                          aString];
//  NSArray *preds = [NSArray arrayWithObjects:typePred, strPred, nil];
//  predicate = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
//
//  NSUInteger index;
//  index = [aArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    return [predicate evaluateWithObject:obj];
//  }];
//  
//  return index;
//}
//
//- (BOOL) formattedAddressContainsSearchTerm:(NSString *) aSearchTerm {
//  NSRange range;
//  NSUInteger options = NSCaseInsensitiveSearch | NSAnchoredSearch |
//  NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch;
//  range = [self.formattedAddress rangeOfString:aSearchTerm
//                                       options:options];
//  return range.length > 0;
//}
//
//- (BOOL) containsAddrCompWithType:(NSString *) aType {
//  NSArray *array = [self.addressComponents allObjects];
//  return [self indexOfAddrCompInArray:array withType:aType] != NSNotFound;
//}
//
//- (LjsGoogleAddressComponent *) componentWithType:(NSString *) aType {
//  LjsGoogleAddressComponent *result = nil;
//  NSArray *comps = [self.addressComponents allObjects];
//  NSUInteger index = [self indexOfAddrCompInArray:comps
//                                         withType:aType];
//  if (index != NSNotFound) {
//    result = [comps nth:index];
//  }
//  return result;
//}
//
//- (LjsGoogleAddressComponent *) sublocality {
//  return [self componentWithType:@"sublocality"];
//}
//
//- (LjsGoogleAddressComponent *) locality {
//  return [self componentWithType:@"locality"];
//}
//
//- (LjsGoogleAddressComponent *) administrativeAreaLevel1 {
//  return [self componentWithType:@"administrative_area_level_1"];
//}
//
//- (LjsGoogleAddressComponent *) country {
//  return [self componentWithType:@"country"];
//}
//
//- (LjsGoogleAddressComponent *) componentWithType:(NSString *)aType 
//                                       searchTerm:(NSString *) aSearchTerm {
//  LjsGoogleAddressComponent *result = nil;
//  NSArray *comps = [self.addressComponents allObjects];
//  NSUInteger index = [self indexOfAddrCompInArray:comps
//                                         withType:aType
//                                     longNameLike:aSearchTerm];
//  if (index != NSNotFound) {
//    result = [comps nth:index];
//  }
//  return result;
//}
//
//- (LjsGoogleAddressComponent *) sublocalityWithSearchTerm:(NSString *) aSearchTerm {
//  return [self componentWithType:@"sublocality" searchTerm:aSearchTerm];
//}
//
//- (LjsGoogleAddressComponent *) localityWithSearchTerm:(NSString *) aSearchTerm {
//  return [self componentWithType:@"locality" searchTerm:aSearchTerm];
//}
//
//- (LjsGoogleAddressComponent *) administrativeAreaLevel1WithSearchTerm:(NSString *) aSearchTerm {
//  return [self componentWithType:@"administrative_area_level_1" searchTerm:aSearchTerm];
//}
//- (LjsGoogleAddressComponent *) countryWithSearchTerm:(NSString *) aSearchTerm {
//  return [self componentWithType:@"country" searchTerm:aSearchTerm];
//}
//
//
//
//
//- (NSArray *) bestPairForCityState {
//  NSMutableArray *result = [NSMutableArray arrayWithCapacity:2];
//  LjsGoogleAddressComponent *cityComp = nil;
//  LjsGoogleAddressComponent *stateComp = nil;
//  
//  cityComp = [self sublocality];
//  if (cityComp != nil) {
//    stateComp = [self locality];
//    if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//      stateComp = [self administrativeAreaLevel1];
//      if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//        stateComp = [self country];
//        if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//          return result;
//        }
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [self locality];
//  if (cityComp != nil) {
//    stateComp = [self administrativeAreaLevel1];
//    if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//      stateComp = [self country];
//      if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//        return result;
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [self administrativeAreaLevel1];
//  if (cityComp != nil) {
//    stateComp = [self country];
//    if (stateComp == nil || [stateComp.longName isEqualToString:cityComp.longName]) {
//      return result;
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  return result;
//}

