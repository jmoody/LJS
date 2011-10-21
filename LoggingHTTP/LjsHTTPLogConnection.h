#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "DDFileLogger.h"


@interface LjsHTTPLogConnection : HTTPConnection

- (id <DDLogFileManager>)logFileManager;
- (WebSocket *)webSocketForURI:(NSString *)path;

@end
