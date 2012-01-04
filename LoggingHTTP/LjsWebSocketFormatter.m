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

#import "LjsWebSocketFormatter.h"
#import "Lumberjack.h"

static NSString * const ERROR_LOG = @"ERROR";
static NSString * const FATAL_LOG = @"FATAL";
static NSString * const WARN_LOG  = @" WARN";
static NSString * const NOTE_LOG  = @" NOTE";
static NSString * const INFO_LOG  = @" INFO";
static NSString * const DEBUG_LOG = @"DEBUG";
static NSString * const SOME_LOG  = @"  LOG";


@implementation LjsWebSocketFormatter

@synthesize formatter;

#pragma mark Memory Management

- (id) init {
	self = [super init];
	if (self != nil) {
		self.formatter = [[NSDateFormatter alloc] init];
    //[self.formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
  }
	return self;
}

- (NSString *)stringFromLogFlag:(int)logFlag {
	NSString *level;
	switch (logFlag) {
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
	return level;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	
	NSString *dateString = [self.formatter stringFromDate:(logMessage->timestamp)];
  NSString *level = [self stringFromLogFlag:logMessage->logFlag];
	NSString *standardResult =  [NSString stringWithFormat:@"%@ %@ %@: %s %i - %@",
                               dateString, level, [logMessage fileName], logMessage->function, logMessage->lineNumber, logMessage->logMsg];
  
//  NSMutableString *webReadyResult = [[standardResult mutableCopy] autorelease];
//  
//  NSUInteger length = [webReadyResult length];
//  [webReadyResult replaceOccurrencesOfString:@"<"  withString:@"&lt;"  options:0 range:NSMakeRange(0, length)];
//  [webReadyResult replaceOccurrencesOfString:@">"  withString:@"&gt;"  options:0 range:NSMakeRange(0, length)];
//  [webReadyResult replaceOccurrencesOfString:@"\n" withString:@"<br/>" options:0 range:NSMakeRange(0, length)];
//  return webReadyResult;
  return  standardResult;
}

@end
