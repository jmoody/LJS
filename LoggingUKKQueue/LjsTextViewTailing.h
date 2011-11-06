#import <Foundation/Foundation.h>
#import "Lumberjack.h"
#import "UKKQueue.h"
#import "LjsRepeatingTimerProtocol.h"

@interface LjsTextViewTailing : NSObject <LjsRepeatingTimerProtocol> {
    
}

@property (nonatomic, retain) NSTextView *logView;
@property (nonatomic, retain) DDFileLogger *logger;
@property (nonatomic, retain) NSTimer *logFileSearchTimer;

- (id) initWithTextView:(NSTextView *) aLogView;

#pragma mark Configure Log View

- (void) waitForLogFileWithTimer:(NSTimer *) timer;
- (void) watcher: (id<UKFileWatcher>)kq receivedNotification: (NSString*)nm forPath: (NSString*)fpath;


@end
