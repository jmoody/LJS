#import "TpUnixOperationResult.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation TpUnixOperationResult

#pragma mark Memory Management

@synthesize commonName;
@synthesize exitCode;
@synthesize launchError;
@synthesize executionError;
@synthesize stdOutput;
@synthesize errOutput;
@synthesize launchPath;
@synthesize arguments;
@synthesize wasCancelled;

- (void) dealloc {
  //DDLogDebug(@"deallocating TpUnixOperationResult");
  self.commonName = nil;
  self.launchError = nil;
  self.executionError = nil;
  self.stdOutput = nil;
  self.errOutput = nil;
  self.launchPath = nil;
  self.arguments = nil;
  [super dealloc];
}

- (id) initWithCommonName:  (NSString *) aCommonName  
                 exitCode: (NSInteger) anExitCode  
              launchError: (NSError *) aLaunchError  
           executionError: (NSError *) anExecutionError 
                stdOutput: (NSString *) aStdOutput  
                errOutput: (NSString *) anErrOutput 
               launchPath:(NSString *)aLaunchPath 
                arguments:(NSArray *)aArguments 
             wasCancelled:(BOOL)aWasCancelled {
  self = [super init];
  if (self) {
    self.commonName = aCommonName;
    self.exitCode = anExitCode;
    self.launchError = aLaunchError;
    self.executionError = anExecutionError;
    self.stdOutput = aStdOutput;
    self.errOutput = anErrOutput;
    self.launchPath = aLaunchPath;
    self.arguments = aArguments;
    self.wasCancelled = aWasCancelled;
  }
  return self;
}

- (NSString *) description {
  return [NSString stringWithFormat:@"%@: %ld %@ %@", 
          self.commonName, self.exitCode, self.stdOutput, self.errOutput];
}

@end
