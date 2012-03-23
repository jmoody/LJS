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

#import "LjsGooglePlacesRequestManager.h"
#import "LjsWebCategories.h"
#import "Lumberjack.h"
#import "ASIHTTPRequest.h"
#import "LjsLocationManager.h"
#import "ASIHTTPRequest+LjsAdditions.h"
#import "LjsGooglePlacesPredictiveReply.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsGooglePlacesAutocompleteUrl = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
static NSString *LjsGooglePlacesDetailsUrl = @"https://maps.googleapis.com/maps/api/place/details/json";
static NSString *LjsGooglePlacesPlaceSearchUrl = @"https://maps.googleapis.com/maps/api/place/search/json";

@interface LjsGooglePlacesRequestManager ()

@property (nonatomic, strong) LjsLocationManager *locationManager;

- (NSString *) stringForSensor:(BOOL) aSensor;

- (NSDictionary *) dictionaryForRequiredAutocompleteWithInput:(NSString *) aInput
                                                       sensor:(BOOL) aSensor;

- (NSDictionary *) dictionaryForOptionalAutocompletWithLatitude:(NSDecimalNumber *) aLatitude
                                                      longitude:(NSDecimalNumber *) aLongitude
                                                         radius:(NSDecimalNumber *) aRadius
                                                   languageCode:(NSString *) aLangCode
                                            establishmentSearch:(BOOL) aIsAnEstablishmentSearch;

- (ASIHTTPRequest *) requestForAutocompleteWithInput:(NSString *) aInput
                                            latitude:(NSDecimalNumber *) aLatitude
                                           longitude:(NSDecimalNumber *) aLongitude
                                              radius:(NSDecimalNumber *) aRadius
                                        languageCode:(NSString *) aLangCode
                                       establishment:(BOOL) aIsAnEstablishmentRequest;

- (void) handleRequestAutocompleteDidFinish:(ASIHTTPRequest *) aRequest;
- (void) handleRequestAutocompleteDidFail:(ASIHTTPRequest *)aRequest;

- (void) handleRequestDetailsDidFinish:(ASIHTTPRequest *) aRequest;
- (void) handleRequestDetailsDidFail:(ASIHTTPRequest *) aRequest;



@end

@implementation LjsGooglePlacesRequestManager

@synthesize apiToken;
@synthesize resultHandler;
@synthesize locationManager;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
  self.resultHandler = nil;
}

- (id) initWithApiToken:(NSString *)aApiToken 
          resultHandler:(id<LjsGooglePlaceRequestManagerResultHandlerDelegate>)aResultHandler {
  self = [super init];
  if (self) {
    self.apiToken = aApiToken;
    self.resultHandler = aResultHandler;
    self.locationManager = [LjsLocationManager sharedInstance];
  }
  return self;
}



/*
 input — The text string on which to search. The Place service will return candidate matches based on this string and order results based on their perceived relevance.
 sensor — Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request. This value must be either true or false.
 key — Your application's API key. This key identifies your application for purposes of quota management. Visit the APIs Console to create an API Project and obtain your key.
 
 
 offset — The character position in the input term at which the service uses text for predictions. For example, if the input is 'Googl' and the completion point is 3, the service will match on 'Goo'. The offset should generally be set to the position of the text caret. If no offset is supplied, the service will use the entire term.
 location — The point around which you wish to retrieve Place information. Must be specified as latitude,longitude.
 radius — The distance (in meters) within which to return Place results. Note that setting a radius biases results to the indicated area, but may not fully restrict results to the specified area. See Location Biasing below.
 language — The language in which to return results. See the supported list of domain languages. Note that we often update supported languages so this list may not be exhaustive. If language is not supplied, the Place service will attempt to use the native language of the domain from which the request is sent.
 types — The types of Place results to return. See Place Types below. If no type is specified, all types will be returned.
 */


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
                                                         radius:(NSDecimalNumber *) aRadius
                                                   languageCode:(NSString *) aLangCode
                                            establishmentSearch:(BOOL) aIsAnEstablishmentSearch {
  NSString *type;
  if (aIsAnEstablishmentSearch == YES) {
    type = @"establishment";
  } else {
    type = @"geocode";
  }
  NSString *location = [NSString stringWithFormat:@"%@,%@", 
                        aLatitude, aLongitude];
  NSString *radius = [NSString stringWithFormat:@"%@", aRadius];
  
  NSDictionary *result;
  result = [NSDictionary dictionaryWithObjectsAndKeys:
            location, @"location",
            radius, @"radius",
            aLangCode, @"language",
            type, @"types", nil];
  
  return result;
}

