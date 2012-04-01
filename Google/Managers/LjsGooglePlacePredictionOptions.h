#import <Foundation/Foundation.h>
#import "LjsLocationManager.h"


@interface LjsGpPredictionSortOptions : NSObject

@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, assign) BOOL shouldSort;

+ (LjsGpPredictionSortOptions *) sortAscending;
+ (LjsGpPredictionSortOptions *) sortDescending;
+ (LjsGpPredictionSortOptions *) doNotSort;

@end

@interface LjsGpPredictionGoogleOptions : NSObject

@property (nonatomic, assign) BOOL shouldMakeRequest;
@property (nonatomic, assign) CGFloat radiusMeters;
@property (nonatomic, copy) NSString *langCode;
@property (nonatomic, assign) BOOL searchEstablishments;
@property (nonatomic, copy) NSString *searchString;

+ (LjsGpPredictionGoogleOptions *) optionsWithRadius:(CGFloat) aRadiusMeters
                                searchEstablishments:(BOOL) aSearchEstablishments
                                       langCodeOrNil:(NSString *) aLangCode
                                        searchString:(NSString *) aSearchString;
+ (LjsGpPredictionGoogleOptions *) doNotMakeRequest;

@end

@interface LjsGpPredicateFactory : NSObject

- (NSPredicate *) establishmentPredicateWithSearchString:(NSString *) aString;
- (NSPredicate *) nonEstablishmentPredicate;
- (NSPredicate *) nonEstablishmentPredicateWithSearchString:(NSString *) aSearchString;

@end


/**
 Documentation
 */
@interface LjsGooglePlacePredictionOptions : NSObject 

/** @name Properties */
@property (nonatomic, assign) LjsLocation *location;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) LjsGpPredictionSortOptions *sortOptions;
@property (nonatomic, strong) LjsGpPredictionGoogleOptions *googleOptions;
@property (nonatomic, assign) NSUInteger limit;


/** @name Initializing Objects */

- (id) initWithLocation:(LjsLocation *) aLocation
              predicate:(NSPredicate *) aPredicate
                  limit:(NSUInteger) aLimit
            sortOptions:(LjsGpPredictionSortOptions *) aSortOptions
          googleOptions:(LjsGpPredictionGoogleOptions *) aGoogleOptions;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

@end
