#import <Foundation/Foundation.h>
#import "_LjsGooglePlace.h"

@class LjsGoogleAddressComponent, LjsGoogleAttribution, LjsGooglePlaceType;
@class LjsGooglePlacesDetails;

@interface LjsGooglePlace : _LjsGooglePlace

+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext;

- (NSString *) latitudeString;
- (NSString *) longitudeString;
- (NSDecimalNumber *) latitudeDN;
- (NSDecimalNumber *) longitudeDN;

- (CGFloat) latitude;
- (void) setLatitude:(CGFloat) aValue;
- (CGFloat) longitude;
- (void) setLongitude:(CGFloat) aValue;
- (CGFloat) rating;
- (void) setRating:(CGFloat) aValue;
- (CGFloat) orderValue;
- (void) setOrderValue:(CGFloat) aValue;


@end


//@interface LjsGooglePlace (CoreDataGeneratedAccessors)
//
//- (void)addAddressComponentsObject:(LjsGoogleAddressComponent *)value;
//- (void)removeAddressComponentsObject:(LjsGoogleAddressComponent *)value;
//- (void)addAddressComponents:(NSSet *)values;
//- (void)removeAddressComponents:(NSSet *)values;
//
//- (void)addAttributionsObject:(LjsGoogleAttribution *)value;
//- (void)removeAttributionsObject:(LjsGoogleAttribution *)value;
//- (void)addAttributions:(NSSet *)values;
//- (void)removeAttributions:(NSSet *)values;
//
//- (void)addTypesObject:(LjsGooglePlaceType *)value;
//- (void)removeTypesObject:(LjsGooglePlaceType *)value;
//- (void)addTypes:(NSSet *)values;
//- (void)removeTypes:(NSSet *)values;
//@end
