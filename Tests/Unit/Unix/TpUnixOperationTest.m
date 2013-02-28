#import "LjsTestCase.h"
#import "TpUnixOperation.h"
#import "LjsRepeatingTimerProtocol.h"


static NSString *TpUnixOperationTestsCommandLs = @"ls";
static NSString *TpUnixOperationTestsCommandLongRunningFind = @"long running find";
static NSString *TpUnixOperationTestsCommandLocate = @"locate .DS_Store";
static NSString *TpUnixOperationTestsCommandFind = @"find UnixOperationTests.app";
static NSString *TpUnixOperationTestsIpconfigGetIfaddr = @"ipconfig getifaddr";
static NSString *TpUnixOperationTestsIfconfigUpOrDown = @"ifconfig up/down";
static NSString *TpUnixOperationTestsDoCommandThatWillFail = @"ifconfig purposely to fail";
static NSString *TpUnixOperationTestsDoAirDropRead = @"airdrop read";

@interface TpUnixOperationTest : LjsTestCase
<LjsRepeatingTimerProtocol,
TpUnixOperationCallbackDelegate> {}

@property (nonatomic, strong) NSOperationQueue *opqueue;
@property (nonatomic, strong) TpUnixOperation *longRunningFindOp;
@property (nonatomic, strong) NSTimer *cancelOpTimer;

// protocol
- (void) operationCompletedWithName:(NSString *) aName
                             result:(TpUnixOperationResult *) aResult;

- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer;

@end


@implementation TpUnixOperationTest

- (void) stopAndReleaseRepeatingTimers {
  GHTestLog(@"stopping long running find timer");
  if (self.cancelOpTimer != nil) {
    [self.cancelOpTimer invalidate];
    self.cancelOpTimer = nil;
  }
}

- (void) startAndRetainRepeatingTimers {
  GHTestLog(@"starting long running find timer");
  if (self.cancelOpTimer != nil) {
    [self.cancelOpTimer invalidate];
    self.cancelOpTimer = nil;
  }
  
  
  self.cancelOpTimer =
  [NSTimer scheduledTimerWithTimeInterval:5.0
                                   target:self
                                 selector:@selector(handleCancelOperationTimerEvent:)
                                 userInfo:nil
                                  repeats:YES];
}

- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer {
  GHTestLog(@"handling cancel operation timer event - cancelling long running find");
  [self.longRunningFindOp cancel];
  [self stopAndReleaseRepeatingTimers];
  self.longRunningFindOp = nil;
}

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return YES;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
  self.opqueue = [[NSOperationQueue alloc] init];
}

- (void) tearDown {
  // Run after each test method
  [self stopAndReleaseRepeatingTimers];
  self.longRunningFindOp = nil;
  self.opqueue = nil;
  [super tearDown];
}


- (void) operationCompletedWithName:(NSString *) aName
                             result:(TpUnixOperationResult *) aResult {
  GHTestLog(@"operation %@ completed with %@", aName, aResult);
  if ([TpUnixOperationTestsCommandLs isEqualToString:aName]) {
    // nothing to test
  } else if ([TpUnixOperationTestsCommandLongRunningFind isEqualToString:aName]) {
    //DDLogError(@"did not expect this to finish before it was cancelled");
    // lets see what we found
    GHTestLog(@"find results before cancel = %@", aResult);
    
  } else if ([TpUnixOperationTestsCommandLocate isEqualToString:aName]) {
    GHTestLog(@"no test available");
  } else if ([TpUnixOperationTestsCommandFind isEqualToString:aName]) {
    BOOL result = [aResult.stdOutput isEqualToString:@"./UnixOperationTests.app"];
    GHAssertTrue(result, nil);
  } else if ([TpUnixOperationTestsIpconfigGetIfaddr isEqualToString:aName]) {
    GHTestLog(@"no conclusive test possible");
  } else if ([TpUnixOperationTestsIfconfigUpOrDown isEqualToString:aName]) {
    GHTestLog(@"no conclusive test possible");
  } else if ([TpUnixOperationTestsDoCommandThatWillFail isEqualToString:aName]) {
    BOOL result = [aResult.errOutput isEqualToString:@"ifconfig: interface status does not exist"];
    GHAssertTrue(result, nil);
  } else if ([TpUnixOperationTestsDoAirDropRead isEqualToString:aName]) {
    GHTestLog(@"result = %@", aResult);
  } else {
    GHTestLog(@"unknown common name: %@", aName);
    GHAssertTrue(NO, nil);
  }
}


