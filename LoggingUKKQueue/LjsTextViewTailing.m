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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTextViewTailing.h"
#import "Lumberjack.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsTextViewTailing

@synthesize logView, logger, logFileSearchTimer;

#pragma mark Memory Management

/**
 implements the LjsRepeatingTimerProtocol
 
 stops the timer, invalidates it, and releases it
 */
- (void) stopAndReleaseRepeatingTimers {
  DDLogDebug(@"stopping animation timer");
  if (self.logFileSearchTimer != nil) {
    [self.logFileSearchTimer invalidate];
    self.logFileSearchTimer = nil;
  }
}

/**
 implements the LjsRepeatingTimerProtocol
 
 stops the timer if non-nil
 starts the timer and retains it
 */
- (void) startAndRetainRepeatingTimers {
  DDLogDebug(@"starting animation timer");
  if (self.logFileSearchTimer != nil) {
    [self stopAndReleaseRepeatingTimers];
  }
  self.logFileSearchTimer = 
  [NSTimer scheduledTimerWithTimeInterval:0.4 
                                   target:self 
                                 selector:@selector(waitForLogFileWithTimer:) 
                                 userInfo:nil 
                                  repeats:YES];
  [[NSRunLoop currentRunLoop] 
   addTimer:self.logFileSearchTimer 
   forMode:NSDefaultRunLoopMode];
}


- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
  [self stopAndReleaseRepeatingTimers];
  [[UKKQueue sharedFileWatcher] removePathFromQueue:[self.logger currentFilePath]];
  [DDLog removeLogger:self.logger];
}

/**
 @return an initialized receiver
 @param aLogView retained by the receiver
 */
- (id) initWithTextView:(NSTextView *) aLogView {
  self = [super init];
  if (self != nil) {
    self.logView = aLogView;
    LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
    self.logger = [[DDFileLogger alloc] init];
    [self.logger setLogFormatter:formatter];
    self.logger.logFileManager.maximumNumberOfLogFiles = 1;
    [DDLog addLogger:self.logger];
    
    DDLogNotice(@"the logging text view needs to allow the user to select the font");
    NSFont *font = [NSFont fontWithName:@"Courier" size:14.0];
    [self.logView setFont:font];
  }
  return self;
}

/**
 handles wait for log file timer event - once the log file is acquired, the
 timer is stopped.
 @param aTimer the timer
 */
- (void) waitForLogFileWithTimer:(NSTimer *) aTimer {
  NSString *filePath = [self.logger currentFilePath];
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    UKKQueue *kq = [UKKQueue sharedFileWatcher]; 
    [kq setDelegate:self];
    [kq addPathToQueue:filePath notifyingAbout:UKKQueueNotifyAboutWrite];
    DDLogDebug(@"now listening for changes on \n%@", filePath);
    [self stopAndReleaseRepeatingTimers];
  }
}

/**
 handles the UKKQueue File Watcher notifications
 @param kq the file watcher
 @param nm the notification received
 @param fpath the file path
 */
-(void) watcher: (id<UKFileWatcher>)kq receivedNotification: (NSString*)nm forPath: (NSString*)fpath {
  NSString *contents = [NSString stringWithContentsOfFile:fpath encoding:NSUTF8StringEncoding error:nil];
  [self.logView setString:contents];
  NSRange range = NSMakeRange ([contents length], 0);
  [self.logView scrollRangeToVisible:range];
}



@end
