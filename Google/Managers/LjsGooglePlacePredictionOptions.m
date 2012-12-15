#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGooglePlacePredictionOptions.h"
#import "Lumberjack.h"
#import "NSMutableArray+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGpPredictionSortOptions ()
- (id) initWithShouldSort:(BOOL) aShouldSort
            sortAscending:(BOOL) aSortAscending;

@end
@implementation LjsGpPredictionSortOptions

@synthesize shouldSort;
@synthesize ascending;

- (id) initWithShouldSort:(BOOL) aShouldSort
            sortAscending:(BOOL) aSortAscending {
  self = [super init];
  if (self != nil) {
    self.shouldSort = aShouldSort;
    self.ascending = aSortAscending;
  }
  return self;
}

+ (LjsGpPredictionSortOptions *) sortAscending {
  return [[LjsGpPredictionSortOptions alloc]
          initWithShouldSort:YES
          sortAscending:YES];
}

+ (LjsGpPredictionSortOptions *) sortDescending {
  return [[LjsGpPredictionSortOptions alloc]
          initWithShouldSort:YES
          sortAscending:NO];
}

+ (LjsGpPredictionSortOptions *) doNotSort {
  return [[LjsGpPredictionSortOptions alloc]
          initWithShouldSort:NO
          sortAscending:NO];
}

@end


@interface LjsGpPredictionGoogleOptions ()

- (id) initWithShouldMakeRequest:(BOOL) aShouldMakeRequest
                          radius:(CGFloat) aRadiusMeters
            searchEstablishments:(BOOL) aSearchEstablishments
                  langCodesOrNil:(NSArray *) aLangCodes
                    searchString:(NSString *) aSearchStrin;

@end

@implementation LjsGpPredictionGoogleOptions

@synthesize shouldMakeRequest;
@synthesize radiusMeters;
@synthesize searchEstablishments;
@synthesize langCodes;
@synthesize searchString;

- (id) initWithShouldMakeRequest:(BOOL) aShouldMakeRequest
                          radius:(CGFloat) aRadiusMeters
            searchEstablishments:(BOOL) aSearchEstablishments
                  langCodesOrNil:(NSArray *) aLangCodes
                    searchString:(NSString *) aSearchString {
  self = [super init];
  if (self) {
    self.shouldMakeRequest = aShouldMakeRequest;
    self.radiusMeters = aRadiusMeters;
    self.searchEstablishments = aSearchEstablishments;
    self.langCodes = aLangCodes;
    self.searchString = aSearchString;
  }
  return self;
}


+ (LjsGpPredictionGoogleOptions *) optionsWithRadius:(CGFloat) aRadiusMeters
                                searchEstablishments:(BOOL) aSearchEstablishments
                                       langCodesOrNil:(NSArray *) aLangCodes
                                        searchString:(NSString *) aSearchString {
  return [[LjsGpPredictionGoogleOptions alloc]
          initWithShouldMakeRequest:YES
          radius:aRadiusMeters
          searchEstablishments:aSearchEstablishments
          langCodesOrNil:aLangCodes
          searchString:aSearchString];
}

+ (LjsGpPredictionGoogleOptions *) doNotMakeRequest {
  return [[LjsGpPredictionGoogleOptions alloc]
          initWithShouldMakeRequest:NO
          radius:CGFLOAT_MIN
          searchEstablishments:NO
          langCodesOrNil:nil
          searchString:nil];
}


@end

@interface LjsGpPredicateFactory ()

@property (nonatomic, strong) NSSet *nonEstablishments;

@end

@implementation LjsGpPredicateFactory
@synthesize nonEstablishments;

- (id) init {
  self = [super init];
  if (self) {
    self.nonEstablishments = [NSSet setWithObjects:@"locality", 
                              @"country",
                              @"route",
                              @"colloquial_area",
                              @"administrative_area_level_1",
                              @"neighborhood",
                              @"administrative_area_level_2",
                              @"sublocality",
                              @"park",
                              @"airport",
                              @"transit_station",
                              @"train_station",
                              @"sublocality_level_2",
                              @"administrative_area_level_3",
                              @"subway_station", nil];
  }
  return self;
}

- (NSPredicate *) establishmentPredicateWithSearchString:(NSString *)aString {
  NSArray *tokens = [aString componentsSeparatedByString:@" "];
  NSMutableArray *preds = [NSMutableArray arrayWithCapacity:[tokens count]];
  NSPredicate *predicate;
  for (NSString *token in tokens) {
    predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@ OR vicinity CONTAINS[cd] %@) AND ANY types.name == 'establishment'",
                 token, tokens];
    [preds push:predicate];
  }
  NSPredicate *result = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
  return result;
}

- (NSPredicate *) nonEstablishmentPredicate {
  return [NSPredicate predicateWithFormat:@"ANY types.name IN %@",
          [self nonEstablishments]];
}



- (NSPredicate *) nonEstablishmentPredicateWithSearchString:(NSString *) aSearchString {
  NSArray *tokens = [aSearchString componentsSeparatedByString:@" "];
  NSMutableArray *preds = [NSMutableArray arrayWithCapacity:[tokens count]];
  NSPredicate *subs;
  for (NSString *token in tokens) {
    subs = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@ OR vicinity CONTAINS[cd] %@)",
            token, tokens];
    [preds push:subs];
  }
  NSPredicate *ors = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
  NSArray *ands = [NSArray arrayWithObjects:ors, [self nonEstablishmentPredicate], nil];
  NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:ands];
  return predicate;
}

@end


@interface LjsGooglePlacePredictionOptions ()


@end

@implementation LjsGooglePlacePredictionOptions

@synthesize location;
@synthesize predicate;
@synthesize limit;
@synthesize sortOptions;
@synthesize googleOptions;



#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithLocation:(LjsLocation *) aLocation
              predicate:(NSPredicate *) aPredicate
                  limit:(NSUInteger) aLimit
            sortOptions:(LjsGpPredictionSortOptions *) aSortOptions
          googleOptions:(LjsGpPredictionGoogleOptions *) aGoogleOptions {
  self = [super init];
  if (self) {
    self.location = aLocation;
    self.predicate = aPredicate;
    self.limit = aLimit;
    self.sortOptions = aSortOptions;
    self.googleOptions = aGoogleOptions;
  }
  return self;
}


@end
