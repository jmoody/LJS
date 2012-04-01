#import "_LjsGoogleThing.h"

@class  LjsLocation;

@interface LjsGoogleThing : _LjsGoogleThing {}

- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitude;
- (NSDecimalNumber *) longitude;
- (NSString *) locationString;
- (LjsLocation *) location;

@end
