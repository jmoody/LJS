// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleManager.h"
#import "LjsGoogleGlobals.h"
#import "Lumberjack.h"
#import "LjsFileUtilities.h"
#import "LjsCaesarCipher.h"
#import "LjsGooglePlacesDetailsReply.h"
#import "LjsGooglePlacesPredictiveReply.h"
#import "LjsGooglePlacesNmoDetails.h"
#import "LjsGooglePlacesPrediction.h"
#import "LjsGooglePlace.h"
#import "LjsDn.h"
#import "LjsFoundationCategories.h"
#import "LjsGoogleDistancer.h"
#import "LjsGooglePlacePredictionOptions.h"
#import "LjsGoogleReverseGeocode.h"
#import "LjsGoogleNmoReverseGeocode.h"
#import "LjsGoogleReverseGeocodeOptions.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsNotificationGoogleManagerNewPlacesAvailable = @"com.littlejoysoftware.Notification from Google Manager New Places Available";

NSString *LjsNotificationGoogleManagerReverseGeocodeResultsAvailable = @"com.littlejoysoftware.Notification from Google Manager Reverse Geocode Results Available";




NSString *LjsGooglePlacesManagerModelFile = @"LjsGoogleModel";
NSString *LjsGooglePlacesSqlLiteStore = @"com.littlejoysoftware.LjsGoogle.sqlite";

@interface LjsGoogleManager ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *model; 
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *coordinator; 
@property (nonatomic, copy) NSString *sqliteFilename;
@property (nonatomic, copy) NSString *sqliteDirectory;

@property (nonatomic, strong) LjsLocationManager *lm;
@property (nonatomic, strong) LjsGoogleDistancer *distancer;




- (NSURL *) urlForSqlitePath;
- (NSString *) decodeDefaultApiKey;

- (BOOL) placeExistsForId:(NSString *) aId;
- (NSArray *) fetchAllPlaces;
//- (BOOL) geocodeExistsForLocation:(LjsLocation *) aLocation;
- (NSArray *) fetchAllGeocodes;



@end

@implementation LjsGoogleManager

@synthesize context = __moContext;
@synthesize model = __moModel;
@synthesize coordinator = __coordinator;
@synthesize sqliteFilename;
@synthesize sqliteDirectory;
@synthesize apiToken;
@synthesize requestManager = __requestManager;
@synthesize lm;
@synthesize distancer;


#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (NSString *) decodeDefaultApiKey {
  NSString *defaultToken = LjsGoogleApiKey_joshuajmoody;
  NSUInteger lenght = [defaultToken length];
  LjsCaesarCipher *cipher = [[LjsCaesarCipher alloc] initWithRotate:lenght];
  NSString *decoded = [cipher stringByDecodingString:defaultToken];
  return decoded;
}

- (id) initWithLocationManager:(LjsLocationManager *)aManager {
  NSString *decoded = [self decodeDefaultApiKey];
  return [self initWithStoreDirectory:[LjsFileUtilities findCoreDataLibraryPath:YES]
                        storeFilename:LjsGooglePlacesSqlLiteStore
                             apiToken:decoded
                              manager:aManager];
  
}


- (id) initWithApiToken:(NSString *) aApiToken
                manager:(LjsLocationManager *)aManager {
  return [self initWithStoreDirectory:[LjsFileUtilities findCoreDataLibraryPath:YES]
                        storeFilename:LjsGooglePlacesSqlLiteStore
                             apiToken:aApiToken
                              manager:aManager];
  
}

- (id) initWithStoreFilename:(NSString *) aFilename 
                    apiToken:(NSString *) aApiToken
                     manager:(LjsLocationManager *)aManager {
  return [self initWithStoreDirectory:[LjsFileUtilities findCoreDataLibraryPath:YES]
                        storeFilename:aFilename
                             apiToken:aApiToken
                              manager:aManager];
  
}

- (id) initWithStoreDirectory:(NSString *) aDirectory
                storeFilename:(NSString *) aFilename
                     apiToken:(NSString *) aApiToken 
                      manager:(LjsLocationManager *)aManager {
  self = [super init];
  if (self != nil) {
    DDLogDebug(@"directory = %@", aDirectory);
    self.sqliteDirectory = aDirectory;
    self.sqliteFilename = aFilename;
    self.apiToken = aApiToken;
    
    self.lm = aManager;
    if (self.lm == nil) {
      abort();
    }
    
    self.distancer = [[LjsGoogleDistancer alloc] initWithLocationManager:self.lm];
    
    // initalize - must be done after setting the location manager
    // why i did it this way, i am not sure - probably something about
    // making the request manager readonly?
    [self requestManager];
    
    // initialize
    [self context];
  }
  return self;
}


