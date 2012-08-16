#import "LjsServiceObserver.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSUInteger LjsServiceAvailableMaxNumberOfTimesToPoll = UINT_MAX; 

@implementation LjsServiceObserver

@synthesize repeatingTimer;
@synthesize timerFrequency;
@synthesize numberOfTimesToRepeat;
@synthesize repeatCount;
@synthesize shouldRefuseToRestart;
@synthesize stateVariable;

#pragma mark Memory Management

- (void) dealloc {
  // a little strange, but we do nothing here because we manage in the stop
  // and start methods. 
  // DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency {
  self = [super init];
  if (self != nil) {
    self.timerFrequency = aTimerFrequency;
    self.repeatingTimer = nil;
    self.numberOfTimesToRepeat = LjsServiceAvailableMaxNumberOfTimesToPoll;
    self.repeatCount = 0;
    self.shouldRefuseToRestart = NO;
    self.stateVariable = NO;
  }
  return self;
}

- (id) initWithTimerFrequency:(NSTimeInterval) aTimerFrequency
                timesToRepeat:(NSUInteger) aTimesToRepeat {
  self = [super init];
  if (self != nil) {
    self.timerFrequency = aTimerFrequency;
    self.repeatingTimer = nil;
    self.numberOfTimesToRepeat = aTimesToRepeat;
    self.repeatCount = 0;
    self.shouldRefuseToRestart = NO;
    self.stateVariable = NO;
  }
  return self;
}


#pragma mark LjsRepeatingTimerProtocol

- (void) stopAndReleaseRepeatingTimers {
  DDLogDebug(@"stopping and releasing repeating timer");
  if (self.repeatingTimer != nil) {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
    self.stateVariable = NO;
  } else {
    DDLogNotice(@"called stop and release before the timer has been started - ignoring");
  }
}

- (void) startAndRetainRepeatingTimers {
  DDLogDebug(@"attempting to start and retain a repeating timer");
  if (self.repeatingTimer != nil) {
    DDLogError(@"trying to start a timer that is already running - not allowed");
  } else if (self.shouldRefuseToRestart == YES) {
    DDLogError(@"trying to start a timer that has been stopped already - not allowed");
  } else  if (self.shouldRefuseToRestart == NO) {
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerFrequency
                                                           target:self 
                                                         selector:@selector(doRepeatedAction:) 
                                                         userInfo:nil 
                                                          repeats:YES];
    self.stateVariable = NO;
  } else {
    DDLogError(@"should never reach here - timer is not started");
  }
}


- (void) doRepeatedAction:(NSTimer *)aTimer {
  DDLogError(@"this method should be overridden by subclass");
}




@end
