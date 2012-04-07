#import <Foundation/Foundation.h>
#import "LjsServiceObserver.h"

@class LjsLocationManager;

extern NSString *LjsLocationServicesStatusTimedOutNotification;
extern NSString *LjsLocationServicesStatusChangedNotification;
extern NSString *LjsLocationServicesStatusChangeStateUserInfoKey;

@interface LjsLocationServiceObserver : LjsServiceObserver 

- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency
              locationManager:(LjsLocationManager *) aManager;

- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency 
                timesToRepeat:(NSUInteger)aTimesToRepeat
              locationManager:(LjsLocationManager *) aManager;

- (NSDictionary *) userInfoWithState:(BOOL) state;
@end