- (BOOL) placeExistsForId:(NSString *) aId {
  NSString *entityName = [LjsGooglePlace entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = [NSPredicate predicateWithFormat:@"stableId == %@", aId];
  NSError *error = nil;
  NSUInteger count = [self.context countForFetchRequest:request
                                                  error:&error];
  if (count == NSNotFound) {
    DDLogFatal(@"error fetching place with id %@ - %@: %@", aId, [error localizedDescription], error);
    abort();
  } 
  
  if (count > 1) {
    DDLogFatal(@"error fetching place with id: %@ - found multiple records: %d", aId, count);
  } 
  return count == 1;
}

- (NSArray *) fetchAllPlaces {
  NSString *entityName = [LjsGooglePlace entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  NSError *error = nil;
  NSArray *fetched = [self.context executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"error fetching places %@: %@", [error localizedDescription], error);
    abort();
  } 
  return fetched;
}

- (BOOL) geocodeExistsForLocation:(LjsLocation *)aLocation {
  NSString *entityName = [LjsGoogleReverseGeocode entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  NSPredicate *predicate;
  predicate = [NSPredicate predicateWithFormat:@"key == %@", [aLocation key]];
  
  request.predicate = predicate;
  NSError *error = nil;
  NSUInteger count = [self.context countForFetchRequest:request error:&error];
  if (count == NSNotFound) {
    DDLogFatal(@"error fetching reverse geocode with location: %@ %@: %@",
               aLocation, [error localizedDescription], error);
    abort();
  } 
  
  return count != 0;
}

- (NSArray *) fetchAllGeocodes {
  NSString *entityName = [LjsGoogleReverseGeocode entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  NSError *error = nil;
  NSArray *fetched = [self.context executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"error fetching reverse geocode: %@: %@", 
               [error localizedDescription], error);
  } 
  return fetched;
}



- (NSArray *) predicationsWithOptions:(LjsGooglePlacePredictionOptions *) aOptions {
  NSString *entityName = [LjsGooglePlace entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = aOptions.predicate;
  
  // cannot limit the fetch if there is sorting involved - must limit post-fetch
  NSUInteger locLimit = aOptions.limit;
  LjsGpPredictionSortOptions *sortOptions = aOptions.sortOptions;
  if (locLimit != NSNotFound && sortOptions.shouldSort == NO) {
    request.fetchLimit = locLimit;
  }
  
  NSError *error = nil;
  NSArray *fetched = [self.context executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"could not execute fetch request for place: %@ : %@ - predicate: %@", 
               [error localizedDescription], error, request.predicate);
    abort();
  } 
  
  NSArray *result = fetched;
  if (sortOptions.shouldSort == YES) {
    
    NSArray *sorted = [self arrayBySortingPlaces:fetched 
                        withDistanceFromLocation:aOptions.location
                                       ascending:sortOptions.ascending];
    if (locLimit != NSNotFound && [sorted count] > locLimit) {
      NSRange range = NSMakeRange(0, locLimit);
      result = [sorted subarrayWithRange:range];
    } else {
      result = sorted;
    }
  }
  
  if (aOptions.googleOptions.shouldMakeRequest == YES) {
    LjsGpPredictionGoogleOptions *googleOptions = aOptions.googleOptions;
    [self.requestManager executeHttpPredictionRequestWithInput:googleOptions.searchString
                                                        radius:googleOptions.radiusMeters
                                                      location:aOptions.location
                                                 languageOrNil:googleOptions.langCode
                                          establishmentRequest:googleOptions.searchEstablishments];
  }
  
  return result;
}

- (NSArray *) geocodesWithOptions:(LjsGoogleReverseGeocodeOptions *) aOptions {
  NSString *entityName = [LjsGoogleReverseGeocode entityName];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = aOptions.predicate;
  NSError *error = nil;
  NSArray *fetched = [self.context executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"error fetching reverse geocode with location: %@ predicate: %@ %@: %@",
               aOptions.location, request.predicate, [error localizedDescription], error);
    abort();
  } 
  
  
  NSUInteger resultCount = [fetched count];
  if (resultCount > 1) {
    __block LjsLocation *location = aOptions.location;
    fetched = [fetched sortedArrayUsingComparator:^(id a, id b) {
      LjsGoogleReverseGeocode *first = (LjsGoogleReverseGeocode *) a;
      LjsGoogleReverseGeocode *second = (LjsGoogleReverseGeocode *) b;
      return (NSComparisonResult)([self.distancer compareDistanceFromLocation:location
                                                                   toGeocodeA:first 
                                                                   toGeocodeB:second] == NSOrderedDescending);
    }];
  }
  
  LjsGrgHttpRequestOptions *httpOptions = aOptions.httpRequestOptions;
  if (httpOptions.shouldMakeRequest == YES) {
    if (resultCount != 0) {
      DDLogDebug(@"args say make a reverse geocode request, but results have been found - skipping");
    } else {
      DDLogDebug(@"args say make a reverse geocode request");
      LjsLocation *location = aOptions.location;
      
      [self.requestManager executeHttpReverseGeocodeRequestForLocation:location
                                                  locationIsFromSensor:httpOptions.sensor
                                                       searchTermOrNil:httpOptions.searchTerm
                                                shouldPostNotification:httpOptions.shouldPostNotification];
    }
  } else {
    DDLogDebug(@"args say do not make a reverse geocode request");
  }
  
  return fetched;
}





#pragma mark Sorting 

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
          withDistanceFromLatitude:(NSDecimalNumber *) aLatitude
                         longitude:(NSDecimalNumber *) aLongitude
                         ascending:(BOOL) aSortAscending {
  LjsLocation * loc = [[LjsLocation alloc]
                       initWithLatitude:aLatitude
                       longitude:aLongitude];
  
  return [self arrayBySortingPlaces:aPlaces
           withDistanceFromLocation:loc
                          ascending:aSortAscending];
  
}

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
                         ascending:(BOOL)aSortAscending {
  LjsLocation * current = [self.lm location];
  return [self arrayBySortingPlaces:aPlaces
           withDistanceFromLocation:current
                          ascending:aSortAscending];
}

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
          withDistanceFromLocation:(LjsLocation *)aLocation 
                         ascending:(BOOL)aSortAscending {
  if ([LjsLocationManager isValidLocation:aLocation] == NO) {
    DDLogWarn(@"location must valid: %@", aLocation);
    return nil;
  }
  
  NSComparisonResult compResult = aSortAscending ? NSOrderedDescending : NSOrderedAscending;  
  NSArray *result;
  result = [aPlaces sortedArrayUsingComparator:^(id a, id b) {
    LjsGooglePlace *first = (LjsGooglePlace *) a;
    LjsGooglePlace *second = (LjsGooglePlace *) b;
    return (NSComparisonResult)([self.distancer compareDistanceFromLocation:aLocation 
                                                                   toPlaceA:first 
                                                                   toPlaceB:second] == compResult);
  }];
  return result;
}


#pragma mark Filtering 

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                    withinKilometers:(CGFloat) aKilometers
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius {
  return [self arrayByFilteringPlaces:aPlaces
                         withinMeters:aKilometers * 1000
                           ofLocation:aLocation
                         insideRadius:aInsideRadius];
}

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                          withinFeet:(CGFloat) aFeet
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius {
  return [self arrayByFilteringPlaces:aPlaces
                         withinMeters:aFeet * 3.2808399
                           ofLocation:aLocation
                         insideRadius:aInsideRadius];
}

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                         withinMiles:(CGFloat) aMiles
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius {
  return [self arrayByFilteringPlaces:aPlaces
                          withinMiles:aMiles * 1609.344
                           ofLocation:aLocation
                         insideRadius:aInsideRadius];
}


- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                        withinMeters:(CGFloat) aMeters
                          ofLocation:(LjsLocation *) aLocation 
                        insideRadius:(BOOL) aInsideRadius {
  if ([LjsLocationManager isValidLocation:aLocation] == NO) {
    DDLogWarn(@"location must valid: %@", aLocation);
    return nil;
  }
  NSDecimalNumber *targetDist = [[LjsDn dnWithFloat:aMeters] dnByRoundingAsLocation];
  NSPredicate *predicate;
  predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    LjsGooglePlace *place = (LjsGooglePlace *) evaluatedObject;
    NSDecimalNumber *distFrom = [self.distancer metersBetweenPlace:place andLocation:aLocation];    
    return aInsideRadius ? [distFrom lte:targetDist] : [distFrom gte:targetDist];
  }];
  NSArray *result;
  result = [aPlaces filteredArrayUsingPredicate:predicate];
  
  return result;
}


