#import <Foundation/Foundation.h>

/**
 Documentation
 */
@interface LjsGoogleImporter : NSObject 

/** @name Properties */

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (NSArray *) addressComponentsWithDictionary:(NSDictionary *) aDictionary;
- (CGPoint) pointForLocationWithDictionary:(NSDictionary *) aDictionary;
- (CGPoint) pointWithLatLonDictionary:(NSDictionary *) aLatLonDict;

@end
