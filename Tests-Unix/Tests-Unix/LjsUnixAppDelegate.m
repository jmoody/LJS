#import "LjsUnixAppDelegate.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#ifdef USE_EN0
static NSString *TpNetworkInterfaceDefault = @"en0";
#elif USE_EN1
static NSString *TpNetworkInterfaceDefault = @"en1";
#else
static NSString *TpNetworkInterfaceDefault = @"FIXME";
#endif


static NSString *TpUnixOperationTestsCommandLs = @"ls";
static NSString *TpUnixOperationTestsCommandLongRunningFind = @"long running find";
static NSString *TpUnixOperationTestsCommandLocate = @"locate .DS_Store";
static NSString *TpUnixOperationTestsCommandFind = @"find UnixOperationTests.app";
static NSString *TpUnixOperationTestsIpconfigGetIfaddr = @"ipconfig getifaddr";
static NSString *TpUnixOperationTestsIfconfigUpOrDown = @"ifconfig up/down";
static NSString *TpUnixOperationTestsDoCommandThatWillFail = @"ifconfig purposely to fail";
static NSString *TpUnixOperationTestsDoAirDropRead = @"airdrop read";


@implementation LjsUnixAppDelegate

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self stopAndReleaseRepeatingTimers];
  self.longRunningFindOp = nil;
}


- (void) stopAndReleaseRepeatingTimers {
  DDLogDebug(@"stopping long running find timer");
  if (self.cancelOpTimer != nil) {
    [self.cancelOpTimer invalidate];
    self.cancelOpTimer = nil;
  }
}

- (void) startAndRetainRepeatingTimers {
  DDLogDebug(@"starting long running find timer");
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



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  DDLogDebug(@"application did finish launching");
  
  self.opqueue = [[NSOperationQueue alloc] init];
  
 [self doLsTest];
//  [self doLongRunningFindWithCancelSignalSentToOperation];
//  [self doLocateOperation];
//  [self doFindOperation];
  
  
//  [self doIpconfigGetIfaddr];
//  [self doCommandThatWillFail];
//  [self doReadDefaultsForAirDrop];
//  
//  [self doChangeNetwork:NO];
  
}

- (void) operationCompletedWithName:(NSString *) aName
                             result:(TpUnixOperationResult *) aResult {
  DDLogDebug(@"operation %@ completed with %@", aName, aResult);
  if ([TpUnixOperationTestsCommandLs isEqualToString:aName]) {
    // nothing to test
  } else if ([TpUnixOperationTestsCommandLongRunningFind isEqualToString:aName]) {
    //DDLogError(@"did not expect this to finish before it was cancelled");
    // lets see what we found
    DDLogDebug(@"find results before cancel = %@", aResult);
    
  } else if ([TpUnixOperationTestsCommandLocate isEqualToString:aName]) {
    DDLogDebug(@"no test available");
  } else if ([TpUnixOperationTestsCommandFind isEqualToString:aName]) {
    BOOL result = [aResult.stdOutput isEqualToString:@"./UnixOperationTests.app"];
    NSAssert(result, nil);
  } else if ([TpUnixOperationTestsIpconfigGetIfaddr isEqualToString:aName]) {
    DDLogDebug(@"no conclusive test possible");
  } else if ([TpUnixOperationTestsIfconfigUpOrDown isEqualToString:aName]) {
    DDLogDebug(@"no conclusive test possible");
  } else if ([TpUnixOperationTestsDoCommandThatWillFail isEqualToString:aName]) {
    BOOL result = [aResult.errOutput isEqualToString:@"ifconfig: interface status does not exist"];
    NSAssert(result, nil);
  } else if ([TpUnixOperationTestsDoAirDropRead isEqualToString:aName]) {
    DDLogDebug(@"result = %@", aResult);
  } else {
    DDLogError(@"unknown common name: %@", aName);
    NSAssert(NO, nil);
  }
}

- (void) doLsTest {
  NSString *command = @"/bin/ls";
  NSArray *args = [NSArray arrayWithObject:@"-al"];
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandLs
                           callbackDelegate:self];
  [self.opqueue addOperation:uop];
  
}


- (void) doLongRunningFindWithCancelSignalSentToOperation {
  NSString *command = @"/usr/bin/find";
  NSArray *args = [NSArray arrayWithObjects:@"/", @"-name", @".DS_Store", @"-print", nil];
  
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandLongRunningFind
                           callbackDelegate:self];
  
  self.longRunningFindOp = uop;
  
  [self startAndRetainRepeatingTimers];
  [self.opqueue addOperation:uop];
  
}

- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer {
  DDLogDebug(@"handling cancel operation timer event - cancelling long running find");
  [self.longRunningFindOp cancel];
  [self stopAndReleaseRepeatingTimers];
  self.longRunningFindOp = nil;
}

- (void) doLocateOperation {
  NSString *command = @"/usr/bin/locate";
  NSArray *args = [NSArray arrayWithObjects:@"-s", @".DS_Store", nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandLocate
                           callbackDelegate:self];
  
  
  [self.opqueue addOperation:uop];
}

- (void) doFindOperation {
  NSString *command = @"/usr/bin/find";
  NSArray *args = [NSArray arrayWithObjects:@".", @"-name",
                   @"build", @"-print", nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandFind
                           callbackDelegate:self];
  DDLogDebug(@"op = %@", uop);
  
  [self.opqueue addOperation:uop];
}


- (void) doIpconfigGetIfaddr {
  ///usr/sbin/ipconfig
  //ipconfig getifaddr en1
  NSString *command = @"/usr/sbin/ipconfig";
  NSArray *args = [NSArray arrayWithObjects:@"getifaddr", TpNetworkInterfaceDefault, nil];
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsIpconfigGetIfaddr
                           callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
}

- (void) doChangeNetwork:(BOOL) aShouldTurnOn {
  NSString *upOrDown;
  if (aShouldTurnOn == YES) {
    upOrDown = @"on";
  } else {
    upOrDown = @"down";
  }
  NSString *command = @"/usr/bin/sudo";
  NSArray *args = [NSArray arrayWithObjects:@"ifconfig", TpNetworkInterfaceDefault,
                   upOrDown, nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsIfconfigUpOrDown
                           callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
  
}

- (void) doCommandThatWillFail {
  NSString *command = @"/sbin/ifconfig";
  NSArray *args = [NSArray arrayWithObjects:@"status", nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsDoCommandThatWillFail
                           callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
}

- (void) doReadDefaultsForAirDrop {
  //com.apple.NetworkBrowser BrowseAllInterfaces
  
  NSString *command = @"/usr/bin/defaults";
  NSArray *args = [NSArray arrayWithObjects:@"read", @"com.apple.NetworkBrowser", @"BrowseAllInterfaces", nil];
  
  TpUnixOperation *uop = [[TpUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsDoAirDropRead
                           callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
}



@end
