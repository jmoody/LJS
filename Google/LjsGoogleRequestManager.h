#import <Foundation/Foundation.h>

/**
 Documentation
 */
@interface LjsGoogleRequestManager : NSObject 

/** @name Properties */
@property (nonatomic, copy) NSString *apiToken;

/** @name Initializing Objects */
- (id) initWithApiToken:(NSString *) aApiToken;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (NSString *) stringForSensor:(BOOL) aSensor;



@end
