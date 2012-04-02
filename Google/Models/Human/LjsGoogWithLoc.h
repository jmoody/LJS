#import "_LjsGoogWithLoc.h"

@class LjsLocation;

@interface LjsGoogWithLoc : _LjsGoogWithLoc {}


- (NSString *) latitudeStringWithScale:(NSUInteger) aScale;
- (NSString *) longitudeStringWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitudeWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) longitudeWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) latitude;
- (NSDecimalNumber *) longitude;
- (NSString *) locationString;
- (LjsLocation *) location;


@end
