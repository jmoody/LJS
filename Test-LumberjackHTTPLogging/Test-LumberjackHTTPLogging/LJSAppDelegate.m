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

- (void)dealloc
{
  [_window release];
  [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  DDTTYLogger *tty = [DDTTYLogger sharedInstance];
  [tty setLogFormatter:formatter];
  [DDLog addLogger:tty];
  
  LjsHTTPFileLogger *fileLogger = [LjsHTTPFileLogger sharedInstance];
  fileLogger.maximumFileSize = 1024 * 512;    // 512 KB
  fileLogger.rollingFrequency = 60 * 60 * 24; //  24 Hours
  fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
  [fileLogger setLogFormatter:formatter];
  [DDLog addLogger:fileLogger];
   
  [formatter release];
  LjsHTTPLogServer *httpServer = (LjsHTTPLogServer *)[[HTTPServer alloc] init];
  [httpServer setConnectionClass:[LjsHTTPLogConnection class]];
  [httpServer setType:@"_http._tcp."];
  [httpServer setPort:12345];
  
  NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
  [httpServer setDocumentRoot:webPath];
  NSError *error = nil;
  if (![httpServer start:&error]) {
    DDLogError(@"Error starting HTTP Server: %@", error);
  }

  [NSTimer scheduledTimerWithTimeInterval:1.0
	                                 target:self
	                               selector:@selector(writeLogMessages:)
	                               userInfo:nil
	                                repeats:YES];
  
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      self.viewController = [[[LJSViewController alloc] initWithNibName:@"LJSViewController_iPhone" bundle:nil] autorelease];
  } else {
      self.viewController = [[[LJSViewController alloc] initWithNibName:@"LJSViewController_iPad" bundle:nil] autorelease];
  }
  

  
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)writeLogMessages:(NSTimer *)aTimer {
	// Log a message in verbose mode.
	// 
	// Want to disable this log message?
	// Try setting the log level (at the top of this file) to LOG_LEVEL_WARN.
	// After doing this you can leave the log statement below.
	// It will automatically be compiled out (when compiling in release mode where compiler optimizations are enabled).
	
	DDLogDebug(@"I like cheese");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
