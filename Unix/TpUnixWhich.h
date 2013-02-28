#import <Foundation/Foundation.h>
#import "TpUnixOperation.h"

/**
 A helper class for asynchronous finding of unix paths using the `which` command.
 Standard paths are always available, but are changed if the which comes back
 with different information.
 
 @warning I do not expect that defaults, ifconfig, and ipconfig will change but
 some users like to muck with things - and those users will be on the look out
 for tools that do not pick up their particular configurations.
 */
@interface TpUnixWhich : NSObject <TpUnixOperationCallbackDelegate>

/** @name Properties */
/** the path to ifconfig */
@property (nonatomic, copy) NSString *ifconfigLaunchPath;
/** the path to ipconfig - only used in a test*/
@property (nonatomic, copy) NSString *ipconfigLaunchPath;
/** the path to defaults */
@property (nonatomic, copy) NSString *defaultsLaunchPath;
/** the operation queue */
@property (atomic, retain) NSOperationQueue *opqueue;

/** @name Async Find Launch Paths */
/**
 starts an async find of ifconfig launch path
 */
- (void) asyncFindIfConfigLaunchPath;

/**
 starts an async find of ipconfig launch path
 */
- (void) asyncFindIpConfigLaunchPath;

/**
 starts an async find of defaults launch path
 */
- (void) asyncFindDefaultsLaunchPath;


@end
