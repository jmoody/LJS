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
#import "ASIHTTPRequest.h"
#import "LjsGooglePlacesPredictiveReply.h"
#import "LjsGooglePlacesDetailsReply.h"
#import "LjsGooglePlacesPrediction.h"
#import "LjsGooglePlacesDetails.h"


@protocol LjsGooglePlaceRequestManagerResultHandlerDelegate <NSObject>

@required
- (void) requestForPredictionsCompletedWithPredictions:(NSArray *) aPredictions
                                              userInfo:(NSDictionary *) aUserInfo;
- (void) requestForPredictionsFailedWithCode:(NSUInteger) aCode
                                     request:(ASIHTTPRequest *) aRequest;
- (void) requestForPredictionsFailedWithCode:(NSString *) aStatusCode
                                       reply:(LjsGooglePlacesPredictiveReply *) aReply
                                       error:(NSError *) aError;

- (void) requestForDetailsCompletedWithDetails:(LjsGooglePlacesDetails *) aDetails
                                      userInfo:(NSDictionary *) aUserInfo;
- (void) requestForDetailsFailedWithCode:(NSUInteger) aCode
                                 request:(ASIHTTPRequest *) aRequest;
- (void) requestForDetailsFailedWithCode:(NSString *) aStatusCode
                                   reply:(LjsGooglePlacesDetailsReply *) aReply
                                   error:(NSError *) aError;

@end

/**
 Documentation
 */
@interface LjsGooglePlacesRequestManager : NSObject 

@property (nonatomic, copy) NSString *apiToken;
@property (nonatomic, assign) id<LjsGooglePlaceRequestManagerResultHandlerDelegate> resultHandler;


/** @name Properties */

/** @name Initializing Objects */
- (id) initWithApiToken:(NSString *) aApiToken
          resultHandler:(id<LjsGooglePlaceRequestManagerResultHandlerDelegate>) aResultHandler;

/** @name Handling Notifications, Requests, and Events */


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
/** @name Utility */

- (void) performPredictionRequestForCurrentLocationWithInput:(NSString *) aInput
                                                      radius:(CGFloat) aRadius
                                                    language:(NSString *) aLangCode
                                        establishmentRequest:(BOOL) aIsAnEstablishmentRequest;

- (void) performDetailsRequestionForPrediction:(LjsGooglePlacesPrediction *) aPrediction
                                      language:(NSString *) aLangCode;

@end
