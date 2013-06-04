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
