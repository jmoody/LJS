#import "LjsHTTPLogServer.h"
#import "Lumberjack.h"
#import "LjsHTTPConnection.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsHTTPLogServer

@synthesize server;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating LjsHTTPLogServer");
  [server release];
  [super dealloc];
}


- (void)setupLoggingServer {
	// Create server using our custom MyHTTPServer class
	self.server = [[[HTTPServer alloc] init] autorelease];
	
	// Configure it to use our connection class
	[self.server setConnectionClass:[LjsHTTPConnection class]];
	
	// Set the bonjour type of the http server.
	// This allows the server to broadcast itself via bonjour.
	// You can automatically discover the service in Safari's bonjour bookmarks section.
	[self.server setType:@"_http._tcp."];
	
	// Normally there is no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for testing purposes, it may be much easier if the port doesn't change on every build-and-go.
	[self.server setPort:12345];
	
	// Serve files from our embedded Web folder
	NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
	[self.server setDocumentRoot:webPath];
	
	// Start the server (and check for problems)
	
	NSError *error = nil;
	if (![self.server start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
}



@end
