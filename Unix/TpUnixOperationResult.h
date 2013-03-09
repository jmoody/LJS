#import <Foundation/Foundation.h>

/**
 A class for capturing the result of a TpUnixOperation.
 
 @warning This class is only meant to be instatiated by TpUnixOperation.
 */
@interface TpUnixOperationResult : NSObject

/** @name Properties */

/** the name of the operation */
@property (nonatomic, copy) NSString *commonName;
/** the exit code */
@property (nonatomic, assign) NSInteger exitCode;
/** the launch error - nil if there was no error */
@property (nonatomic, retain) NSError *launchError;
/** the execution error - nil if there was no error */
@property (nonatomic, retain) NSError *executionError;
/** the data collected from stdout */
@property (nonatomic, copy) NSString *stdOutput;
/** the data collected from stderr */
@property (nonatomic, copy) NSString *errOutput;
/** the launch path of the command */
@property (nonatomic, retain) NSString *launchPath;
/** the arguments of the command */
@property (nonatomic, retain) NSArray *arguments;
/** true iff the operation was cancelled */
@property (nonatomic, assign) BOOL wasCancelled;

/** @name Memory Management */

/**
 @return an initialized receiver
 @param aCommonName the name of the operation
 @param anExitCode the exit code
 @param aLaunchError the launch error
 @param anExecutionError the execution error
 @param aStdOutput the output to stdout
 @param anErrOutput the output to stderr
 @param aLaunchPath the launch path of the NSTask
 @param aArguments the arguments to NSTask
 @param aWasCancelled true iff the operation was cancelled

 */
- (id) initWithCommonName: (NSString *) aCommonName  
                 exitCode: (NSInteger) anExitCode  
              launchError: (NSError *) aLaunchError  
           executionError: (NSError *) anExecutionError  
                stdOutput: (NSString *) aStdOutput  
                errOutput: (NSString *) anErrOutput
               launchPath:(NSString *) aLaunchPath
                arguments:(NSArray *) aArguments
             wasCancelled:(BOOL) aWasCancelled;

@end
