#import "_LjsGoogleLocation.h"
#import "LjsLocationManager.h"
@class LjsGoogWithLoc;
@class LjsLocation;

@interface LjsGoogleLocation : _LjsGoogleLocation {}

+ (LjsGoogleLocation *) initWithLocation:(LjsLocation *) aLocation
                                    type:(NSString *) aType
                                   owner:(LjsGoogWithLoc *) aOwner
                                 context:(NSManagedObjectContext *) aContext;


- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeWithScale:(NSUInteger) aScale;
- (NSString *) locationString;


@end