#pragma mark Request Manager Callback Selectors

- (void) requestForPredictionsCompletedWithPredictions:(NSArray *)aPredictions
                                              userInfo:(NSDictionary *) aUserInfo {
  LjsGooglePlacesPrediction *prediction;
  for (prediction in aPredictions) {
    NSString *placeId = prediction.stablePlaceId;
    if ([self placeExistsForId:placeId] == NO) {
      //DDLogDebug(@"starting request for details with prediction: %@", prediction);
      NSString *langCode = [aUserInfo objectForKey:@"language"];
      [self.requestManager executeHttpDetailsRequestionForPrediction:prediction
                                                            language:langCode];
    } else {
      // DDLogDebug(@"skipping details request - place: %@ (%@) already exists",
      //           prediction.prediction, [prediction shortId]);
    }
  }
}

- (void) requestForPredictionsFailedWithCode:(NSUInteger)aCode 
                                     request:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"request failed with code: %d", aCode);
}

- (void) requestForPredictionsFailedWithCode:(NSString *) aStatusCode
                                       reply:(LjsGooglePlacesPredictiveReply *) aReply
                                       error:(NSError *) aError {
  DDLogDebug(@"request failed with code: %@", aStatusCode);
}

- (void) requestForDetailsCompletedWithDetails:(LjsGooglePlacesNmoDetails *) aDetails
                                      userInfo:(NSDictionary *) aUserInfo {
  NSString *placeId = aDetails.stablePlaceId;
  BOOL postNotification = NO;
  if ([self placeExistsForId:placeId] == NO) {
    postNotification = YES;
    [LjsGooglePlace initWithDetails:aDetails
                            context:self.context];
    [self saveContext];
  }
  
  if (postNotification == YES) {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LjsNotificationGoogleManagerNewPlacesAvailable
     object:nil];
  }
}

