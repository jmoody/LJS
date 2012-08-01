#import "_LjsGoogleReverseGeocode.h"
#import "LjsLocationManager.h"

@class LjsGoogleAddressComponent;

@interface LjsLocation (LjsLocation_LjsReverseGeocodeAdditions)

- (NSString *) key;
@end

@class LjsGoogleNmoReverseGeocode;

@interface LjsGoogleReverseGeocode : _LjsGoogleReverseGeocode {}

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                       context:(NSManagedObjectContext *) aContext;


@end


//- (NSArray *) bestPairForCityState;

//- (BOOL) hasTypeWithName:(NSString *) aName;
//- (BOOL) isStreetAddress;
//- (BOOL) isSublocality;
//- (BOOL) isLocality;
//
//
//- (NSUInteger) indexOfAddrCompInArray:(NSArray *) aArray
//                             withType:(NSString *) aType;
//- (NSUInteger) indexOfAddrCompInArray:(NSArray *) aArray
//                             withType:(NSString *) aType
//                         longNameLike:(NSString *) aString;
//
//- (BOOL) formattedAddressContainsSearchTerm:(NSString *) aSearchTerm;
//
//
//- (BOOL) containsAddrCompWithType:(NSString *) aType;
//
//
//- (LjsGoogleAddressComponent *) componentWithType:(NSString *) aType;
//- (LjsGoogleAddressComponent *) sublocality;
//- (LjsGoogleAddressComponent *) locality;
//- (LjsGoogleAddressComponent *) administrativeAreaLevel1;
//- (LjsGoogleAddressComponent *) country;
//
//
//- (LjsGoogleAddressComponent *) componentWithType:(NSString *)aType 
//                                       searchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) sublocalityWithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) localityWithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) administrativeAreaLevel1WithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) countryWithSearchTerm:(NSString *) aSearchTerm;
