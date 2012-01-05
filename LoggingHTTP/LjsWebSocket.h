#import <Foundation/Foundation.h>
#import "WebSocket.h"

@interface LjsWebSocket : WebSocket {
    
}

@property (nonatomic, strong) HTTPMessage *wsResponse;

// overriding super class
- (NSString *)originResponseHeaderValue;
- (NSString *)locationResponseHeaderValue;
- (void)sendResponseHeaders;

@end
