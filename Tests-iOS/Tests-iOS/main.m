#import "Lumberjack.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    
    LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
    DDTTYLogger *tty = [DDTTYLogger sharedInstance];
    [tty setLogFormatter:formatter];
    [DDLog addLogger:tty];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.maximumFileSize = 1024 * 1024;
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    [DDLog addLogger:fileLogger];

    NSString *GHUNIT_DELEGATE;
    int retVal;
    
#if TARGET_IPHONE_SIMULATOR 
    GHUNIT_DELEGATE = @"GHUnitIPhoneAppDelegate";
#else
    GHUNIT_DELEGATE = @"GHUnitIOSAppDelegate";
#endif

    if (getenv("GHUNIT_CLI")) {
      retVal = [GHTestRunner run];
    } else {
      retVal = UIApplicationMain(argc, argv, nil, GHUNIT_DELEGATE);
    }
  }
}

