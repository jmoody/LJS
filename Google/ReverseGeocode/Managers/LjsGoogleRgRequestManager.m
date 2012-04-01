#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleRgRequestManager.h"
#import "Lumberjack.h"
#import "LjsWebCategories.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+LjsAdditions.h"
#import "LjsGoogleRgReply.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsGoogleReverseGeocodeUrl = @"https://maps.googleapis.com/maps/api/geocode/json";

@interface LjsGoogleRgRequestManager ()

- (void) handleRequestDidFail:(ASIHTTPRequest *) aRequest;
- (void) handleRequestDidFinish:(ASIHTTPRequest *) aRequest;


@end

@implementation LjsGoogleRgRequestManager

@synthesize resultHandler;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithApiToken:(NSString *)aApiToken {
//  [self doesNotRecognizeSelector:_cmd];
//  return nil;
  self = [super initWithApiToken:aApiToken];
  if (self) {
    self.resultHandler = self;
  }
  return self;
}

- (id) initWithApiToken:(NSString *)aApiToken 
          resultHandler:(id<LjsGoogleRgRequestHandlerDelegate>)aResultHandler {
  self = [super initWithApiToken:aApiToken];
  if (self) {
    self.resultHandler = aResultHandler;
  }
  return self;
}



- (void) executeReverseGeocodeRequestForLocation:(LjsLocation) aLocation
                            locationIsFromSensor:(BOOL) aLocIsFromSensor {
  if ([LjsLocationManager isValidLocation:aLocation] == NO) {
    DDLogError(@"location: %@ needs to be valid - nothing to do",
               NSStringFromLjsLocation(aLocation));
    return;
  }
  
  NSString *sensor = [self stringForSensor:aLocIsFromSensor];
  NSString *latlong = [NSString stringWithFormat:@"%f,%f",
                       aLocation.latitude, aLocation.longitude];
  NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             sensor, @"sensor",
                             latlong, @"latlng",
                              nil];
  NSString *params = [paramDict stringByParameterizingForUrl];
  NSString *path = [NSString stringWithFormat:@"%@%@",
                    LjsGoogleReverseGeocodeUrl, params];
  NSURL *url = [NSURL URLWithString:path];
  DDLogDebug(@"url = %@", url);
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                             initWithURL:url];
  
  [request setRequestMethod:@"GET"];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setDelegate:self];
  [request setDidFailSelector:@selector(handleRequestDidFail:)];
  [request setDidFinishSelector:@selector(handleRequestDidFinish:)];
  [request setUserInfo:paramDict];
  [request startAsynchronous];
  
  

}



- (void) handleRequestDidFail:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"request id fail");
  NSURL *url = [aRequest url];
  DDLogDebug(@"url = %@", url);
  NSUInteger code = [aRequest responseCode];
  [self.resultHandler requestForReverseGeocodeFailedWithCode:code
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
    [self.resultHandler requestForReverseGeocodeFailedWithCode:[reply status]
                                                       request:aRequest
                                                         error:error];
    
    
  } else {
//    DDLogDebug(@"response = %@", [aRequest responseString]);

    NSArray *geos = [reply geocodes];
    [self.resultHandler requestForReverseGeocodeCompletedWithResult:geos
                                                           userInfo:aRequest.userInfo];
    
    //NSURL *url = [aRequest url];
    //DDLogDebug(@"url = %@", url);
  }

}

- (void) requestForReverseGeocodeCompletedWithResult:(NSArray *) aResult
                                            userInfo:(NSDictionary *) aUserInfo {
  DDLogDebug(@"results = %@", aResult);
  DDLogDebug(@"user info = %@", aUserInfo);
  
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


@end
