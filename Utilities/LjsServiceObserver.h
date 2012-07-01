#import <Foundation/Foundation.h>
#import "LjsRepeatingTimerProtocol.h"

/**
 Documentation
 */
@interface LjsServiceObserver : NSObject <LjsRepeatingTimerProtocol> {
    
}

@property (nonatomic, strong) NSTimer *repeatingTimer;
@property (nonatomic, assign) NSTimeInterval timerFrequency;
@property (nonatomic, assign) NSUInteger numberOfTimesToRepeat;
@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, assign) BOOL shouldRefuseToRestart;
@property (nonatomic, assign) BOOL stateVariable;

- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency;

- (id) initWithTimerFrequency:(NSTimeInterval) aTimerFrequency
                timesToRepeat:(NSUInteger) aTimesToRepeat;

- (void) doRepeatedAction:(NSTimer *) aTimer;

@end
