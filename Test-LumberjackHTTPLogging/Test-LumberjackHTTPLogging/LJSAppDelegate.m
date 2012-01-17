#import "LJSAppDelegate.h"
#import "LJSViewController.h"
#import "Lumberjack.h"
#import "LjsHTTPLog.h"
#import "LjsHTTPLogConnection.h"
#import "HTTPServer.h"
#import "LjsHTTPFileLogger.h"

@class LjsHTTPLogServer;

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LJSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize httpLogManager;
@synthesize logTimer;

- (void) stopAndReleaseRepeatingTimers {
  if (self.logTimer != nil) {
    [self.logTimer invalidate];
    self.logTimer = nil;
  }
}


- (void) startAndRetainRepeatingTimers {
  [self stopAndReleaseRepeatingTimers];
  DDLogDebug(@"starting log heart beat timer");
  self.logTimer = 
  [NSTimer scheduledTimerWithTimeInterval:0.1
                                   target:self
                                 selector:@selector(handleLogTimerEvent:)
                                 userInfo:nil
                                  repeats:YES];
  
}
- (void)dealloc {
  if (self.httpLogManager != nil) {
    [self.httpLogManager stopLogServer];
  }
  [self stopAndReleaseRepeatingTimers];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  DDTTYLogger *tty = [DDTTYLogger sharedInstance];
  [tty setLogFormatter:formatter];
  [DDLog addLogger:tty];

  LjsFileManager *fileManager = [[LjsFileManager alloc] init];
  DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
  [fileLogger setLogFormatter:formatter];
  fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
  [DDLog addLogger:fileLogger];

  
  [self startAndRetainRepeatingTimers];
  
  self.httpLogManager = [[LjsHttpLogManager alloc] initWithShouldPrintLogMessage:YES
                                                                        howOften:0.1];
  [self.httpLogManager startLogServer:YES];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      self.viewController = [[LJSViewController alloc] initWithNibName:@"LJSViewController_iPhone" bundle:nil];
  } else {
      self.viewController = [[LJSViewController alloc] initWithNibName:@"LJSViewController_iPad" bundle:nil];
  }
  

  
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void) handleLogTimerEvent:(NSTimer *)aTimer {
  DDLogDebug(@"handling log timer event");
}


- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This
   can occur for certain types of temporary interruptions (such as an incoming 
   phone call or SMS message) or when the user quits the application and it begins 
   the transition to the background state.
   
   Use this method to pause ongoing tasks, disable timers, and throttle down 
   OpenGL ES frame rates. Games should use this method to pause the game.
   */
  if (self.httpLogManager != nil) {
    [self.httpLogManager stopLogServer];
  }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers,
   and store enough application state information to restore your application to 
   its current state in case it is terminated later. 
   
   If your application supports background execution, this method is called 
   instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of the transition from the background to the inactive state; 
   here you can undo many of the changes made on entering the background.
   */
  if (self.httpLogManager != nil) {
    [self.httpLogManager startLogServer:YES];
  }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application
   was inactive. If the application was previously in the background, optionally
   refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
  if (self.httpLogManager != nil) {
    [self.httpLogManager stopLogServer];
  }
}

@end
