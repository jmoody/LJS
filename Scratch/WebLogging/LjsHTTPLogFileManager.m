#import "LjsHTTPLogFileManager.h"


@implementation LjsHTTPLogFileManager


- (NSString *)defaultLogsDirectory
{
#if TARGET_OS_IPHONE
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
#else
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	
	NSString *appName = [[NSProcessInfo processInfo] processName];
	
	NSString *baseDir = [basePath stringByAppendingPathComponent:appName];
#endif
	return [baseDir stringByAppendingPathComponent:@"WebLogs"];
}





@end
