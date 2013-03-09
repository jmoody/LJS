#import <Cocoa/Cocoa.h>
#import "TpUnixOperation.h"

@interface LjsUnixAppDelegate : NSObject
<NSApplicationDelegate, TpUnixOperationCallbackDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSOperationQueue *opqueue;
@property (nonatomic, retain) TpUnixOperation *longRunningFindOp;
@property (nonatomic, retain) NSTimer *cancelOpTimer;


#pragma mark Tests
- (void) doLsTest;
- (void) doLongRunningFindWithCancelSignalSentToOperation;
- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer;
- (void) doLocateOperation;
- (void) doFindOperation;
- (void) doIpconfigGetIfaddr;
- (void) doCommandThatWillFail;
- (void) doChangeNetwork:(BOOL) aShouldTurnOn;
- (void) doReadDefaultsForAirDrop;


@end
