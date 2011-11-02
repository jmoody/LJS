#import <UIKit/UIKit.h>
#import "Lumberjack.h"

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *GHUNIT_DELEGATE;
  
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  DDTTYLogger *tty = [DDTTYLogger sharedInstance];
  [tty setLogFormatter:formatter];
  [DDLog addLogger:tty];
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

