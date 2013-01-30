#import "Lumberjack.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIWindow (Private)
- (void) swizzled_createContext;
@end

@implementation UIWindow (Private)

- (void) swizzled_createContext {
  // nop
}

@end


int main(int argc, char *argv[]) {
  int retVal;
  @autoreleasepool {
    LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
    DDTTYLogger *tty = [DDTTYLogger sharedInstance];
    [tty setLogFormatter:formatter];
    [DDLog addLogger:tty];


    BOOL isCli = getenv("GHUNIT_CLI") ? YES : NO;
    if (isCli == NO) {
      DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
      fileLogger.maximumFileSize = 1024 * 1024;
      fileLogger.rollingFrequency = 60 * 60 * 24;
      fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
      [DDLog addLogger:fileLogger];
    }
    
    CFMessagePortRef portRef = NULL;
    if (isCli == YES) {

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

    retVal = UIApplicationMain(argc, argv, NSStringFromClass([UIApplication class]), @"GHUnitIOSAppDelegate");
    if (portRef != NULL) { CFRelease(portRef); }
  }
  return retVal;
}

