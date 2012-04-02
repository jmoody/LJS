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


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LjsGoogleRequestManager.h"
#import "LjsLocationManager.h"

@class LjsGooglePlacePredictionOptions;

extern NSString *LjsGooglePlacesManagerNotificationNewPlacesAvailable;

extern NSString *LjsGooglePlacesManagerModelFile;
extern NSString *LjsGooglePlacesSqlLiteStore;


/**
 Documentation
 */
@interface LjsGoogleManager : NSObject 
<LjsGooglePlaceResultHandlerDelegate, LjsGoogleReverseGeocodeHandlerDelegate>

/** @name Properties */
@property (nonatomic, strong, readonly) NSManagedObjectContext *context; 
@property (nonatomic, copy) NSString *apiToken;
@property (nonatomic, strong, readonly) LjsGoogleRequestManager *requestManager;

/** @name Initializing Objects */
- (id) initWithLocationManager:(LjsLocationManager *) aManager;

- (id) initWithApiToken:(NSString *) aApiToken
                manager:(LjsLocationManager *) aManager;

- (id) initWithStoreFilename:(NSString *) aFilename
                    apiToken:(NSString *) aApiToken
                     manager:(LjsLocationManager *) aManager;
          
- (id) initWithStoreDirectory:(NSString *) aDirectory
                storeFilename:(NSString *) aFilename
                     apiToken:(NSString *) aApiToken
                      manager:(LjsLocationManager *) aManager;
                 

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

- (NSArray *) predicationsWithOptions:(LjsGooglePlacePredictionOptions *) aOptions;

- (NSArray *) geocodesWithLocation:(LjsLocation *) aLocation
                        searchTerm:(NSString *) aSearchTerm
                   makeHttpRequest:(BOOL) aShouldMakeHttpRequest
               locationFromSensors:(BOOL) aLocationIsFromSensor;

/** @name Sorting */

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
          withDistanceFromLatitude:(NSDecimalNumber *) aLatitude
                         longitude:(NSDecimalNumber *) aLongitude
                         ascending:(BOOL) aSortAscending;

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
                        ascending:(BOOL) aSortAscending;

- (NSArray *) arrayBySortingPlaces:(NSArray *) aPlaces
          withDistanceFromLocation:(LjsLocation *) aLocation
                         ascending:(BOOL)aSortAscending;

/** @name filtering */
- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                        withinMeters:(CGFloat) aMeters
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius;

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                    withinKilometers:(CGFloat) aKilometers
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius;

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                          withinFeet:(CGFloat) aFeet
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius;

- (NSArray *) arrayByFilteringPlaces:(NSArray *) aPlaces
                         withinMiles:(CGFloat) aMiles
                          ofLocation:(LjsLocation *) aLocation
                        insideRadius:(BOOL) aInsideRadius;



@end
