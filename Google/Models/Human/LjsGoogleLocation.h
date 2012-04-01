#import "_LjsGoogleLocation.h"
#import "LjsLocationManager.h"

@class LjsGoogleThing;

@interface LjsGoogleLocation : _LjsGoogleLocation {}

+ (LjsLocation *) initWithPoint:(CGPoint) aPoint
                          thing:(LjsGoogleThing *) aThing
                        context:(NSManagedObjectContext *) aContext;


- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) locationStr;
- (NSDecimalNumber *) latitudeDnWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeDnWithScael:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeDN;
- (NSDecimalNumber *) longitudeDN;
- (CGFloat) latitude;
- (void) setLatitude:(CGFloat) aValue;
- (CGFloat) longitude;
- (void) setLongitude:(CGFloat) aValue;
- (LjsLocation) location;


@end
