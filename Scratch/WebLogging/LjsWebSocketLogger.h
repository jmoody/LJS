#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "WebSocket.h"


@interface LjsWebSocketLogger : DDAbstractLogger <DDLogger>
{
	WebSocket *websocket;
	BOOL isWebSocketOpen;
}

- (id)initWithWebSocket:(WebSocket *)ws;

@end

@interface LjsWebSocketFormatter : NSObject <DDLogFormatter>
{
	NSDateFormatter *dateFormatter;
}

@end
