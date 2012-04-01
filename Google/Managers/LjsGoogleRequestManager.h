#import <Foundation/Foundation.h>
#import "LjsLocationManager.h"

@class ASIHTTPRequest;
@class LjsGooglePlacesDetails;
@class LjsGooglePlacesPredictiveReply;
@class LjsGooglePlacesDetailsReply;
@class LjsGooglePlacesPrediction;

@protocol LjsGooglePlaceResultHandlerDelegate <NSObject>

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

@protocol LjsGoogleReverseGeocodeHandlerDelegate <NSObject>

@required
- (void) requestForReverseGeocodeCompletedWithResult:(NSArray *) aResult
                                            userInfo:(NSDictionary *) aUserInfo;
- (void) requestForReverseGeocodeFailedWithCode:(NSUInteger) aCode
                                        request:(ASIHTTPRequest *) aRequest;
- (void) requestForReverseGeocodeFailedWithCode:(NSString *) aCode
                                        request:(ASIHTTPRequest *) aRequest
                                          error:(NSError *) aError;

@end

/**
 Documentation
 */
@interface LjsGoogleRequestManager : NSObject 

@property (nonatomic, assign) id<LjsGooglePlaceResultHandlerDelegate> placeResultHandler;
@property (nonatomic, assign) id<LjsGoogleReverseGeocodeHandlerDelegate> reverseGeocodeHandler;

/** @name Properties */
@property (nonatomic, copy) NSString *apiToken;

/** @name Initializing Objects */
- (id) initWithApiToken:(NSString *) aApiToken;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (void) executeHttpPredictionRequestWithInput:(NSString *) aInput
                                        radius:(CGFloat) aRadius
                                      location:(LjsLocation) aLocation
                                 languageOrNil:(NSString *) aLangCode
                          establishmentRequest:(BOOL) aIsAnEstablishmentRequest;

- (void) executeHttpDetailsRequestionForPrediction:(LjsGooglePlacesPrediction *) aPrediction
                                          language:(NSString *) aLangCode;

/** @name Utility */
- (void) executeHttpReverseGeocodeRequestForLocation:(LjsLocation) aLocation
                                locationIsFromSensor:(BOOL) aLocIsFromSensor;

@end
