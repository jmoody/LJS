#import <UIKit/UIKit.h>
#import "Lumberjack.h"
//#import "LjsHTTPLog.h"
//#import "LjsHTTPFileLogger.h"
//#import "HTTPServer.h"
//
//@class LjsHTTPServer;

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *GHUNIT_DELEGATE;
  
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  DDTTYLogger *tty = [DDTTYLogger sharedInstance];
  [tty setLogFormatter:formatter];
  [DDLog addLogger:tty];
 
//  
//  LjsHTTPFileLogger *fileLogger = [LjsHTTPFileLogger sharedInstance];
//  fileLogger.maximumFileSize = 1024 * 512;    // 512 KB
//  fileLogger.rollingFrequency = 60 * 60 * 24; //  24 Hours
//  fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
//  [fileLogger setLogFormatter:formatter];
//  [DDLog addLogger:fileLogger];
//  
//  LjsHTTPServer *httpServer = (LjsHTTPServer *)[[HTTPServer alloc] init];
//  [httpServer setConnectionClass:[LjsHTTPLogConnection class]];
//  [httpServer setType:@"_http._tcp."];
//  [httpServer setPort:12345];
//  
//  NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
//  [httpServer setDocumentRoot:webPath];
//
//  NSError *error = nil;
//  if (![httpServer start:&error]) {
//    NSLog(@"Error starting HTTP Server: %@", error);
//  }
//  
  [formatter release];
#if TARGET_IPHONE_SIMULATOR 
  GHUNIT_DELEGATE = @"GHUnitIPhoneAppDelegate";
#else
  GHUNIT_DELEGATE = @"GHUnitIOSAppDelegate";
#endif
  int retVal = UIApplicationMain(argc, argv, nil, GHUNIT_DELEGATE);
  [pool release];
  return retVal;
}

