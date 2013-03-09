#import "TpUnixOperation.h"
#import "Lumberjack.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

// the error domain
NSString *TpUnixOperationTaskErrorDomain = @"me.twistedpair.TwistedPair TpUnixOperation";
// that's my number
NSInteger const TpUnixOperationLaunchErrorCode = 5446;
// a sublime number
NSInteger const TpUnixOperationExecutionErrorCode = -4398116;
// open 24 hours
NSInteger const TpUnixOperationTaskStillRunningExitCode = 711;


@implementation TpUnixOperation

@synthesize commonName;
@synthesize standardOutput;
@synthesize standardError;
@synthesize outputClosed;
@synthesize errorClosed;
@synthesize taskComplete;
@synthesize task;
@synthesize trimSet;
@synthesize callbackDelegate;


#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating TpUnixOperation");
  //[[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:NSFileHandleDataAvailableNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:NSTaskDidTerminateNotification
                                                object:nil];
  self.commonName = nil;
  self.standardOutput = nil;
  self.standardError = nil;
  self.trimSet = nil;
  self.task = nil;
  [super dealloc];
}

/**
 Configures the task, sets up the pipes and file handles and registers for the
 appropriate notifications.
 
 @return an initialized receiver
 @param aLaunchPath the launch path of the unix command
 @param aLaunchArgs the arguments (as required by NSTask)
 @param aCommonName the name of this operation
 @param aCallbackDelegate the callback delegate
 */
- (id) initWithLaunchPath: (NSString *) aLaunchPath 
               launchArgs: (NSArray *) aLaunchArgs 
               commonName:(NSString *) aCommonName
         callbackDelegate:(id<TpUnixOperationCallbackDelegate>) aCallbackDelegate {
  self = [super init];
  if (self != nil) {
    self.commonName = aCommonName;
    self.outputClosed = NO;
    self.errorClosed = NO;
    self.taskComplete = NO;
    self.callbackDelegate = aCallbackDelegate;
    
    NSMutableData *data;
    data = [[NSMutableData alloc] init];
    self.standardOutput = data;
    [data release];
    data = [[NSMutableData alloc] init];
    self.standardError = data;
    [data release];
    
    NSTask *tTask = [[NSTask alloc] init];
    DDLogDebug(@"cur directory = %@", tTask.currentDirectoryPath);
    self.task = tTask;
    [tTask release];
    
    [self.task setLaunchPath:aLaunchPath];
    [self.task setArguments:aLaunchArgs];
    NSPipe *tPipe;
    tPipe = [[NSPipe alloc] init];
    [self.task setStandardOutput:tPipe];
    [tPipe release];
    tPipe = [[NSPipe alloc] init];
    [self.task setStandardError:tPipe];
    [tPipe release];
    
    // might consider making these ivars for memory reasons
    NSFileHandle *stdOut = [[self.task standardOutput] fileHandleForReading];
    NSFileHandle *stdErr = [[self.task standardError] fileHandleForReading];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(handleStandardOutNotification:)
                   name:NSFileHandleDataAvailableNotification
                 object:stdOut];
    
    [center addObserver:self
               selector:@selector(handleStandardErrorNotification:) 
                   name:NSFileHandleDataAvailableNotification
                 object:stdErr];

    // we do this for completeness - it is unlikely that we ever see this
    [center addObserver:self
               selector:@selector(handleTaskTerminatedNotification:) 
                   name:NSTaskDidTerminateNotification
                 object:self.task];

    
    [stdOut waitForDataInBackgroundAndNotify];
    [stdErr waitForDataInBackgroundAndNotify];
    
    self.trimSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  }
  return self;
}

/**
 receives a data available notification and attempts to extract the data and
 append it to the stdout data.
 
 uses a try/catch block to handle cases where the data has become unavailable.
 in practice, this can occur when the operation is started and quickly cancelled.
 
 @param aNotification the object of which is the file handle for stdout
 */
- (void) handleStandardOutNotification:(NSNotification *) aNotification {
  //DDLogDebug(@"received standard out notification");
  NSFileHandle *handle = (NSFileHandle *)[aNotification object];
  
  @try {
    NSData *availableData = [handle availableData];
    if ([availableData length] == 0) {
      self.outputClosed = YES;
    } else {
      [self.standardOutput appendData:availableData];
      [handle waitForDataInBackgroundAndNotify];
    }
  }
  @catch (NSException *exception) {
    // this can can happen if the operation is cancelled
    DDLogDebug(@"caught exception - nothing to do: %@", exception);
  }
  @finally {
    
  }
 
}

/**
 receives a data available notification and attempts to extract the data and
 append it to the stderr data.
 
 uses a try/catch block to handle cases where the data has become unavailable.
 in practice, this can occur when the operation is started and quickly cancelled.
 
 @param aNotification the object of which is the file handle for stderr
 */
- (void) handleStandardErrorNotification:(NSNotification *) aNotification {
  //DDLogDebug(@"received standard error notification");
  NSFileHandle *handle = (NSFileHandle *)[aNotification object];
  @try {
    NSData *availableData = [handle availableData];
    if ([availableData length] == 0) {
      self.errorClosed = YES;
    } else {
      [self.standardError appendData:availableData];
      [handle waitForDataInBackgroundAndNotify];
    }

  }
  @catch (NSException *exception) {
    // can happen if the operation is cancelled
    DDLogDebug(@"caught exception - nothing to do: %@", exception);
  }
  @finally {
    
  }
}