- (void) requestForDetailsFailedWithCode:(NSUInteger) aCode
                                 request:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"failed with code: %d", aCode);
}

- (void) requestForDetailsFailedWithCode:(NSString *) aStatusCode
                                   reply:(LjsGooglePlacesDetailsReply *) aReply
                                   error:(NSError *) aError {
  DDLogDebug(@"failed with code : %@", aStatusCode);
}


- (void) requestForReverseGeocodeCompletedWithResult:(NSArray *) aResult
                                            userInfo:(NSDictionary *) aUserInfo {
  BOOL persistedNewResult = NO;
  for (LjsGoogleNmoReverseGeocode *geocode in aResult) {
    LjsLocation *location = geocode.location;
    if ([self geocodeExistsForLocation:location]) {
      DDLogDebug(@"skipping - geocode exists for: %@ : %@", geocode, [location key]);
    } else {
      DDLogDebug(@"creating geocode for %@", geocode);
      persistedNewResult = YES;
      [LjsGoogleReverseGeocode initWithReverseGeocode:geocode
                                              context:self.context];
      [self saveContext];
    }
  }
  
  if (persistedNewResult == YES) {
    NSNumber *number = [aUserInfo objectForKey:@"shouldPost"];
    BOOL shouldPost = [number boolValue];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    LjsLocation *location = [aUserInfo objectForKey:@"location"];
    [userInfo setObject:location forKey:@"location"];
    NSString *searchTerm = [aUserInfo objectForKey:@"searchTerm"];
    if (searchTerm != nil) {
      [userInfo setObject:searchTerm forKey:@"searchTerm"];
    }
    if (shouldPost == YES) {
      // putting information in a dictionary instead of userInfo property
      // to get around sandboxing limitations on MacOs
      [[NSNotificationCenter defaultCenter]
       postNotificationName:LjsNotificationGoogleManagerReverseGeocodeResultsAvailable
       object:userInfo];
    }
  }
}

- (void) requestForReverseGeocodeFailedWithCode:(NSUInteger) aCode
                                        request:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"request failed with code: %d", aCode);
}


- (void) requestForReverseGeocodeFailedWithCode:(NSString *) aCode
                                        request:(ASIHTTPRequest *) aRequest
                                          error:(NSError *) aError {
  DDLogDebug(@"request failed with code: %@", aCode);
  DDLogDebug(@"error %@ : %@", [aError localizedDescription], aError);
}


- (LjsGoogleRequestManager *) requestManager {
  if (__requestManager != nil) {
    return __requestManager;
  }
  
  __requestManager =  [[LjsGoogleRequestManager alloc]
                       initWithApiToken:self.apiToken];
  __requestManager.placeResultHandler = self;
  __requestManager.reverseGeocodeHandler = self;
  
  return __requestManager;
}


