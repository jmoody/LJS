#import <Foundation/Foundation.h>
#import "LjsServiceObserver.h"

extern NSString *LjsLocationServicesStatusTimedOutNotification;
extern NSString *LjsLocationServicesStatusChangedNotification;
extern NSString *LjsLocationServicesStatusChangeStateUserInfoKey;

@interface LjsLocationServiceObserver : LjsServiceObserver 

- (NSDictionary *) userInfoWithState:(BOOL) state;
@end
