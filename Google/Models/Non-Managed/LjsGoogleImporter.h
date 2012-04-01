#import <Foundation/Foundation.h>

@class LjsLocation;
/**
 Documentation
 */
@interface LjsGoogleImporter : NSObject 

/** @name Properties */

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (NSArray *) addressComponentsWithDictionary:(NSDictionary *) aDictionary;
- (LjsLocation *) locationWithDictionary:(NSDictionary *) aDictionary;
- (LjsLocation *) locationWithLatLonDictionary:(NSDictionary *) aLatLonDict;

@end
