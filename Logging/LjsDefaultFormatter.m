// Copyright (c) 2010, Little Joy Software
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

#import "LjsDefaultFormatter.h"
#import "LjsLog.h"

@implementation LjsDefaultFormatter

static NSString * const ERROR_LOG = @"ERROR";
static NSString * const FATAL_LOG = @"FATAL";
static NSString * const WARN_LOG  = @" WARN";
static NSString * const NOTE_LOG  = @" NOTE";
static NSString * const INFO_LOG  = @" INFO";
static NSString * const DEBUG_LOG = @"DEBUG";
static NSString * const SOME_LOG  = @"  LOG";

// strange, but using this seems to occassionally create
// dates that are not formated correctly
// opting using a string literal
//static NSString * const DATE_FORMAT = @"yyyy-MM-dd HH:mm:ss.SSS";


@synthesize dateFormatter;
@synthesize formatString;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    self.formatString = @"%@ %@ %@: %s %i - %@";
  }
	return self;
}

- (void) dealloc {
	[dateFormatter release];
  [formatString release];
	[super dealloc];
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	
  NSString *level;
	switch (logMessage->logFlag) {
    case LOG_FLAG_FATAL:
      level = FATAL_LOG;
      break;
    case LOG_FLAG_ERROR:
			level = ERROR_LOG;
			break;
		case LOG_FLAG_WARN:
			level = WARN_LOG;
			break;
		case LOG_FLAG_NOTICE:
			level = NOTE_LOG;
			break;
    case LOG_FLAG_INFO:
			level = INFO_LOG;
			break;
    case LOG_FLAG_DEBUG:
			level = DEBUG_LOG;
			break;
		default:
			level = SOME_LOG;
			break;
	}
  
  
  NSString *dateStr = [self.dateFormatter stringFromDate:(logMessage->timestamp)];
  // fixes a problem where by dates are sometimes incorrectly formated
  if ([dateStr length] != 23) {
    //NSDate *thedate = logMessage->timestamp;
    //NSString *oldDateStr = dateStr;
    dateStr = [self.dateFormatter stringFromDate:(logMessage->timestamp)];
    //NSLog(@"CORRECTED: %@ ==> %@ for %@", oldDateStr, dateStr, thedate);
  }
  
  return [NSString stringWithFormat:self.formatString,
          dateStr, 
          level, [logMessage fileName], logMessage->function, 
          logMessage->lineNumber, logMessage->logMsg];
}


@end
