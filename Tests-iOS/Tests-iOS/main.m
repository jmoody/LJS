#import "Lumberjack.h"
#import "LjsApplicationTestRunnerIOS.h"
#import "LjsGestalt.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIWindow (Private)

- (void) swizzled_createContext;

@end

@implementation UIWindow (Private)

- (void) swizzled_createContext {
  // do nothing
}

@end


int main(int argc, char *argv[]) {
  int retVal;
  
  @autoreleasepool {
    

    LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
    DDTTYLogger *tty = [DDTTYLogger sharedInstance];
    [tty setLogFormatter:formatter];
    [DDLog addLogger:tty];

    LjsGestalt *gestalt = [LjsGestalt new];
    //if ios and command line, dont file log
    if ([gestalt isGhUnitCommandLineBuild] == NO) {
      DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
      fileLogger.maximumFileSize = 1024 * 1024;
      fileLogger.rollingFrequency = 60 * 60 * 24;
      fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
      [DDLog addLogger:fileLogger];
    }
    
    CFMessagePortRef portRef = NULL;
    NSString *GHUNIT_DELEGATE = @"GHUnitIOSAppDelegate";
    if ([gestalt isGhUnitCommandLineBuild] == YES) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
      Method originalWindowCreateContext = class_getInstanceMethod([UIWindow class],
                                                                  @selector(_createContext));
#pragma clang diagnostic pop
      
      Method swizzledWindowCreateConext = class_getInstanceMethod([UIWindow class],
                                                                  @selector(swizzled_createContext));
       method_exchangeImplementations(originalWindowCreateContext,
                                      swizzledWindowCreateConext);
      
      
      portRef = CFMessagePortCreateLocal(NULL,
                                         (CFStringRef) @"PurpleWorkspacePort",
                                         NULL,
                                         NULL,
                                         NULL);
    }


    
  
    //retVal = UIApplicationMain(argc, argv, NSStringFromClass([LjsApplicationTestRunnerIOS class]), GHUNIT_DELEGATE);
    retVal = UIApplicationMain(argc, argv, NSStringFromClass([UIApplication class]), GHUNIT_DELEGATE);
    if (portRef != NULL) {
      CFRelease(portRef);
    }
  }
  return retVal;
}