/**
 If received, sets the taskComplete property to YES.  However, I have never
 seen this called, although it should be.  See the while loop in the main to 
 see how we check for task completion.
 @param aNotification ignored
 */
- (void) handleTaskTerminatedNotification:(NSNotification *) aNotification {
  //DDLogDebug(@"received task terminated notification");
  self.taskComplete = YES;
}

/**
 @return a string from the data using NSUTF8StringEncoding
 @param aData the data
 */
- (NSString *) stringWithData:(NSData *) aData {
  return [[[NSString alloc] initWithData:aData
                                encoding:NSUTF8StringEncoding]
          autorelease];
}

/**
 @return an error using the exception
 @param aException the exception to make the error from
 */
- (NSError *) errorWithException:(NSException *) aException {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            [aException reason], NSLocalizedDescriptionKey, nil];

  NSError *result = [NSError errorWithDomain:TpUnixOperationTaskErrorDomain
                                        code:TpUnixOperationLaunchErrorCode
                                    userInfo:userInfo];
  return result;
}

/**
 @return an error with a string 
 @param aErrorString a string from stderr
 */
- (NSError *) errorWithStandardErrorString:(NSString *) aErrorString {
  NSError *result = nil;
  if ([aErrorString length] > 0) {
    NSDictionary *userInfo =
    [NSDictionary dictionaryWithObject:aErrorString 
                                forKey:NSLocalizedDescriptionKey];
    result = [NSError
              errorWithDomain:TpUnixOperationTaskErrorDomain
              code:TpUnixOperationExecutionErrorCode 
              userInfo:userInfo];
  }
  return result;
}

/** @name Main Method */

/** 
 Required method for NSOperation subclasses.
 */
- (void) main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  if (![self isCancelled]) {
    //NSString *args = [[self.task arguments] componentsJoinedByString:@" "];
    //DDLogDebug(@"unix operation: %@: %@ %@ has started",
    //           self.commonName, [self.task launchPath], args);
   
    // I do not think this is necessary
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    [self.task setEnvironment:environment];
    
    NSError *launchError = nil;
    NSString *outputString = nil;
    NSString *errorString = nil;

    @try {
      [self.task launch];
 
      // if the stdout and stderr are closed, then the task should be considered
      // done.  we cannot rely on the NSTaskDidTerminateNotification notification
      // to ever be sent.
      while (!self.outputClosed || !self.errorClosed) {

        // DDLogDebug(@"is running       => %d", [self.task isRunning]);
        // DDLogDebug(@"is error closed  => %d", self.errorClosed);
        // DDLogDebug(@"is output closed => %d", self.outputClosed);
        // DDLogDebug(@"is cancelled     => %d", [self isCancelled]);
        // DDLogDebug(@"is complete      => %d", self.taskComplete);
        
        // could be put in the while invariant, but there are so many conditions
        // it becomes unclear what is really driving the loop.
        //
        // what is essential is that if we receive a cancel message
        // we need to respect it (see NSOperation subclassing notes).
        //
        // the taskComplete is syntatic sugar because in practice it is never
        // anything but NO
        if ([self isCancelled] || self.taskComplete) {
          break;
        }
      }
      
      outputString = [self stringWithData:self.standardOutput];
      errorString = [self stringWithData:self.standardError];
      // DDLogDebug(@"output string = %@", outputString);
      // DDLogError(@"error string = %@", errorString);
    } @catch (NSException *exception) {
      DDLogError(@"received this exception: %@", exception);
      launchError = [self errorWithException:exception];
    } @finally {
      if ([self.task isRunning]) {
        // not guaranteed to stop the task
        [self.task terminate];
      }
      [[[self.task standardError] fileHandleForReading] closeFile];
      [[[self.task standardOutput] fileHandleForReading] closeFile];
    }
    
    
    //DDLogDebug(@"operation completed");
    
    NSError *executionError = [self errorWithStandardErrorString:errorString];
    NSInteger taskExitCode = TpUnixOperationExecutionErrorCode;
    if (launchError == nil && ![self.task isRunning]) {
      taskExitCode = [self.task terminationStatus];
    } else {
      taskExitCode = TpUnixOperationTaskStillRunningExitCode;
    }
    
    if (outputString != nil) {
      outputString = [outputString stringByTrimmingCharactersInSet:self.trimSet];
    }
    
    if (errorString != nil) {
      errorString = [errorString stringByTrimmingCharactersInSet:self.trimSet];
    }
    
    TpUnixOperationResult *tResult = [[TpUnixOperationResult alloc] 
                                      initWithCommonName:self.commonName
                                      exitCode:taskExitCode 
                                      launchError:launchError 
                                      executionError:executionError
                                      stdOutput:outputString
                                      errOutput:errorString
                                      launchPath:[self.task launchPath]
                                      arguments:[self.task arguments]
                                      wasCancelled:[self isCancelled]];
                                       
    if (self.callbackDelegate != nil) {
      //DDLogDebug(@"making callback to delegate");
      [self.callbackDelegate operationCompletedWithName:self.commonName
                                                 result:tResult];
      [tResult release];
    } else {
      //DDLogDebug(@"callback delegate is nil - no callback possible");
    }
  }
  [pool release];
}


@end
