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
  DDLogDebug(@"deallocating LjsTextViewTailing");
  [self stopAndReleaseRepeatingTimers];
  [[UKKQueue sharedFileWatcher] removePathFromQueue:[self.logger currentFilePath]];
  [DDLog removeLogger:self.logger];
  self.logView = nil;
  self.logger = nil;
  [super dealloc];
}

/**
 @return an initialized receiver
 @param aLogView retained by the receiver
 */
- (id) initWithTextView:(NSTextView *) aLogView {
  self = [super init];
  if (self != nil) {
    self.logView = aLogView;
    LjsDefaultFormatter *formatter = [[[LjsDefaultFormatter alloc] init] autorelease];
    self.logger = [[[DDFileLogger alloc] init] autorelease];
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