#pragma mark Core Data Stack

- (NSURL *) urlForSqlitePath {
  NSURL *dirUrl = [NSURL fileURLWithPath:self.sqliteDirectory];
  NSURL *result = [dirUrl URLByAppendingPathComponent:self.sqliteFilename];
  return result;
}

- (NSManagedObjectModel *) model {
  if (__moModel != nil) { 
    return __moModel; 
  } 
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:LjsGooglePlacesManagerModelFile 
                                            withExtension:@"momd"]; 
  __moModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return __moModel; 
} 


- (NSPersistentStoreCoordinator *) coordinator {
  if (__coordinator != nil) {
    return __coordinator;
  }
  
  
  NSURL *storeURL = [self urlForSqlitePath];
  
  NSError *error = nil;
  __coordinator = [[NSPersistentStoreCoordinator alloc]
                   initWithManagedObjectModel:self.model];
  
  NSDictionary *options = nil;
  options = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  if (![__coordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                   configuration:nil 
                                             URL:storeURL 
                                         options:options
                                           error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You 
     should not use this function in a shipping application, although it may be 
     useful during development. 
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed
     object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something 
     wrong with the file path. Often, a file URL is pointing into the application's
     resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can
     reduce their frequency by:
     * Simply deleting the existing store:
     
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following 
     dictionary as the options parameter: 
     
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
     NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
     NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; 
     consult "Core Data Model Versioning and Data Migration Programming Guide" 
     for details.
     */
    DDLogDebug(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __coordinator;
}


- (NSManagedObjectContext *) context { 
  if (__moContext != nil) { 
    return __moContext; 
  } 
  
  NSPersistentStoreCoordinator *coordinator = self.coordinator;
  if (coordinator != nil) { 
    Class mocClass = [NSManagedObjectContext class];
    if ([mocClass instancesRespondToSelector:@selector(initWithConcurrencyType:)]) {
      __moContext = [[NSManagedObjectContext alloc] 
                     initWithConcurrencyType:NSMainQueueConcurrencyType];
      [__moContext performBlockAndWait:^(void) {
        [__moContext setPersistentStoreCoordinator:coordinator];
      }];
      
    } else {
      __moContext = [[NSManagedObjectContext alloc] init];
      [__moContext setPersistentStoreCoordinator:coordinator];
    }
  } 
  
  return __moContext; 
} 

- (void) saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.context;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. 
      // You should not use this function in a shipping application, although it
      // may be useful during development. 
      DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


@end

#pragma mark DEAD SEA
//- (NSArray *) placesWithNameBeginningWithString:(NSString *)aString 
//                      performPredicationRequest:(BOOL)aShouldPerformRequest
//                               predictionRadius:(CGFloat)aRadius 
//                             predictionLanguage:(NSString *)aLangCode {
//  
//  return [self placesWithNameBeginningWithString:aString
//                                           limit:NSNotFound
//                       performPredicationRequest:aShouldPerformRequest
//                                predictionRadius:aRadius
//                              predictionLanguage:aLangCode];
//}
//
//
//
//- (NSArray *) placesWithNameBeginningWithString:(NSString *)aString 
//                                          limit:(NSUInteger) aLimit
//                      performPredicationRequest:(BOOL)aShouldPerformRequest
//                               predictionRadius:(CGFloat)aRadius 
//                             predictionLanguage:(NSString *)aLangCode {
//  return [self predictionsWithString:aString
//                                           limit:aLimit
//                                            sort:NO
//                                       ascending:NO
//                       performPredicationRequest:aShouldPerformRequest
//                                predictionRadius:aRadius
//                              predictionLanguage:aLangCode];
//}
//
//- (NSArray *) placesWithNameBeginningWithString:(NSString *) aString
//                                           sort:(BOOL) aShouldSort
//                                      ascending:(BOOL) aSortAscending
//                      performPredicationRequest:(BOOL)aShouldPerformRequest
//                               predictionRadius:(CGFloat)aRadius 
//                             predictionLanguage:(NSString *)aLangCode {
//  return [self predictionsWithString:aString
//                                           limit:NSNotFound
//                                            sort:aShouldSort
//                                       ascending:aSortAscending
//                       performPredicationRequest:aShouldPerformRequest
//                                predictionRadius:aRadius
//                              predictionLanguage:aLangCode];
//}

