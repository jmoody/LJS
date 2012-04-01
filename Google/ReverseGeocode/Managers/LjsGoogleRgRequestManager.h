#import <Foundation/Foundation.h>
#import "LjsGoogleRequestManager.h"
#import "LjsLocationManager.h"

@class ASIHTTPRequest;

@protocol LjsGoogleRgRequestHandlerDelegate <NSObject>

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
@interface LjsGoogleRgRequestManager : LjsGoogleRequestManager
<LjsGoogleRgRequestHandlerDelegate>

/** @name Properties */
@property (nonatomic, assign) id<LjsGoogleRgRequestHandlerDelegate> resultHandler;

/** @name Initializing Objects */
- (id) initWithApiToken:(NSString *) aApiToken
          resultHandler:(id<LjsGoogleRgRequestHandlerDelegate>) aResultHandler;
            

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (void) executeReverseGeocodeRequestForLocation:(LjsLocation) aLocation
                            locationIsFromSensor:(BOOL) aLocIsFromSensor;

@end
