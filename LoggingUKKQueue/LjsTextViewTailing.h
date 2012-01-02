#import <Foundation/Foundation.h>
#import "Lumberjack.h"
#import "UKKQueue.h"
#import "LjsRepeatingTimerProtocol.h"

/**
 LjsTextViewTailing provides an interface into Uli Kusterer's UKKQueue
 
 The class contains an NSTextView configured to listen to a log file.
 
 UKKQueue license:
 
 (c) 2003-06 by M. Uli Kusterer. You may redistribute, modify, use in
 commercial products free of charge, however distributing modified copies
 requires that you clearly mark them as having been modified by you, while
 maintaining the original markings and copyrights. I don't like getting bug
 reports about code I wasn't involved in.
 
 I'd also appreciate if you gave credit in your app's about screen or a similar
 place. A simple "Thanks to M. Uli Kusterer" is quite sufficient.
 Also, I rarely turn down any postcards, gifts, complementary copies of
 applications etc.

 Thank you Uli.
 
 */
@interface LjsTextViewTailing : NSObject <LjsRepeatingTimerProtocol> 

/** @name Properties */
/**
 the log view
 */
@property (nonatomic, strong) NSTextView *logView;

/**
 the logger
 */
@property (nonatomic, strong) DDFileLogger *logger;


/**
 the file search timer - watches for the log file and stops once the file is
 acquired
 */
@property (nonatomic, strong) NSTimer *logFileSearchTimer;

/** @name Initialization */
- (id) initWithTextView:(NSTextView *) aLogView;

#pragma mark Configure Log View

/** @name Handling Timer Events and File Watcher Notifications */
- (void) waitForLogFileWithTimer:(NSTimer *) timer;
- (void) watcher: (id<UKFileWatcher>)kq receivedNotification: (NSString*)nm forPath: (NSString*)fpath;

/** @name LjsRepeatingTimerProtocol */
- (void) stopAndReleaseRepeatingTimers;
- (void) startAndRetainRepeatingTimers;

@end
