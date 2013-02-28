#import "TpUnixWhich.h"
#import "Lumberjack.h"
#import "TpUnixOperation.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *TpUnixWhichWhichLaunchPath = @"/usr/bin/which";

static NSString *TpUnixWhichIfconfig = @"ifconfig";
static NSString *TpUnixWhichIfconfigDefaultLaunchPath = @"/sbin/ifconfig";
static NSString *TpUnixWhichIfconfigCommandName = @"me.twistedpair.TwistedPair which ifconfig";

static NSString *TpUnixWhichIpconfig = @"ipconfig";
static NSString *TpUnixWhichIpconfigDefaultLaunchPath = @"/usr/sbin/ipconfig";
static NSString *TpUnixWhichIpconfigCommandName = @"me.twistedpair.TwistedPair which ipconfig";

static NSString *TpUnixWhichDefaults = @"defaults";
static NSString *TpUnixWhichDefaultDefaultsLaunchPath = @"/usr/bin/defaults";
static NSString *TpUnixWhichDefaultsCommandName = @"me.twistedpair.TwistedPair which defaults";

@implementation TpUnixWhich

@synthesize ifconfigLaunchPath;
@synthesize ipconfigLaunchPath;
@synthesize defaultsLaunchPath;
@synthesize opqueue;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating TpUnixWhich");
  [self.opqueue cancelAllOperations];
  self.opqueue = nil;
  self.ifconfigLaunchPath = nil;
  self.ipconfigLaunchPath = nil;
  self.defaultsLaunchPath = nil;
  [super dealloc];
}

- (id) init {
  self = [super init];
  if (self != nil) {
  
    self.ifconfigLaunchPath = TpUnixWhichIfconfigDefaultLaunchPath;
    self.ipconfigLaunchPath = TpUnixWhichIpconfigDefaultLaunchPath;
    self.defaultsLaunchPath = TpUnixWhichDefaultDefaultsLaunchPath;
    
    self.opqueue = [[[NSOperationQueue alloc]
                     init] autorelease];
    
    [self asyncFindIfConfigLaunchPath];
    [self asyncFindIpConfigLaunchPath];
    [self asyncFindDefaultsLaunchPath];
  }
  return self;
}

#pragma mark Unix Operation Callback Delegate
/** @name TpUnixOperationCallbackDelegate Protocol */
/**
 A callback that the TpUnixOperation will use to deliver results at the end
 of execution.
 
 The name parameter is a unique id that the callback delegate can use to 
 discern what operation completion prompted the callback.
 
 There is no special error handling - here failure is not a disaster because
 we can fall back on the hardcoded command paths.
 
 @param aName the name of the operation that completed
 @param aResult the result of the operation
 @warning could use a refactor to reduce code duplication.
 */
- (void) operationCompletedWithName:(NSString *)aName result:(TpUnixOperationResult *)aResult {
  DDLogDebug(@"operation %@ completed", aName);
  if ([TpUnixWhichIfconfigCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting ifconfig launch path to %@", aResult.stdOutput);
      self.ifconfigLaunchPath = aResult.stdOutput;
    }
  } else if ([TpUnixWhichIpconfigCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting ifconfig launch path to %@", aResult.stdOutput);
      self.ipconfigLaunchPath = aResult.stdOutput;
    }
  } else if ([TpUnixWhichDefaultsCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting defaults launch path to %@", aResult.stdOutput);
      self.defaultsLaunchPath = aResult.stdOutput;
    }
  } else {
    DDLogError(@"unknown common name = %@", aName);
    //NSAssert(NO, nil);
  }
}


- (void) asyncFindIfConfigLaunchPath {
  DDLogDebug(@"starting async find of ifconfig launch path");
  TpUnixOperation *uop = [[[TpUnixOperation alloc]
                           initWithLaunchPath:TpUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:TpUnixWhichIfconfig]
                           commonName:TpUnixWhichIfconfigCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}

- (void) asyncFindIpConfigLaunchPath {
  DDLogDebug(@"starting async find of ipconfig launch path");
  TpUnixOperation *uop = [[[TpUnixOperation alloc]
                           initWithLaunchPath:TpUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:TpUnixWhichIpconfig]
                           commonName:TpUnixWhichIpconfigCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}

- (void) asyncFindDefaultsLaunchPath {
  DDLogDebug(@"starting async find of defaults launch path");
  TpUnixOperation *uop = [[[TpUnixOperation alloc]
                           initWithLaunchPath:TpUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:TpUnixWhichDefaults]
                           commonName:TpUnixWhichDefaultsCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}


@end
