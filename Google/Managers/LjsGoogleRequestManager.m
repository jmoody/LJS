#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleRequestManager.h"
#import "Lumberjack.h"
#import "LjsFoundationCategories.h"
#import "LjsWebCategories.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+LjsAdditions.h"
#import "LjsGooglePlacesPredictiveReply.h"
#import "LjsGooglePlacesDetailsReply.h"
#import "LjsGooglePlacesPrediction.h"
#import "LjsGooglePlacesNmoDetails.h"
#import "LjsGoogleRgReply.h"
#import "LjsLocationManager.h"
#import "LjsGoogleRequestFactory.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif




@interface LjsGoogleRequestManager ()

@property (nonatomic, strong) LjsGoogleRequestFactory *requestFactory;

- (void) handleRequestAutocompleteDidFinish:(ASIHTTPRequest *) aRequest;
- (void) handleRequestAutocompleteDidFail:(ASIHTTPRequest *)aRequest;

- (void) handleRequestDetailsDidFinish:(ASIHTTPRequest *) aRequest;
- (void) handleRequestDetailsDidFail:(ASIHTTPRequest *) aRequest;

- (void) handleRequestDidFail:(ASIHTTPRequest *) aRequest;
- (void) handleRequestDidFinish:(ASIHTTPRequest *) aRequest;

@end



@implementation LjsGoogleRequestManager

@synthesize apiToken;
@synthesize placeResultHandler;
@synthesize reverseGeocodeHandler;
@synthesize requestFactory;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}


- (id) initWithApiToken:(NSString *)aApiToken {
  self = [super init];
  if (self) {
    self.apiToken = aApiToken;
    self.requestFactory = [[LjsGoogleRequestFactory alloc] initWithApiToken:aApiToken];
    self.placeResultHandler = nil;
    self.reverseGeocodeHandler = nil;
  }
  return self;
}



- (void) executeHttpPredictionRequestWithInput:(NSString *) aInput
                                        radius:(CGFloat) aRadius
                                      location:(LjsLocation *)aLocation 
                                 languageOrNil:(NSString *) aLangCode
                          establishmentRequest:(BOOL) aIsAnEstablishmentRequest {
  ASIHTTPRequest *request;
  request = [self.requestFactory requestForAutocompleteWithInput:aInput
                                                        latitude:aLocation.latitude
                                                       longitude:aLocation.longitude
                                                          radius:aRadius
                                               languageCodeOrNil:aLangCode
                                                   establishment:aIsAnEstablishmentRequest];
  
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestAutocompleteDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestAutocompleteDidFinish:)];
  //DDLogDebug(@"starting request: %@", request);
  [request startAsynchronous];
}


- (void) handleRequestAutocompleteDidFail:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"autocomplete did fail");
  NSURL *url = [aRequest url];
  DDLogDebug(@"url = %@", url);
  NSUInteger code = [aRequest responseCode];
  [self.placeResultHandler requestForPredictionsFailedWithCode:code 
                                                       request:aRequest];
  
  
}

- (void) handleRequestAutocompleteDidFinish:(ASIHTTPRequest *) aRequest {
  //DDLogDebug(@"autocomplete request did finish");
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestAutocompleteDidFail:aRequest];
    return;
  }
  NSError *error = nil;
  LjsGooglePlacesPredictiveReply *reply = [[LjsGooglePlacesPredictiveReply alloc]
                                           initWithReply:[aRequest responseString]
                                           error:&error];
  if ([reply statusRejected] == YES) {
    [self.placeResultHandler requestForPredictionsFailedWithCode:[reply status]
                                                      reply:reply
                                                      error:error];
  } else {
    [self.placeResultHandler requestForPredictionsCompletedWithPredictions:[reply predictions]
                                                             userInfo:aRequest.userInfo];
    //NSURL *url = [aRequest url];
    //DDLogDebug(@"url = %@", url);
  }
}

- (void) executeHttpDetailsRequestionForPrediction:(LjsGooglePlacesPrediction *) aPrediction
                                          language:(NSString *)aLangCode {

  
  ASIHTTPRequest *request = [self.requestFactory requestForDetailsRequestForPrediction:aPrediction
                                                                              language:aLangCode];
  
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestDetailsDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestDetailsDidFinish:)];
  [request startAsynchronous];
}


- (void) handleRequestDetailsDidFail:(ASIHTTPRequest *)aRequest {
  //DDLogDebug(@"autocomplete did fail");
  NSUInteger code = [aRequest responseCode];
  [self.placeResultHandler requestForDetailsFailedWithCode:code
                                              request:aRequest];
  
}

- (void) handleRequestDetailsDidFinish:(ASIHTTPRequest *)aRequest {
  //DDLogDebug(@"autocomplete request did finish");
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestDetailsDidFail:aRequest];
    return;
  }
  NSError *error = nil;
  LjsGooglePlacesDetailsReply *reply = [[LjsGooglePlacesDetailsReply alloc]
                                        initWithReply:[aRequest responseString]
                                        error:&error];
  if ([reply statusRejected] == YES) {
    [self.placeResultHandler requestForDetailsFailedWithCode:[reply status]
                                                  reply:reply
                                                  error:error];
  } else {
    [self.placeResultHandler requestForDetailsCompletedWithDetails:[reply details]
                                                     userInfo:aRequest.userInfo];
  }
}


- (void) executeHttpReverseGeocodeRequestForLocation:(LjsLocation *) aLocation
                                locationIsFromSensor:(BOOL) aLocIsFromSensor {
  if ([LjsLocationManager isValidLocation:aLocation] == NO) {
    DDLogError(@"location: %@ needs to be valid - nothing to do", aLocation);
              
    return;
  }
  
  ASIHTTPRequest *request = [self.requestFactory requestForReverseGeocodeWithLocation:aLocation
                                                                 locationIsFromSensor:aLocIsFromSensor];
  
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestDidFinish:)];
  [request startAsynchronous];
}



- (void) handleRequestDidFail:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"request id fail");
  NSURL *url = [aRequest url];
  DDLogDebug(@"url = %@", url);
  NSUInteger code = [aRequest responseCode];
  [self.reverseGeocodeHandler requestForReverseGeocodeFailedWithCode:code
                                                     request:aRequest];
}

- (void) handleRequestDidFinish:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"request did finish");
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestDidFail:aRequest];
    return;
  }
  NSError *error = nil;
  LjsGoogleRgReply *reply = [[LjsGoogleRgReply alloc]
                             initWithReply:[aRequest responseString]
                             error:&error];
  DDLogDebug(@"reply = %@", reply);
  if ([reply statusRejected] == YES) {
    [self.reverseGeocodeHandler requestForReverseGeocodeFailedWithCode:[reply status]
                                                       request:aRequest
                                                         error:error];
    
    
  } else {
    //    DDLogDebug(@"response = %@", [aRequest responseString]);
    
    NSArray *geos = [reply geocodes];
    [self.reverseGeocodeHandler requestForReverseGeocodeCompletedWithResult:geos
                                                           userInfo:aRequest.userInfo];
    
    //NSURL *url = [aRequest url];
    //DDLogDebug(@"url = %@", url);
  }
  
}


@end
