#import "_LjsGoogleThing.h"
#import "LjsLocationManager.h"

@interface LjsGoogleThing : _LjsGoogleThing {}


- (CGFloat) orderValue;
- (void) setOrderValue:(CGFloat) aValue;


- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeDnWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeDnWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeDN;
- (NSDecimalNumber *) longitudeDN;
- (LjsLocation) location;
- (NSString *) locationString;

@end
