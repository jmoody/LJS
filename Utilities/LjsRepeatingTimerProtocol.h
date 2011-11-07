#import <Foundation/Foundation.h>

@protocol LjsRepeatingTimerProtocol <NSObject>

@required
- (void) stopAndReleaseRepeatingTimers;
- (void) startAndRetainRepeatingTimers;

@optional

@end
