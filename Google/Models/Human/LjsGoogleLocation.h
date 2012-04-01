#import "_LjsGoogleLocation.h"
#import "LjsLocationManager.h"
@class LjsGoogleThing;

@interface LjsGoogleLocation : _LjsGoogleLocation {}

+ (LjsGoogleLocation *) initWithPoint:(CGPoint) aPoint
                                 type:(NSString *) aType
                                thing:(LjsGoogleThing *) aThing
                              context:(NSManagedObjectContext *) aContext;

- (CGFloat) latitude;
- (void) setLatitude:(CGFloat) aValue;
- (CGFloat) longitude;
- (void) setLongitude:(CGFloat) aValue;

- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeDnWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeDnWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeDN;
- (NSDecimalNumber *) longitudeDN;
- (LjsLocation) location;
- (NSString *) locationString;


@end
