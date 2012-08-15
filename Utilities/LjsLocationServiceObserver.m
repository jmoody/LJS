#import "LjsLocationServiceObserver.h"
#import "Lumberjack.h"
#import "LjsLocationManager.h"


NSString *LjsLocationServicesStatusTimedOutNotification = @"com.littlejoysoftware.LJS Location Services Status Timed Out Notification";
NSString *LjsLocationServicesStatusChangedNotification = @"com.littlejoysoftware.LJS Location Services Status Changed Notification";
NSString *LjsLocationServicesStatusChangeStateUserInfoKey = @"com.littlejoysoftware.LJS Location Services Status Changed State UserInfo Key";


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsLocationServiceObserver ()

@property (nonatomic, strong) LjsLocationManager *locationManager;

@end

@implementation LjsLocationServiceObserver

@synthesize locationManager;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

// need to pass a location manager
- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency {
 //  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

// need to pass a location manager
- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency 
                timesToRepeat:(NSUInteger)aTimesToRepeat {
 //  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency 
              locationManager:(LjsLocationManager *) aManager {
  self = [super initWithTimerFrequency:aTimerFrequency];
  if (self != nil) {
    self.locationManager = aManager;
  }
  return self;
}

- (id) initWithTimerFrequency:(NSTimeInterval) aTimerFrequency
                timesToRepeat:(NSUInteger) aTimesToRepeat 
              locationManager:(LjsLocationManager *)aManager {
  self = [super initWithTimerFrequency:aTimerFrequency timesToRepeat:aTimesToRepeat];
  if (self != nil) {
    self.locationManager = aManager;
  }
  return self;
}

- (void) doRepeatedAction:(NSTimer *)aTimer {
  if (self.repeatCount < self.numberOfTimesToRepeat) {
    BOOL newLocationServicesState = [self.locationManager locationIsAvailable];
    if (newLocationServicesState != self.stateVariable) {
      DDLogDebug(@"location service state change from %d to %d", self.stateVariable, 
                 newLocationServicesState);
       [[NSNotificationCenter defaultCenter]
       postNotificationName:LjsLocationServicesStatusChangedNotification
       object:nil
        userInfo:[self userInfoWithState:newLocationServicesState]];
      self.stateVariable = newLocationServicesState;
    } else {
      DDLogDebug(@"no change in location service state: %d", self.stateVariable);
    }
    self.repeatCount = self.repeatCount + 1;
  } else {
    DDLogDebug(@"timer has completed - stopping and releasing");
    
    [self stopAndReleaseRepeatingTimers];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LjsLocationServicesStatusTimedOutNotification
     object:nil
     userInfo:[self userInfoWithState:self.stateVariable]];
  }
}

- (NSDictionary *) userInfoWithState:(BOOL) state {
  NSNumber *number = [NSNumber numberWithBool:state];
  NSDictionary *userInfo = 
  [NSDictionary dictionaryWithObject:number
                              forKey:LjsLocationServicesStatusChangeStateUserInfoKey];
  return userInfo;
}


@end
