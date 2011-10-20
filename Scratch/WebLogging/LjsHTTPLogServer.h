
#import <Foundation/Foundation.h>
#import "HTTPServer.h"

@interface LjsHTTPLogServer : NSObject {
    
}

@property (nonatomic, retain) HTTPServer *server;

- (void) setupLoggingServer;

@end
