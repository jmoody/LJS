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

#import "LjsGoogleRequestFactory.h"
#import "Lumberjack.h"
#import "ASIFormDataRequest.h"
#import "LjsFoundationCategories.h"
#import "LjsWebCategories.h"
#import "LjsGooglePlacesPrediction.h"

static NSString *LjsGooglePlacesAutocompleteUrl = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
static NSString *LjsGooglePlacesDetailsUrl = @"https://maps.googleapis.com/maps/api/place/details/json";
static NSString *LjsGooglePlacesPlaceSearchUrl = @"https://maps.googleapis.com/maps/api/place/search/json";
static NSString *LjsGoogleReverseGeocodeUrl = @"https://maps.googleapis.com/maps/api/geocode/json";


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@interface LjsGoogleRequestFactory ()

- (NSString *) stringForSensor:(BOOL) aSensor;

- (NSDictionary *) dictionaryForRequiredAutocompleteWithInput:(NSString *) aInput
                                                       sensor:(BOOL) aSensor;

- (NSDictionary *) dictionaryForOptionalAutocompletWithLatitude:(NSDecimalNumber *) aLatitude
                                                      longitude:(NSDecimalNumber *) aLongitude
                                                         radius:(CGFloat) aRadius
                                              languageCodeOrNil:(NSString *) aLangCode
                                            establishmentSearch:(BOOL) aIsAnEstablishmentSearch;



@end

@implementation LjsGoogleRequestFactory
@synthesize apiToken;

#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}


- (id) initWithApiToken:(NSString *)aApiToken {
  self = [super init];
  if (self) {
    self.apiToken = aApiToken;
  }
  return self;
}

- (NSString *) stringForSensor:(BOOL) aSensor {
  NSString *sensor;
  if (aSensor == YES) {
    sensor = @"true";
  } else {
    sensor = @"false";
  }
  return sensor;
}


- (NSDictionary *) dictionaryForRequiredAutocompleteWithInput:(NSString *) aInput
                                                       sensor:(BOOL) aSensor {
  NSString *sensor = [self stringForSensor:aSensor];
  return [NSDictionary dictionaryWithObjectsAndKeys:
          aInput, @"input",
          sensor, @"sensor",
          self.apiToken, @"key",
          nil];
}

- (NSDictionary *) dictionaryForOptionalAutocompletWithLatitude:(NSDecimalNumber *) aLatitude
                                                      longitude:(NSDecimalNumber *) aLongitude
                                                         radius:(CGFloat) aRadius
                                              languageCodeOrNil:(NSString *) aLangCode
                                            establishmentSearch:(BOOL) aIsAnEstablishmentSearch {
  NSString *type;
  if (aIsAnEstablishmentSearch == YES) {
    type = @"establishment";
  } else {
    type = @"geocode";
  }
  NSString *location = [NSString stringWithFormat:@"%@,%@", 
                        aLatitude, aLongitude];
  NSString *radius = [NSString stringWithFormat:@"%f", aRadius];
  
  NSDictionary *result;
  if (aLangCode != nil) {
    result = [NSDictionary dictionaryWithObjectsAndKeys:
              location, @"location",
              radius, @"radius",
              aLangCode, @"language",
              type, @"types", nil];
  } else {
    result = [NSDictionary dictionaryWithObjectsAndKeys:
              location, @"location",
              radius, @"radius",
              type, @"types", nil];
  }
  
  return result;
}

- (ASIHTTPRequest *) requestForAutocompleteWithInput:(NSString *) aInput
                                            latitude:(NSDecimalNumber *) aLatitude
                                           longitude:(NSDecimalNumber *) aLongitude
                                              radius:(CGFloat) aRadius
                                   languageCodeOrNil:(NSString *) aLangCode
                                       establishment:(BOOL) aIsAnEstablishmentRequest {
  
  NSDictionary *required = [self dictionaryForRequiredAutocompleteWithInput:aInput
                                                                     sensor:YES];
  NSDictionary *optional = [self dictionaryForOptionalAutocompletWithLatitude:aLatitude
                                                                    longitude:aLongitude
                                                                       radius:aRadius
                                                            languageCodeOrNil:aLangCode
                                                          establishmentSearch:aIsAnEstablishmentRequest];
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [parameters addEntriesFromDictionary:required];
  [parameters addEntriesFromDictionary:optional];
  
  NSString *params = [parameters stringByParameterizingForUrl];
  NSString *path = [NSString stringWithFormat:@"%@%@", 
                    LjsGooglePlacesAutocompleteUrl, params];
  NSURL *url = [NSURL URLWithString:path];
  
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                             initWithURL:url];
  
  [request setRequestMethod:@"GET"];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setUserInfo:parameters];
  return request;
}


- (ASIHTTPRequest *) requestForDetailsRequestForPrediction:(LjsGooglePlacesPrediction *) aPrediction
                                                  language:(NSString *)aLangCode {
  NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.apiToken, @"key",
                              aPrediction.searchReferenceId, @"reference",
                              [self stringForSensor:YES], @"sensor",
                              aLangCode, @"language",
                              nil];
  NSString *params = [parameters stringByParameterizingForUrl];
  NSString *path = [NSString stringWithFormat:@"%@%@", 
                    LjsGooglePlacesDetailsUrl, params];
  NSURL *url = [NSURL URLWithString:path];
  
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                             initWithURL:url];
  
  [request setRequestMethod:@"GET"];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setUserInfo:parameters];
  return request; 
}


- (ASIHTTPRequest *) requestForReverseGeocodeWithLocation:(LjsLocation *) aLocation
                                     locationIsFromSensor:(BOOL) aLocIsFromSensor {
  
  NSString *sensor = [self stringForSensor:aLocIsFromSensor];
  NSString *latlong = [NSString stringWithFormat:@"%@,%@",
                       aLocation.latitude, aLocation.longitude];
  NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             sensor, @"sensor",
                             latlong, @"latlng",
                             nil];
  NSString *params = [paramDict stringByParameterizingForUrl];
  NSString *path = [NSString stringWithFormat:@"%@%@",
                    LjsGoogleReverseGeocodeUrl, params];
  NSURL *url = [NSURL URLWithString:path];
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                             initWithURL:url];
  
  [request setRequestMethod:@"GET"];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setUserInfo:paramDict];
  return request;
}


@end