- (ASIHTTPRequest *) requestForAutocompleteWithInput:(NSString *) aInput
                                            latitude:(NSDecimalNumber *) aLatitude
                                           longitude:(NSDecimalNumber *) aLongitude
                                              radius:(NSDecimalNumber *) aRadius
                                        languageCode:(NSString *) aLangCode
                                       establishment:(BOOL) aIsAnEstablishmentRequest {
  NSDictionary *required = [self dictionaryForRequiredAutocompleteWithInput:aInput
                                                                     sensor:YES];
  NSDictionary *optional = [self dictionaryForOptionalAutocompletWithLatitude:aLatitude
                                                                    longitude:aLongitude
                                                                       radius:aRadius
                                                                 languageCode:aLangCode
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
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestAutocompleteDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestAutocompleteDidFinish:)];
  return request;
}


- (void) performPredictionRequestForCurrentLocationWithInput:(NSString *) aInput
                                                      radius:(NSDecimalNumber *) aRadius
                                                    language:(NSString *) aLangCode
                                        establishmentRequest:(BOOL) aIsAnEstablishmentRequest {
  ASIHTTPRequest *request;
  request = [self requestForAutocompleteWithInput:aInput
                                         latitude:[self.locationManager latitude]
                                        longitude:[self.locationManager longitude]
                                           radius:aRadius
                                     languageCode:aLangCode
                                    establishment:aIsAnEstablishmentRequest];
  DDLogDebug(@"starting request: %@", request);
  DDLogDebug(@"url = %@", [request url]);
  [request startAsynchronous];
}


- (void) handleRequestAutocompleteDidFail:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"autocomplete did fail");
  NSUInteger code = [aRequest responseCode];
  [self.resultHandler requestForPredictionsFailedWithCode:code 
                                                  request:aRequest];
                                       
  
}

- (void) handleRequestAutocompleteDidFinish:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"autocomplete request did finish");
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestAutocompleteDidFail:aRequest];
    return;
  }
  NSError *error = nil;
  LjsGooglePlacesPredictiveReply *reply = [[LjsGooglePlacesPredictiveReply alloc]
                                           initWithReply:[aRequest responseString]
                                           error:&error];
  if ([reply statusRejected] == YES) {
    [self.resultHandler requestForPredictionsFailedWithCode:[reply status]
                                                      reply:reply
                                                      error:error];
  } else {
    [self.resultHandler requestForPredictionsCompletedWithPredictions:[reply predictions]];
  }
}

/*
key (required) — Your application's API key. This key identifies your application for purposes of quota management and so that Places added from your application are made immediately available to your app. Visit the APIs Console to create an API Project and obtain your key.
reference (required) — A textual identifier that uniquely identifies a place, returned from a Place search request.
sensor (required) — Indicates whether or not the Place Details request came from a device using a location sensor (e.g. a GPS). This value must be either true or false.

language (optional) — The language code, indicating in which language the results should be returned, if possible. See the list of supported languages and their codes. Note that we often update supported languages so this list may not be exhaustive.
 */
- (void) performDetailsRequestionForPrediction:(LjsGooglePlacesPrediction *) aPrediction
                                      language:(NSString *)aLangCode {
  NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.apiToken, @"key",
                             aPrediction.searchReferenceId, @"reference",
                             [self stringForSensor:YES], @"sensor",
                             aLangCode, @"language",
                             nil];
  NSString *params = [paramDict stringByParameterizingForUrl];
  NSString *path = [NSString stringWithFormat:@"%@%@", 
                    LjsGooglePlacesDetailsUrl, params];
  NSURL *url = [NSURL URLWithString:path];
  DDLogDebug(@"url = %@", url);
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                             initWithURL:url];
  
  [request setRequestMethod:@"GET"];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestDetailsDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestDetailsDidFinish:)];
  
  [request startAsynchronous];
}


- (void) handleRequestDetailsDidFail:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"autocomplete did fail");
  NSUInteger code = [aRequest responseCode];
  [self.resultHandler requestForDetailsFailedWithCode:code
                                              request:aRequest];
  
}

- (void) handleRequestDetailsDidFinish:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"autocomplete request did finish");
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestDetailsDidFail:aRequest];
    return;
  }
  NSError *error = nil;
  LjsGooglePlacesDetailsReply *reply = [[LjsGooglePlacesDetailsReply alloc]
                                        initWithReply:[aRequest responseString]
                                        error:&error];
  if ([reply statusRejected] == YES) {
    [self.resultHandler requestForDetailsFailedWithCode:[reply status]
                                                  reply:reply
                                                  error:error];
  } else {
    [self.resultHandler requestForDetailsCompletedWithDetails:[reply details]];
  }
}



@end
