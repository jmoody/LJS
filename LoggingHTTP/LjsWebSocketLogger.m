// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "LjsWebSocketLogger.h"
#import "Lumberjack.h"
#import "LjsHTTPLog.h"


@implementation LjsWebSocketLogger

@synthesize logFormatter;

- (id)initWithWebSocket:(WebSocket *)ws {
	if ((self = [super init])) {
		websocket = ws;
		websocket.delegate = self;
		
		self.logFormatter = [[LjsWebSocketFormatter alloc] init];
		
		// Add our logger
		// 
		// We do this here (as opposed to in webSocketDidOpen:) so the logging framework will retain us.
		// This is important as nothing else is retaining us.
		// It may be a bit hackish, but it's also the simplest solution.
		[DDLog addLogger:self];
	}
	return self;
}

- (void)dealloc {
	[websocket setDelegate:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark WebSocket delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)webSocketDidOpen:(WebSocket *)ws {
 	// This method is invoked on the websocketQueue
	
	isWebSocketOpen = YES;
}

- (void)webSocketDidClose:(WebSocket *)ws {
	// This method is invoked on the websocketQueue
	
	isWebSocketOpen = NO;
	
	// Remove our logger
	[DDLog removeLogger:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DDLogger Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)logMessage:(DDLogMessage *)logMessage {
	if (logMessage->logContext == HTTP_LOG_CONTEXT) {
		// Don't relay HTTP log messages.
		// Doing so could essentially cause an endless loop of log messages.
		
		return;
	}
	
	NSString *logMsg = logMessage->logMsg;
	
	if (self.logFormatter)
  {
    logMsg = [self.logFormatter formatLogMessage:logMessage];
  }
  
	if (logMsg)
	{
		dispatch_async(websocket.websocketQueue, ^{
			
			if (isWebSocketOpen)
			{
				@autoreleasepool {
				
					[websocket sendMessage:logMsg];
				
				}
			}
		});
	}
}




@end