- (void) test_ls {
  NSString *command = @"/bin/ls";
  NSArray *args = [NSArray arrayWithObject:@"-al"];
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandLs
                           callbackDelegate:self];
  [self.opqueue addOperation:uop];
}

- (void) test_command_failed {
  NSString *command = @"/sbin/ifconfig";
  NSArray *args = [NSArray arrayWithObjects:@"status", nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsDoCommandThatWillFail
                          callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
}


//- (void) doLongRunningFindWithCancelSignalSentToOperation {
//  NSString *command = @"/usr/bin/find";
//  NSArray *args = [NSArray arrayWithObjects:@"/", @"-name", @".DS_Store", @"-print", nil];
//  
//  
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsCommandLongRunningFind
//                           callbackDelegate:self]  autorelease];
//  
//  self.longRunningFindOp = uop;
//  
//  [self startAndRetainRepeatingTimers];
//  [self.opqueue addOperation:uop];
//  
//}
//
//- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer {
//  DDLogDebug(@"handling cancel operation timer event - cancelling long running find");
//  [self.longRunningFindOp cancel];
//  [self stopAndReleaseRepeatingTimers];
//  self.longRunningFindOp = nil;
//}
//
//- (void) doLocateOperation {
//  NSString *command = @"/usr/bin/locate";
//  NSArray *args = [NSArray arrayWithObjects:@"-s", @".DS_Store", nil];
//  
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsCommandLocate
//                           callbackDelegate:self] autorelease];
//  
//  
//  [self.opqueue addOperation:uop];
//}
//
//- (void) doFindOperation {
//  NSString *command = @"/usr/bin/find";
//  NSArray *args = [NSArray arrayWithObjects:@".", @"-name",
//                   @"UnixOperationTests.app", @"-print", nil];
//  
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsCommandFind
//                           callbackDelegate:self]  autorelease];
//  
//  [self.opqueue addOperation:uop];
//}
//
//
//- (void) doIpconfigGetIfaddr {
//  ///usr/sbin/ipconfig
//  //ipconfig getifaddr en1
//  NSString *command = @"/usr/sbin/ipconfig";
//  NSArray *args = [NSArray arrayWithObjects:@"getifaddr", TpNetworkInterfaceDefault, nil];
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsIpconfigGetIfaddr
//                           callbackDelegate:self]  autorelease];
//  
//  [self.opqueue addOperation:uop];
//}
//
//- (void) doChangeNetwork:(BOOL) aShouldTurnOn {
//  NSString *upOrDown;
//  if (aShouldTurnOn == YES) {
//    upOrDown = @"on";
//  } else {
//    upOrDown = @"down";
//  }
//  NSString *command = @"/usr/bin/sudo";
//  NSArray *args = [NSArray arrayWithObjects:@"ifconfig", TpNetworkInterfaceDefault,
//                   upOrDown, nil];
//  
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsIfconfigUpOrDown
//                           callbackDelegate:self] autorelease];
//  
//  [self.opqueue addOperation:uop];
//  
//}
//
//
//
//- (void) doReadDefaultsForAirDrop {
//  //com.apple.NetworkBrowser BrowseAllInterfaces
//  
//  NSString *command = @"/usr/bin/defaults";
//  NSArray *args = [NSArray arrayWithObjects:@"read", @"com.apple.NetworkBrowser", @"BrowseAllInterfaces", nil];
//  
//  TpUnixOperation *uop = [[[TpUnixOperation alloc]
//                           initWithLaunchPath:command
//                           launchArgs:args
//                           commonName:TpUnixOperationTestsDoAirDropRead
//                           callbackDelegate:self]  autorelease];
//  
//  [self.opqueue addOperation:uop];
//}


@end
