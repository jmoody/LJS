#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "GCDAsyncSocket.h"
#import "HTTPMessage.h"
#import "Lumberjack.h"


@interface LjsHTTPConnection : HTTPConnection {
  
}

@property (nonatomic, retain) DDFileLogger *httpFileLogger;


@end
