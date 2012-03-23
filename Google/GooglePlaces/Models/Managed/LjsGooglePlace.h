#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LjsGoogleAddressComponent, LjsGoogleAttribution, LjsGooglePlaceType;
@class LjsGooglePlacesDetails;

@interface LjsGooglePlace : NSManagedObject

@property (nonatomic, strong) NSDate * dateAdded;
@property (nonatomic, strong) NSDate * dateModified;
@property (nonatomic, strong) NSString * formattedAddress;
@property (nonatomic, strong) NSString * formattedPhone;
@property (nonatomic, strong) NSString * iconUrl;
@property (nonatomic, strong) NSString * internationalPhone;
@property (nonatomic, strong) NSNumber * latitudeNumber;
@property (nonatomic, strong) NSNumber * longitudeNumber;
@property (nonatomic, strong) NSString * mapUrl;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * ratingNumber;
@property (nonatomic, strong) NSString * referenceId;
@property (nonatomic, strong) NSString * stableId;
@property (nonatomic, strong) NSString * vicinity;
@property (nonatomic, strong) NSString * website;
@property (nonatomic, strong) NSNumber *orderValueNumber;
@property (nonatomic, strong) NSSet *addressComponents;
@property (nonatomic, strong) NSSet *attributions;
@property (nonatomic, strong) NSSet *types;

+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext;

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
