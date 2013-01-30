// Copyright 2012 nUCROSOFT. All rights reserved.
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

#import "LjsGoogleReverseGeocodeOptions.h"
#import "Lumberjack.h"
#import "LjsLocationManager.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGrgHttpRequestOptions ()

@end

@implementation LjsGrgHttpRequestOptions 

@synthesize shouldMakeRequest;
@synthesize sensor;
@synthesize shouldPostNotification;
@synthesize searchTerm;

- (id) init {
 //  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithShouldMakeRequest:(BOOL)aShouldMakeRequest 
                          sensor:(BOOL)aWasSensor
                postNotification:(BOOL)aShouldPostNotification 
                 searchTermOrNil:(NSString *)aSearchTerm {
  self = [super init];
  if (self) {
    self.shouldMakeRequest = aShouldMakeRequest;
    self.sensor = aWasSensor;
    self.shouldPostNotification = aShouldPostNotification;
    self.searchTerm = aSearchTerm;
  }
  return self;
}

+ (LjsGrgHttpRequestOptions *) doNotSearch {
  return [[LjsGrgHttpRequestOptions alloc]
          initWithShouldMakeRequest:NO
          sensor:NO
          postNotification:NO
          searchTermOrNil:nil];        
}


@end


@implementation LjsGrgPredicateFactory 

- (NSPredicate *) predicateForCityTownNeighborhoodWithLocation:(LjsLocation *) aLocation {
  LjsLocation *searchLoc = [LjsLocation locationWithLocation:aLocation
                                                       scale:[LjsLocation scale1km]];
  NSPredicate *latPred = [NSPredicate predicateWithFormat:@"latitude1km == %@", 
                          searchLoc.latitude];
  NSPredicate *lonPred = [NSPredicate predicateWithFormat:@"longitude1km == %@",
                          searchLoc.longitude];
  NSArray *preds = [NSArray arrayWithObjects:latPred, lonPred, nil];
  
  return [NSCompoundPredicate andPredicateWithSubpredicates:preds];
}

- (NSPredicate *) predicateForCityTownNeighborhoodWithLocation:(LjsLocation *) aLocation
                                                    searchTerm:(NSString *) aSearchTerm {
  NSPredicate *locPred;
  locPred = [self predicateForCityTownNeighborhoodWithLocation:aLocation];
  
  NSPredicate *termPred = [NSPredicate predicateWithFormat:@"formattedAddress CONTAINS[cd] %@",
                           aSearchTerm];
  NSArray *preds = [NSArray arrayWithObjects:locPred,termPred, nil];
  
  return [NSCompoundPredicate andPredicateWithSubpredicates:preds];
}


@end

@implementation LjsGoogleReverseGeocodeOptions
@synthesize location;
@synthesize predicate;
@synthesize httpRequestOptions;

#pragma mark Memory Management


- (id) init {
 //  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithLocation:(LjsLocation *)aLocation 
              predicate:(NSPredicate *)aPredicate 
     httpRequestOptions:(LjsGrgHttpRequestOptions *)aHttpRequestOptions {
  self = [super init];
  if (self) {
    self.location = aLocation;
    self.predicate = aPredicate;
    self.httpRequestOptions = aHttpRequestOptions;
  }
  return self;
}

@end
