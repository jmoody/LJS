// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
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

#import "LjsHttpLogManager.h"

#import "LjsHTTPLogConnection.h"
#import "HTTPServer.h"
#import "LjsHTTPFileLogger.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsHttpLogManager

@synthesize httpLogServer;
@synthesize heartBeatTimer;
@synthesize shouldPrintLogMessage;

#pragma mark Memory Management

- (id) initWithShouldPrintLogMessage:(BOOL) aShouldPrintLogMessage {
  self = [super init];
  if (self != nil) {
    self.shouldPrintLogMessage = aShouldPrintLogMessage;
  }
  return self;
}


- (void) stopAndReleaseLogHeartBeatTimer {
  if (self.heartBeatTimer != nil) {
    [self.heartBeatTimer invalidate];
    heartBeatTimer = nil;
  }
}

- (void) startAndRetainLogHeartBeatTimer {
  if (self.heartBeatTimer != nil) {
    [self stopAndReleaseLogHeartBeatTimer];
  }
  DDLogDebug(@"starting log heart beat timer");
  self.heartBeatTimer = 
  [NSTimer scheduledTimerWithTimeInterval:10.0
                                   target:self
                                 selector:@selector(logServerHeartBeat:)
                                 userInfo:nil
                                  repeats:YES];
  
}

- (void) startAndRetainLogServer {
  DDLogInfo(@"starting http web logging");
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  
  LjsHTTPFileLogger *fileLogger = [LjsHTTPFileLogger sharedInstance];
  fileLogger.maximumFileSize = 1024 * 512;    // 512 KB
  fileLogger.rollingFrequency = 60 * 60 * 24; //  24 Hours
  fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
  [fileLogger setLogFormatter:formatter];
  [DDLog addLogger:fileLogger];
  
  // looks like a leak, but it is not
  self.httpLogServer = [[HTTPServer alloc] init];
  [self.httpLogServer setConnectionClass:[LjsHTTPLogConnection class]];
  [self.httpLogServer setType:@"_http._tcp."];
  [self.httpLogServer setPort:3030];
  
  NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
  [self.httpLogServer setDocumentRoot:webPath];
  NSError *error = nil;
  if (![self.httpLogServer start:&error]) {
    DDLogError(@"Error starting HTTP Server: %@", error);
  }
}

- (void) stopAndReleaseLogServer {
  if (self.httpLogServer != nil) {
    DDLogInfo(@"stopping web log server");
    if ([self.httpLogServer isRunning]) {
      HTTPServer *server = (HTTPServer *)self.httpLogServer;
      [server stop];
      self.httpLogServer = nil;
    } 
  }  
}


- (void) dealloc {
  DDLogDebug(@"deallocating LjsHttpLogManager");
  
}


- (void) startLogServer:(BOOL) aShouldPrintLogMessage {
  self.shouldPrintLogMessage = aShouldPrintLogMessage;
  [self startAndRetainLogServer];
  [self startAndRetainLogHeartBeatTimer];
}

- (void) stopLogServer {
  [self stopAndReleaseLogHeartBeatTimer];
  [self stopAndReleaseLogServer];
}



- (void) logServerHeartBeat:(NSTimer *)aTimer {
  if (self.shouldPrintLogMessage == YES) {
    DDLogDebug(@"the log server's heart is beating");
  }
}



@end
